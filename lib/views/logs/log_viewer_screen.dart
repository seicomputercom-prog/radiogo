import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/log_view_controller.dart';
import '../../services/log_service.dart';
import '../../theme/app_colors.dart';

class LogViewerScreen extends GetView<LogViewController> {
  const LogViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = controller.logController;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text(
          'DEV LOGS',
          style: TextStyle(
            color: AppColors.accentGreen,
            fontFamily: 'Orbitron',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'copy':
                  await controller.copyLogs();
                  Get.snackbar('Copied', 'Logs copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF0D1117),
                    colorText: AppColors.accentGreen);
                  break;
                case 'share':
                  await controller.shareLogs();
                  Get.snackbar('Exported', 'Log content copied',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF0D1117),
                    colorText: AppColors.accentGreen);
                  break;
                case 'clear':
                  await _showClearDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'copy', child: Text('Copy All', style: TextStyle(fontFamily: 'ShareTechMono'))),
              const PopupMenuItem(value: 'share', child: Text('Export', style: TextStyle(fontFamily: 'ShareTechMono'))),
              const PopupMenuItem(value: 'clear', child: Text('Clear All', style: TextStyle(fontFamily: 'ShareTechMono', color: AppColors.errorRed))),
            ],
            icon: const Icon(Icons.more_vert, color: AppColors.accentGreen),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsBar(lc),
          _buildFilterBar(lc),
          Expanded(child: Obx(() {
            final entries = lc.filteredEntries;
            if (entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.terminal, color: AppColors.accentGreen.withAlpha(60), size: 48),
                    const SizedBox(height: 16),
                    const Text('No logs yet',
                      style: TextStyle(color: AppColors.textSecondary, fontFamily: 'ShareTechMono', fontSize: 14)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: entries.length,
              itemBuilder: (context, index) => _LogEntryWidget(entry: entries[index]),
            );
          })),
        ],
      ),
    );
  }

  Widget _buildStatsBar(LogController lc) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFF0D1117),
      child: Row(
        children: [
          _statChip('Total', '${lc.totalLogs.value}', AppColors.accentGreen),
          const SizedBox(width: 12),
          _statChip('Errors', '${lc.errorCount.value}', AppColors.errorRed),
          const SizedBox(width: 12),
          _statChip('Warnings', '${lc.warnCount.value}', const Color(0xFFFFB000)),
          const Spacer(),
          FutureBuilder<String>(
            future: controller.getLogSizeText(),
            builder: (_, snap) => Text(
              snap.data ?? '...',
              style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'ShareTechMono', fontSize: 10),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _statChip(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text('$label: $value',
          style: const TextStyle(color: AppColors.textWhite, fontFamily: 'ShareTechMono', fontSize: 11)),
      ],
    );
  }

  Widget _buildFilterBar(LogController lc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: const Color(0xFF0D1117),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: LogLevel.values.map((level) {
                return Obx(() {
                  final isActive = lc.filterLevel.value == level;
                  final color = _levelColor(level);
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => lc.filterLevel.value = level,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? color.withAlpha(40) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isActive ? color : color.withAlpha(60)),
                        ),
                        child: Text(level.label,
                          style: TextStyle(
                            color: isActive ? color : color.withAlpha(120),
                            fontFamily: 'ShareTechMono',
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          )),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.accentGreen.withAlpha(40)),
            ),
            child: TextField(
              onChanged: (v) => lc.searchQuery.value = v,
              style: const TextStyle(color: AppColors.textWhite, fontFamily: 'ShareTechMono', fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Filter logs...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withAlpha(120), fontFamily: 'ShareTechMono', fontSize: 12),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug: return const Color(0xFF888888);
      case LogLevel.info: return const Color(0xFF00BFFF);
      case LogLevel.warn: return const Color(0xFFFFB000);
      case LogLevel.error: return const Color(0xFFFF4444);
      case LogLevel.fatal: return const Color(0xFFFF0040);
    }
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Clear All Logs?',
          style: TextStyle(color: AppColors.accentGreen, fontFamily: 'Orbitron', fontSize: 16)),
        content: const Text('This will delete all log entries and log files.',
          style: TextStyle(color: AppColors.textWhite, fontFamily: 'ShareTechMono')),
        actions: [
          TextButton(onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'ShareTechMono'))),
          TextButton(onPressed: () => Get.back(result: true),
            child: const Text('Clear', style: TextStyle(color: AppColors.errorRed, fontFamily: 'ShareTechMono', fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (confirm == true) await controller.clearAll();
  }
}

class _LogEntryWidget extends StatelessWidget {
  final LogEntry entry;
  const _LogEntryWidget({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = _colorForLevel(entry.level);
    final time = '${entry.timestamp.hour.toString().padLeft(2, '0')}:'
        '${entry.timestamp.minute.toString().padLeft(2, '0')}:'
        '${entry.timestamp.second.toString().padLeft(2, '0')}.'
        '${entry.timestamp.millisecond.toString().padLeft(3, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: entry.level.isErrorOrAbove ? color.withAlpha(15) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: entry.level == LogLevel.fatal ? Border.all(color: AppColors.errorRed.withAlpha(60)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
              Text(time, style: TextStyle(color: color.withAlpha(180), fontFamily: 'ShareTechMono', fontSize: 10)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(3)),
                child: Text(entry.level.label,
                  style: TextStyle(color: color, fontFamily: 'ShareTechMono', fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text('[${entry.tag}]',
                  style: TextStyle(color: AppColors.accentGreen.withAlpha(150), fontFamily: 'ShareTechMono', fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(entry.message,
              style: const TextStyle(color: AppColors.textWhite, fontFamily: 'ShareTechMono', fontSize: 12, height: 1.4)),
          ),
          if (entry.error != null)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 2),
              child: Text(entry.error!,
                style: TextStyle(color: AppColors.errorRed.withAlpha(200), fontFamily: 'ShareTechMono', fontSize: 11)),
            ),
          if (entry.stackTrace != null)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 2),
              child: Text(entry.stackTrace!, maxLines: 5, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary.withAlpha(150), fontFamily: 'ShareTechMono', fontSize: 10)),
            ),
        ],
      ),
    );
  }

  Color _colorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug: return const Color(0xFF888888);
      case LogLevel.info: return const Color(0xFF00BFFF);
      case LogLevel.warn: return const Color(0xFFFFB000);
      case LogLevel.error: return const Color(0xFFFF4444);
      case LogLevel.fatal: return const Color(0xFFFF0040);
    }
  }
}
