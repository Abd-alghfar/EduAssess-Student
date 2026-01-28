// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
  id: json['id'] as String,
  studentId: json['student_id'] as String,
  questionId: json['question_id'] as String,
  answerValue: json['answer_value'],
  isCorrect: json['is_correct'] as bool?,
  scoreAttained: (json['score_attained'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'question_id': instance.questionId,
      'answer_value': instance.answerValue,
      'is_correct': instance.isCorrect,
      'score_attained': instance.scoreAttained,
      'created_at': instance.createdAt.toIso8601String(),
    };
