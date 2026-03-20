import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduassess_student/features/lessons/presentation/providers/lessons_notifier.dart';
import 'package:eduassess_student/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:eduassess_student/features/auth/presentation/providers/auth_notifier.dart';
import 'package:eduassess_student/features/auth/presentation/providers/profile_provider.dart';
import 'package:eduassess_student/features/lessons/presentation/providers/completed_lessons_provider.dart';
import 'package:eduassess_student/features/announcements/presentation/providers/announcements_provider.dart';
import 'package:eduassess_student/features/announcements/domain/models/announcement.dart';
import 'package:eduassess_student/core/widgets/shimmer_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eduassess_student/core/error/failure.dart';
import '../widgets/exam_status_badge.dart';

enum _ExamFilter { all, completed, pending, upcoming, past }

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final user = ref.watch(authNotifierProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final progressAsync = ref.watch(lessonProgressProvider);
    final announcementsAsync = ref.watch(announcementsProvider);
    final selectedFilter = ref.watch(_examFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: Stack(
        children: [
          const _Backdrop(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _TopBar(
                  profileAsync: profileAsync,
                  user: user,
                  onRefresh: () {
                    ref.read(lessonsNotifierProvider.notifier).refresh();
                    ref.invalidate(lessonProgressProvider);
                    ref.invalidate(userProfileProvider);
                    ref.invalidate(announcementsProvider);
                  },
                  onLogout: () {
                    ref.read(authNotifierProvider.notifier).signOut();
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: _SectionTitle(
                    title: 'إعلانات المعلم',
                    subtitle: 'آخر التنبيهات والملاحظات',
                    icon: FontAwesomeIcons.solidBell,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: announcementsAsync.when(
                    data: (items) => _AnnouncementsPanel(items: items),
                    loading: () => const CodeKeyShimmer.rectangular(height: 140),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _ExamFilterBar(
                    selected: selectedFilter,
                    onSelected: (filter) =>
                        ref.read(_examFilterProvider.notifier).state = filter,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                  child: _SectionTitle(
                    title: 'الامتحانات القادمة',
                    subtitle: 'قائمة الامتحانات المتاحة',
                    icon: FontAwesomeIcons.clipboardList,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: lessonsAsync.when(
                  data: (lessons) {
                    final now = DateTime.now();
                    final visibleLessons = progressAsync.maybeWhen(
                      data: (progressMap) {
                        bool isCompleted(dynamic lesson) =>
                            progressMap.containsKey(lesson.id);
                        bool isPast(dynamic lesson) =>
                            lesson.expiresAt != null &&
                            now.isAfter(lesson.expiresAt!);

                        switch (selectedFilter) {
                          case _ExamFilter.completed:
                            return lessons
                                .where((lesson) => isCompleted(lesson))
                                .toList();
                          case _ExamFilter.past:
                            return lessons
                                .where((lesson) =>
                                    !isCompleted(lesson) && isPast(lesson))
                                .toList();
                          case _ExamFilter.pending:
                            return lessons
                                .where((lesson) =>
                                    !isCompleted(lesson) &&
                                    !isPast(lesson) &&
                                    !(lesson.scheduledAt != null &&
                                        now.isBefore(lesson.scheduledAt!)))
                                .toList();
                          case _ExamFilter.upcoming:
                            return lessons
                                .where((lesson) =>
                                    !isCompleted(lesson) &&
                                    lesson.scheduledAt != null &&
                                    now.isBefore(lesson.scheduledAt!))
                                .toList();
                          case _ExamFilter.all:
                            return lessons;
                        }
                      },
                      orElse: () => lessons,
                    );

                    if (visibleLessons.isEmpty) {
                      return const SliverFillRemaining(child: _EmptyState());
                    }

                    return progressAsync.when(
                      data: (progressMap) => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final lesson = visibleLessons[index];
                          final progress = progressMap[lesson.id];
                          final isCompleted = progress != null;
                          return _AnimatedExamTile(
                            index: index,
                            child: _LessonTile(
                              lesson: lesson,
                              progress: progress,
                              isCompleted: isCompleted,
                              onTap: () async {
                                final now = DateTime.now();
                                final scheduledAt = lesson.scheduledAt;
                                final expiresAt = lesson.expiresAt;

                                if (!isCompleted &&
                                    scheduledAt != null &&
                                    now.isBefore(scheduledAt)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'يبدأ الامتحان بعد ${scheduledAt.difference(now).inMinutes} دقيقة',
                                      ),
                                      backgroundColor: const Color(0xFFB45309),
                                    ),
                                  );
                                  return;
                                }

                                if (!isCompleted &&
                                    expiresAt != null &&
                                    now.isAfter(expiresAt)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'انتهت صلاحية هذا الامتحان.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuizScreen(lessonId: lesson.id),
                                  ),
                                );
                                ref.invalidate(lessonProgressProvider);
                              },
                            ),
                          );
                        }, childCount: visibleLessons.length),
                      ),
                      loading: () => const SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: LessonListShimmer(),
                        ),
                      ),
                      error: (error, stack) => _ErrorState(ref: ref, error: error),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: LessonListShimmer(),
                    ),
                  ),
                  error: (error, stack) => _ErrorState(ref: ref, error: error),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ],
      ),
    );
  }
}

final _examFilterProvider = StateProvider<_ExamFilter>(
  (ref) => _ExamFilter.all,
);

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF7F4EF), Color(0xFFEDE6D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3B82F6).withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          top: 140,
          right: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -40,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF97316).withOpacity(0.09),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final AsyncValue profileAsync;
  final dynamic user;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  const _TopBar({
    required this.profileAsync,
    required this.user,
    required this.onRefresh,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                FontAwesomeIcons.userAstronaut,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileAsync.when(
                    data: (profile) {
                      final name =
                          profile?['full_name'] ??
                          user?.fullName ??
                          user?.username ??
                          'طالب';
                      return Text(
                        'مرحباً $name',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => Text(
                      'مرحباً بك',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'جهّز تركيزك، الامتحانات جاهزة لك.',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _TopIconButton(
                  icon: Icons.refresh_rounded,
                  onTap: onRefresh,
                ),
                const SizedBox(height: 10),
                _TopIconButton(
                  icon: FontAwesomeIcons.rightFromBracket,
                  iconSize: 14,
                  color: const Color(0xFFB91C1C),
                  onTap: onLogout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color? color;
  final VoidCallback onTap;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
    this.iconSize = 18,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize,
          color: color ?? const Color(0xFF1F2937),
        ),
      ),
    );
  }
}

class _ExamFilterBar extends StatelessWidget {
  final _ExamFilter selected;
  final ValueChanged<_ExamFilter> onSelected;

  const _ExamFilterBar({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _FilterChip(
          label: 'الكل',
          isActive: selected == _ExamFilter.all,
          onTap: () => onSelected(_ExamFilter.all),
        ),
        _FilterChip(
          label: 'تم الحل',
          isActive: selected == _ExamFilter.completed,
          onTap: () => onSelected(_ExamFilter.completed),
        ),
        _FilterChip(
          label: 'غير محلولة',
          isActive: selected == _ExamFilter.pending,
          onTap: () => onSelected(_ExamFilter.pending),
        ),
        _FilterChip(
          label: 'قادمة',
          isActive: selected == _ExamFilter.upcoming,
          onTap: () => onSelected(_ExamFilter.upcoming),
        ),
        _FilterChip(
          label: 'منتهية',
          isActive: selected == _ExamFilter.past,
          onTap: () => onSelected(_ExamFilter.past),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1D4ED8) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            color: isActive ? Colors.white : const Color(0xFF475569),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF1E3A8A).withOpacity(0.12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnnouncementsPanel extends StatelessWidget {
  final List<Announcement> items;

  const _AnnouncementsPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.campaign_outlined, color: Color(0xFF64748B)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'لا توجد إعلانات جديدة حالياً.',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 450 + index * 120),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSerifDisplay(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item.body,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF78350F),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'إعلان',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedExamTile extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedExamTile({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + index * 120),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _LessonTile extends StatelessWidget {
  final dynamic lesson;
  final dynamic progress;
  final bool isCompleted;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.progress,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor =
        isCompleted ? const Color(0xFF059669) : const Color(0xFF1E3A8A);
    final scheduledAt = lesson.scheduledAt as DateTime?;
    final expiresAt = lesson.expiresAt as DateTime?;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isCompleted
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.bookOpen,
                      color: badgeColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFFCBD5E1),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ExamStatusBadge(lesson: lesson, isCompleted: isCompleted),
                  if (lesson.durationMinutes != null)
                    _InlineChip(
                      label: '${lesson.durationMinutes} دقيقة',
                      color: const Color(0xFF0F766E),
                    ),
                  if (scheduledAt != null)
                    _InlineChip(
                      label: 'يفتح ${_formatDateTime(scheduledAt)}',
                      color: const Color(0xFF1D4ED8),
                    ),
                  if (expiresAt != null)
                    _InlineChip(
                      label: 'ينتهي ${_formatDateTime(expiresAt)}',
                      color: const Color(0xFFB45309),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isCompleted
                    ? 'النتيجة: ${progress['attained']} / ${progress['total']}'
                    : (lesson.description ?? 'اضغط لبدء الامتحان'),
                style: GoogleFonts.manrope(
                  color: isCompleted
                      ? const Color(0xFF15803D)
                      : const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InlineChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFCBD5E1).withOpacity(0.2),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.folderOpen,
                      size: 36,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد امتحانات حالياً',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'سيقوم المعلم بنشر الامتحانات قريباً.',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  final WidgetRef ref;
  final dynamic error;

  const _ErrorState({required this.ref, required this.error});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.circleExclamation,
                size: 60,
                color: Colors.red[300],
              ),
              const SizedBox(height: 24),
              Text(
                'حدث خطأ غير متوقع',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                Failure.getFriendlyMessage(error),
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () {
                  ref.invalidate(lessonsNotifierProvider);
                  ref.invalidate(userProfileProvider);
                  ref.invalidate(lessonProgressProvider);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  String two(int value) => value.toString().padLeft(2, '0');
  final day = two(dateTime.day);
  final month = two(dateTime.month);
  final hour = two(dateTime.hour);
  final minute = two(dateTime.minute);
  return '$day/$month $hour:$minute';
}
