import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExamStatusBadge extends StatefulWidget {
  final Lesson lesson;
  final bool isCompleted;

  const ExamStatusBadge({
    super.key,
    required this.lesson,
    required this.isCompleted,
  });

  @override
  State<ExamStatusBadge> createState() => _ExamStatusBadgeState();
}

class _ExamStatusBadgeState extends State<ExamStatusBadge> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompleted) {
      return _buildBadge(
        'Completed',
        Colors.green,
        FontAwesomeIcons.circleCheck,
      );
    }

    final scheduledAt = widget.lesson.scheduledAt;
    final expiresAt = widget.lesson.expiresAt;

    if (expiresAt != null && _now.isAfter(expiresAt)) {
      return _buildBadge('Expired', Colors.red, FontAwesomeIcons.calendarXmark);
    }

    if (scheduledAt != null && _now.isBefore(scheduledAt)) {
      final difference = scheduledAt.difference(_now);
      return _buildBadge(
        _formatDuration(difference),
        Colors.orange.shade700,
        FontAwesomeIcons.clock,
        isCountdown: true,
      );
    }

    return _buildBadge(
      'Available Now',
      const Color(0xFF1E3A8A),
      FontAwesomeIcons.boltLightning,
    );
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) {
      return '${d.inDays}d ${d.inHours % 24}h';
    }
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildBadge(
    String text,
    Color color,
    IconData icon, {
    bool isCountdown = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: isCountdown ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}
