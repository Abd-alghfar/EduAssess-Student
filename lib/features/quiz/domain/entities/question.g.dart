// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      questionText: json['question_text'] as String,
      questionType: $enumDecode(_$QuestionTypeEnumMap, json['question_type']),
      config: json['config'] as Map<String, dynamic>? ?? const {},
      points: (json['points'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lesson_id': instance.lessonId,
      'question_text': instance.questionText,
      'question_type': _$QuestionTypeEnumMap[instance.questionType]!,
      'config': instance.config,
      'points': instance.points,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$QuestionTypeEnumMap = {
  QuestionType.mcq: 'mcq',
  QuestionType.multiSelect: 'multi_select',
  QuestionType.trueFalse: 'true_false',
  QuestionType.essay: 'essay',
  QuestionType.code: 'code',
  QuestionType.codeCompletion: 'code_completion',
};
