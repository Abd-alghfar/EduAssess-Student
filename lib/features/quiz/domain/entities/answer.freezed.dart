// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return _Answer.fromJson(json);
}

/// @nodoc
mixin _$Answer {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_value')
  dynamic get answerValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool? get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_attained')
  int get scoreAttained => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Answer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerCopyWith<Answer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res, Answer>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'answer_value') dynamic answerValue,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'score_attained') int scoreAttained,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res, $Val extends Answer>
    implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? questionId = null,
    Object? answerValue = freezed,
    Object? isCorrect = freezed,
    Object? scoreAttained = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            answerValue: freezed == answerValue
                ? _value.answerValue
                : answerValue // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            isCorrect: freezed == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool?,
            scoreAttained: null == scoreAttained
                ? _value.scoreAttained
                : scoreAttained // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnswerImplCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$$AnswerImplCopyWith(
    _$AnswerImpl value,
    $Res Function(_$AnswerImpl) then,
  ) = __$$AnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'answer_value') dynamic answerValue,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'score_attained') int scoreAttained,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$AnswerImplCopyWithImpl<$Res>
    extends _$AnswerCopyWithImpl<$Res, _$AnswerImpl>
    implements _$$AnswerImplCopyWith<$Res> {
  __$$AnswerImplCopyWithImpl(
    _$AnswerImpl _value,
    $Res Function(_$AnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? questionId = null,
    Object? answerValue = freezed,
    Object? isCorrect = freezed,
    Object? scoreAttained = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AnswerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        answerValue: freezed == answerValue
            ? _value.answerValue
            : answerValue // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        isCorrect: freezed == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool?,
        scoreAttained: null == scoreAttained
            ? _value.scoreAttained
            : scoreAttained // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerImpl implements _Answer {
  const _$AnswerImpl({
    required this.id,
    @JsonKey(name: 'student_id') required this.studentId,
    @JsonKey(name: 'question_id') required this.questionId,
    @JsonKey(name: 'answer_value') required this.answerValue,
    @JsonKey(name: 'is_correct') this.isCorrect,
    @JsonKey(name: 'score_attained') this.scoreAttained = 0,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$AnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  @override
  @JsonKey(name: 'answer_value')
  final dynamic answerValue;
  @override
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;
  @override
  @JsonKey(name: 'score_attained')
  final int scoreAttained;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'Answer(id: $id, studentId: $studentId, questionId: $questionId, answerValue: $answerValue, isCorrect: $isCorrect, scoreAttained: $scoreAttained, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            const DeepCollectionEquality().equals(
              other.answerValue,
              answerValue,
            ) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.scoreAttained, scoreAttained) ||
                other.scoreAttained == scoreAttained) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    questionId,
    const DeepCollectionEquality().hash(answerValue),
    isCorrect,
    scoreAttained,
    createdAt,
  );

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      __$$AnswerImplCopyWithImpl<_$AnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerImplToJson(this);
  }
}

abstract class _Answer implements Answer {
  const factory _Answer({
    required final String id,
    @JsonKey(name: 'student_id') required final String studentId,
    @JsonKey(name: 'question_id') required final String questionId,
    @JsonKey(name: 'answer_value') required final dynamic answerValue,
    @JsonKey(name: 'is_correct') final bool? isCorrect,
    @JsonKey(name: 'score_attained') final int scoreAttained,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$AnswerImpl;

  factory _Answer.fromJson(Map<String, dynamic> json) = _$AnswerImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'answer_value')
  dynamic get answerValue;
  @override
  @JsonKey(name: 'is_correct')
  bool? get isCorrect;
  @override
  @JsonKey(name: 'score_attained')
  int get scoreAttained;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerImplCopyWith<_$AnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
