import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eduassess_student/features/lessons/presentation/providers/lessons_notifier.dart';
import 'package:eduassess_student/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:eduassess_student/features/auth/presentation/providers/auth_notifier.dart';
import 'package:eduassess_student/features/auth/presentation/providers/profile_provider.dart';
import 'package:eduassess_student/features/lessons/presentation/providers/completed_lessons_provider.dart';
import 'package:eduassess_student/features/chat/presentation/screens/chat_screen.dart';
import 'package:eduassess_student/core/widgets/shimmer_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eduassess_student/core/error/failure.dart';
import '../widgets/exam_status_badge.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final user = ref.watch(authNotifierProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final progressAsync = ref.watch(lessonProgressProvider);

    // Using white background with subtle grey for a clean, academic look
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, profileAsync, user, ref),

          // Welcome Card & Progress
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: lessonsAsync.when(
                data: (lessons) => progressAsync.when(
                  data: (progressMap) {
                    final total = lessons.length;
                    final completed = progressMap.length;
                    final progress = total > 0 ? completed / total : 0.0;

                    return _buildProgressCard(
                      context,
                      total,
                      completed,
                      progress,
                    );
                  },
                  loading: () => const CodeKeyShimmer.rectangular(height: 180),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                loading: () => const CodeKeyShimmer.rectangular(height: 180),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Lessons List Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.layerGroup,
                    size: 18,
                    color: Color(0xFF1E3A8A),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Active Exams',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lessons Grid/List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: lessonsAsync.when(
              data: (lessons) {
                // Filter out expired lessons not completed
                final now = DateTime.now();
                final visibleLessons = lessons.where((l) {
                  if (l.expiresAt != null && now.isAfter(l.expiresAt!)) {
                    // Check if student completed it, if so keep it visible
                    return progressAsync.maybeWhen(
                      data: (p) => p.containsKey(l.id),
                      orElse: () => false,
                    );
                  }
                  return true;
                }).toList();

                if (visibleLessons.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.folderOpen,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No active exams available.'),
                        ],
                      ),
                    ),
                  );
                }

                return progressAsync.when(
                  data: (progressMap) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final lesson = visibleLessons[index];
                      final progress = progressMap[lesson.id];
                      final isCompleted = progress != null;

                      return _buildLessonCard(
                        context,
                        ref,
                        lesson,
                        progress,
                        isCompleted,
                      );
                    }, childCount: visibleLessons.length),
                  ),
                  loading: () => const SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: LessonListShimmer(),
                    ),
                  ),
                  error: (error, stack) => _buildErrorState(ref, error),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: LessonListShimmer(),
                ),
              ),
              error: (error, stack) => _buildErrorState(ref, error),
            ),
          ),

          // Extra Space at the bottom
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(
          FontAwesomeIcons.solidCommentDots,
          color: Colors.white,
          size: 20,
        ),
        label: const Text(
          'Message Teacher',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    AsyncValue profileAsync,
    dynamic user,
    WidgetRef ref,
  ) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: profileAsync.when(
          data: (profile) => Text(
            'Hi, ${profile?['full_name'] ?? user?.fullName ?? user?.username ?? 'Candidate'} 👋',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              fontSize: 20,
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => Text(
            'Hi, ${user?.username ?? 'Candidate'} 👋',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF1E3A8A)),
            onPressed: () {
              ref.read(lessonsNotifierProvider.notifier).refresh();
              ref.invalidate(lessonProgressProvider);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Colors.red,
              size: 18,
            ),
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    int total,
    int completed,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Learning Path',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 12,
                width: MediaQuery.of(context).size.width * 0.75 * progress,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                FontAwesomeIcons.bookOpen,
                '$total',
                'Total Exams',
                Colors.white,
              ),
              _buildStatItem(
                FontAwesomeIcons.circleCheck,
                '$completed',
                'Completed',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    WidgetRef ref,
    dynamic lesson,
    dynamic progress,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final now = DateTime.now();
            final scheduledAt = lesson.scheduledAt;
            final expiresAt = lesson.expiresAt;

            // Block if not started yet
            if (!isCompleted &&
                scheduledAt != null &&
                now.isBefore(scheduledAt)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Exam will be available in ${scheduledAt.difference(now).inMinutes} minutes',
                  ),
                  backgroundColor: Colors.orange.shade800,
                ),
              );
              return;
            }

            // Block if expired
            if (!isCompleted && expiresAt != null && now.isAfter(expiresAt)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This exam has expired and is no longer available.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizScreen(lessonId: lesson.id),
              ),
            );
            ref.invalidate(lessonProgressProvider);
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green[50]
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isCompleted
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.book,
                    color: isCompleted ? Colors.green : const Color(0xFF1E3A8A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ExamStatusBadge(lesson: lesson, isCompleted: isCompleted),
                      const SizedBox(height: 12),
                      Text(
                        isCompleted
                            ? 'Score: ${progress['attained']} / ${progress['total']} (Passed)'
                            : (lesson.description ?? 'Start this course now'),
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.green[700]
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: isCompleted
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey[200],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(WidgetRef ref, dynamic error) {
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
              const Text(
                'عذراً، فشل جلب البيانات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                Failure.getFriendlyMessage(error),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
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
