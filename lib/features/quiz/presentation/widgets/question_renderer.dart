import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';
import 'mcq_widget.dart';
import 'true_false_widget.dart';
import 'essay_widget.dart';
import 'multi_select_widget.dart';

class QuestionRenderer extends StatelessWidget {
  final Question question;
  final Function(dynamic) onAnswerSubmitted;
  final dynamic initialAnswer;

  const QuestionRenderer({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    this.initialAnswer,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.questionType) {
      case QuestionType.mcq:
        final options = List<String>.from(question.config['options'] ?? []);
        return MCQWidget(
          options: options,
          onSelected: onAnswerSubmitted,
          initialValue: initialAnswer as String?,
        );
      case QuestionType.multiSelect:
        final options = List<String>.from(question.config['options'] ?? []);
        return MultiSelectWidget(
          options: options,
          onSelected: onAnswerSubmitted,
          initialValue: initialAnswer as List<String>?,
        );
      case QuestionType.trueFalse:
        return TrueFalseWidget(
          onSelected: onAnswerSubmitted,
          initialValue: initialAnswer as bool?,
        );
      case QuestionType.matching:
      case QuestionType.ordering:
        return Center(
          child: Text(
            'هذا النوع غير مدعوم حالياً.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        );
      case QuestionType.essay:
      case QuestionType.code:
      case QuestionType.codeCompletion:
      case QuestionType.completion:
        return EssayWidget(
          onSubmit: onAnswerSubmitted,
          initialValue: initialAnswer as String?,
        );
      default:
        return Center(
          child: Text('Unsupported question type: ${question.questionType}'),
        );
    }
  }
}
