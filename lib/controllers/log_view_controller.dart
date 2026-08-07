import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../services/log_service.dart';

/// Controller for the log viewer screen.
class LogViewController extends GetxController {
  final LogController logController = LogController();

  /// Copy all filtered logs to clipboard.
  Future<void> copyLogs() async {
    final logs = logController.filteredEntries
        .map((e) => e.toFormattedString())
        .join();
    await Clipboard.setData(ClipboardData(text: logs));
  }

  /// Share/export logs as a file.
  Future<void> shareLogs() async {
    final content = await LogService.I.exportLogs();
    final dir = await Directory.systemTemp.createTemp();
    final file = File('${dir.path}/radiogo-logs.txt');
    await file.writeAsString(content);
    // Use share if available, fallback to clipboard
    try {
      await Clipboard.setData(ClipboardData(text: content));
    } catch (_) {}
  }

  /// Clear all logs and files.
  Future<void> clearAll() async {
    await LogService.I.clearAllLogs();
  }

  /// Get formatted file size string.
  Future<String> getLogSizeText() async {
    final bytes = await LogService.I.getTotalLogSize();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}