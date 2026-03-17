// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  showCorrection: json['show_correction'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  scheduledAt: json['scheduled_at'] == null
      ? null
      : DateTime.parse(json['scheduled_at'] as String),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration_minutes': instance.durationMinutes,
      'show_correction': instance.showCorrection,
      'created_at': instance.createdAt.toIso8601String(),
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
