import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_notifier.dart';
import '../widgets/question_renderer.dart';

class QuizScreen extends ConsumerWidget {
  final String lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider(lessonId));

    if (quizState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quizState.isCompleted) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'نتائج الاختبار',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: quizState.questions.length,
          itemBuilder: (context, index) {
            final question = quizState.questions[index];
            final userAnswer = quizState.answers[question.id];
            final correctAnswer = question.config['correct_answer'];
            final isCorrect =
                userAnswer != null &&
                userAnswer.toString().trim().toLowerCase() ==
                    correctAnswer.toString().trim().toLowerCase();

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCorrect
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: isCorrect
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'سؤال ${index + 1}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildResultDetail(
                      'إجابتك:',
                      userAnswer?.toString() ?? 'لم يتم الإجابة',
                      isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                      isCorrect
                          ? Icons.person_outline
                          : Icons.person_off_outlined,
                    ),
                    if (!isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildResultDetail(
                          'الإجابة الصحيحة:',
                          correctAnswer.toString(),
                          Colors.blue.shade700,
                          Icons.verified_user_outlined,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'العودة للدروس',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    if (quizState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('خطأ: ${quizState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('رجوع'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = quizState.questions[quizState.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${quizState.currentIndex + 1} / ${quizState.questions.length}',
            ),
            if (quizState.remainingSeconds != null)
              Text(
                '${(quizState.remainingSeconds! ~/ 60).toString().padLeft(2, '0')}:${(quizState.remainingSeconds! % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (quizState.currentIndex + 1) / quizState.questions.length,
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AbsorbPointer(
                absorbing: quizState.isCurrentQuestionAnswered,
                child: QuestionRenderer(
                  key: ValueKey(currentQuestion.id),
                  question: currentQuestion,
                  initialAnswer: quizState.answers[currentQuestion.id],
                  onAnswerSubmitted: (value) {
                    ref
                        .read(quizNotifierProvider(lessonId).notifier)
                        .submitAnswer(value);
                  },
                ),
              ),
            ),
            if (quizState.isCurrentQuestionAnswered) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (quizState.isCurrentQuestionCorrect ?? false)
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (quizState.isCurrentQuestionCorrect ?? false)
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          (quizState.isCurrentQuestionCorrect ?? false)
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: (quizState.isCurrentQuestionCorrect ?? false)
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (quizState.isCurrentQuestionCorrect ?? false)
                              ? 'Correct!'
                              : 'Incorrect',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (quizState.isCurrentQuestionCorrect ?? false)
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (!(quizState.isCurrentQuestionCorrect ?? false)) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Correct Answer: ${quizState.currentCorrectAnswer}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(quizNotifierProvider(lessonId).notifier)
                      .nextQuestion();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  quizState.currentIndex == quizState.questions.length - 1
                      ? 'Finish Quiz'
                      : 'Next Question',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultDetail(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
