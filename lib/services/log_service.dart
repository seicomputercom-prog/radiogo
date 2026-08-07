import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Log level severity.
enum LogLevel {
  debug('DEBUG'),
  info('INFO'),
  warn('WARN'),
  error('ERROR'),
  fatal('FATAL');

  const LogLevel(this.label);
  final String label;

  int get priority => index;

  bool get isErrorOrAbove => priority >= LogLevel.error.priority;
}

/// Single log entry.
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final String? stackTrace;
  final String? error;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.stackTrace,
    this.error,
  });

  String toFormattedString() {
    final ts = DateFormat('HH:mm:ss.SSS').format(timestamp);
    final date = DateFormat('yyyy-MM-dd').format(timestamp);
    final buffer = StringBuffer();
    buffer.writeln('[$date $ts] [${level.label}] [$tag] $message');
    if (error != null) buffer.writeln('  ERROR: $error');
    if (stackTrace != null) buffer.writeln('  STACK: $stackTrace');
    return buffer.toString();
  }

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.label,
    'levelPriority': level.priority,
    'tag': tag,
    'message': message,
    'error': error,
    'stackTrace': stackTrace,
  };

  factory LogEntry.fromMap(Map<String, dynamic> m) => LogEntry(
    timestamp: DateTime.parse(m['timestamp'] as String),
    level: LogLevel.values.firstWhere(
      (l) => l.label == m['level'],
      orElse: () => LogLevel.info,
    ),
    tag: m['tag'] as String? ?? '',
    message: m['message'] as String? ?? '',
    error: m['error'] as String?,
    stackTrace: m['stackTrace'] as String?,
  );
}

/// Reactive log controller for the UI.
class LogController extends GetxController {
  final RxList<LogEntry> entries = <LogEntry>[].obs;
  final Rx<LogLevel> filterLevel = LogLevel.debug.obs;
  final RxString searchQuery = ''.obs;
  final RxInt totalLogs = 0.obs;
  final RxInt errorCount = 0.obs;
  final RxInt warnCount = 0.obs;
  final RxBool autoScroll = true.obs;

  List<LogEntry> get filteredEntries {
    var result = entries.where((e) => e.level.priority >= filterLevel.value.priority).toList();
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((e) =>
        e.message.toLowerCase().contains(q) ||
        e.tag.toLowerCase().contains(q) ||
        (e.error?.toLowerCase().contains(q) ?? false)
      ).toList();
    }
    return result;
  }

  void addEntry(LogEntry entry) {
    entries.insert(0, entry);
    totalLogs.value = entries.length;
    if (entry.level == LogLevel.error || entry.level == LogLevel.fatal) {
      errorCount.value++;
    } else if (entry.level == LogLevel.warn) {
      warnCount.value++;
    }
    // Cap at 5000 entries in memory
    if (entries.length > 5000) {
      entries.removeRange(5000, entries.length);
    }
  }

  void clearLogs() {
    entries.clear();
    totalLogs.value = 0;
    errorCount.value = 0;
    warnCount.value = 0;
  }
}

/// Core logging service. Singleton, initialized in main().
///
/// Usage:
/// ```dart
/// LogService.i('StationsController', 'Loaded 50 stations');
/// LogService.e('API', 'Request failed', error: e, stackTrace: st);
/// ```
class LogService {
  static LogService? _instance;
  static LogService get I => _instance!;

  LogController? _controller;
  File? _logFile;
  StreamSubscription<String>? _fileSub;
  final DateFormat _fmt = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  static const int _maxFileSizeBytes = 2 * 1024 * 1024; // 2 MB
  static const int _maxBackupFiles = 3;

  LogService._();

  /// Initialize the logging system. Call once in main() after ensureInitialized().
  static Future<LogService> init() async {
    if (_instance != null) return _instance!;
    _instance = LogService._();
    await _instance!._init();
    return _instance!;
  }

  Future<void> _init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');
      if (!await logDir.exists()) await logDir.create(recursive: true);
      _logFile = File('${logDir.path}/radio-go.log');
      await _rotateIfNeeded();
      i('LogService', 'Logging initialized. File: ${_logFile!.path}');
    } catch (e) {
      debugPrint('[LogService] Failed to init file logging: $e');
    }

    // Intercept Flutter errors
    FlutterError.onError = (details) {
      e('Flutter', details.exceptionAsString(),
        error: details.exceptionAsString(),
        stackTrace: details.stack?.toString());
    };

    // Intercept uncaught async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      fatal('Uncaught', 'Unhandled async error',
        error: error.toString(), stackTrace: stack.toString());
      return true;
    };
  }

  /// Attach a LogController (called from UI binding).
  void attachController(LogController ctrl) {
    _controller = ctrl;
  }

  // ---- Core log methods ----

  void d(String tag, String message, {String? error, String? stackTrace}) {
    _log(LogLevel.debug, tag, message, error: error, stackTrace: stackTrace);
  }

  void i(String tag, String message, {String? error, String? stackTrace}) {
    _log(LogLevel.info, tag, message, error: error, stackTrace: stackTrace);
  }

  void w(String tag, String message, {String? error, String? stackTrace}) {
    _log(LogLevel.warn, tag, message, error: error, stackTrace: stackTrace);
  }

  void e(String tag, String message, {String? error, String? stackTrace}) {
    _log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  }

  void fatal(String tag, String message, {String? error, String? stackTrace}) {
    _log(LogLevel.fatal, tag, message, error: error, stackTrace: stackTrace);
  }

  void _log(LogLevel level, String tag, String message, {
    String? error, String? stackTrace,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    // Print to debug console
    final prefix = '[${level.label}] [$tag]';
    if (level.isErrorOrAbove) {
      debugPrint('$prefix $message');
      if (error != null) debugPrint('  ERROR: $error');
      if (stackTrace != null) debugPrint('  STACK: $stackTrace');
    } else {
      debugPrint('$prefix $message');
    }

    // Notify UI controller
    _controller?.addEntry(entry);

    // Write to file (async, non-blocking)
    _writeToFile(entry.toFormattedString());
  }

  Future<void> _writeToFile(String text) async {
    try {
      await _logFile?.writeAsString(text, mode: FileMode.append);
    } catch (e) {
      debugPrint('[LogService] Write failed: $e');
    }
  }

  Future<void> _rotateIfNeeded() async {
    if (_logFile == null) return;
    try {
      if (await _logFile!.exists()) {
        final size = await _logFile!.length();
        if (size > _maxFileSizeBytes) {
          for (int i = _maxBackupFiles; i > 0; i--) {
            final older = File('${_logFile!.parent.path}/radio-go.log.$i');
            final newer = File('${_logFile!.parent.path}/radio-go.log.${i - 1}');
            if (await newer.exists()) await newer.rename(older.path);
          }
          final backup = File('${_logFile!.parent.path}/radio-go.log.0');
          await _logFile!.rename(backup.path);
        }
      }
    } catch (e) {
      debugPrint('[LogService] Rotation failed: $e');
    }
  }

  /// Export all logs as a single string.
  Future<String> exportLogs() async {
    final buffer = StringBuffer();
    buffer.writeln('=== RadioGo Log Export ===');
    buffer.writeln('Generated: ${_fmt.format(DateTime.now())}');
    buffer.writeln('=============================');

    // Current log file
    if (_logFile != null && await _logFile!.exists()) {
      buffer.writeln('\n--- Current Log ---');
      buffer.writeln(await _logFile!.readAsString());
    }

    // Backup files
    for (int i = 0; i <= _maxBackupFiles; i++) {
      final backup = File('${_logFile!.parent.path}/radio-go.log.$i');
      if (await backup.exists()) {
        buffer.writeln('\n--- Backup Log ($i) ---');
        buffer.writeln(await backup.readAsString());
      }
    }

    return buffer.toString();
  }

  /// Get log file size info.
  Future<Map<String, int>> getLogFileInfo() async {
    final result = <String, int>{};
    if (_logFile == null) return result;
    if (await _logFile!.exists()) {
      result['current'] = await _logFile!.length();
    }
    for (int i = 0; i <= _maxBackupFiles; i++) {
      final backup = File('${_logFile!.parent.path}/radio-go.log.$i');
      if (await backup.exists()) {
        result['backup_$i'] = await backup.length();
      }
    }
    return result;
  }

  /// Clear all log files.
  Future<void> clearAllLogs() async {
    _controller?.clearLogs();
    try {
      if (_logFile != null && await _logFile!.exists()) {
        await _logFile!.writeAsString('');
      }
      for (int i = 0; i <= _maxBackupFiles; i++) {
        final backup = File('${_logFile!.parent.path}/radio-go.log.$i');
        if (await backup.exists()) await backup.delete();
      }
    } catch (e) {
      debugPrint('[LogService] Clear failed: $e');
    }
  }

  /// Get total log file size in bytes.
  Future<int> getTotalLogSize() async {
    final info = await getLogFileInfo();
    return info.values.fold(0, (a, b) => a + b);
  }
}
