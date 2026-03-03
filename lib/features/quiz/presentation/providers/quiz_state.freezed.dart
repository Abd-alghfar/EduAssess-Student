// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizState {
  List<Question> get questions => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic> get answers => throw _privateConstructorUsedError;
  bool get isCurrentQuestionAnswered => throw _privateConstructorUsedError;
  bool? get isCurrentQuestionCorrect => throw _privateConstructorUsedError;
  dynamic get currentCorrectAnswer => throw _privateConstructorUsedError;
  int? get remainingSeconds => throw _privateConstructorUsedError;
  bool get showCorrection => throw _privateConstructorUsedError;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStateCopyWith<QuizState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStateCopyWith<$Res> {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) then) =
      _$QuizStateCopyWithImpl<$Res, QuizState>;
  @useResult
  $Res call({
    List<Question> questions,
    int currentIndex,
    bool isLoading,
    String? error,
    bool isCompleted,
    Map<String, dynamic> answers,
    bool isCurrentQuestionAnswered,
    bool? isCurrentQuestionCorrect,
    dynamic currentCorrectAnswer,
    int? remainingSeconds,
    bool showCorrection,
  });
}

/// @nodoc
class _$QuizStateCopyWithImpl<$Res, $Val extends QuizState>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isCompleted = null,
    Object? answers = null,
    Object? isCurrentQuestionAnswered = null,
    Object? isCurrentQuestionCorrect = freezed,
    Object? currentCorrectAnswer = freezed,
    Object? remainingSeconds = freezed,
    Object? showCorrection = null,
  }) {
    return _then(
      _value.copyWith(
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<Question>,
            currentIndex: null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            isCurrentQuestionAnswered: null == isCurrentQuestionAnswered
                ? _value.isCurrentQuestionAnswered
                : isCurrentQuestionAnswered // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCurrentQuestionCorrect: freezed == isCurrentQuestionCorrect
                ? _value.isCurrentQuestionCorrect
                : isCurrentQuestionCorrect // ignore: cast_nullable_to_non_nullable
                      as bool?,
            currentCorrectAnswer: freezed == currentCorrectAnswer
                ? _value.currentCorrectAnswer
                : currentCorrectAnswer // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            remainingSeconds: freezed == remainingSeconds
                ? _value.remainingSeconds
                : remainingSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            showCorrection: null == showCorrection
                ? _value.showCorrection
                : showCorrection // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizStateImplCopyWith<$Res>
    implements $QuizStateCopyWith<$Res> {
  factory _$$QuizStateImplCopyWith(
    _$QuizStateImpl value,
    $Res Function(_$QuizStateImpl) then,
  ) = __$$QuizStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Question> questions,
    int currentIndex,
    bool isLoading,
    String? error,
    bool isCompleted,
    Map<String, dynamic> answers,
    bool isCurrentQuestionAnswered,
    bool? isCurrentQuestionCorrect,
    dynamic currentCorrectAnswer,
    int? remainingSeconds,
    bool showCorrection,
  });
}

/// @nodoc
class __$$QuizStateImplCopyWithImpl<$Res>
    extends _$QuizStateCopyWithImpl<$Res, _$QuizStateImpl>
    implements _$$QuizStateImplCopyWith<$Res> {
  __$$QuizStateImplCopyWithImpl(
    _$QuizStateImpl _value,
    $Res Function(_$QuizStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isCompleted = null,
    Object? answers = null,
    Object? isCurrentQuestionAnswered = null,
    Object? isCurrentQuestionCorrect = freezed,
    Object? currentCorrectAnswer = freezed,
    Object? remainingSeconds = freezed,
    Object? showCorrection = null,
  }) {
    return _then(
      _$QuizStateImpl(
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<Question>,
        currentIndex: null == currentIndex
            ? _value.currentIndex
            : currentIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        isCurrentQuestionAnswered: null == isCurrentQuestionAnswered
            ? _value.isCurrentQuestionAnswered
            : isCurrentQuestionAnswered // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCurrentQuestionCorrect: freezed == isCurrentQuestionCorrect
            ? _value.isCurrentQuestionCorrect
            : isCurrentQuestionCorrect // ignore: cast_nullable_to_non_nullable
                  as bool?,
        currentCorrectAnswer: freezed == currentCorrectAnswer
            ? _value.currentCorrectAnswer
            : currentCorrectAnswer // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        remainingSeconds: freezed == remainingSeconds
            ? _value.remainingSeconds
            : remainingSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        showCorrection: null == showCorrection
            ? _value.showCorrection
            : showCorrection // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$QuizStateImpl implements _QuizState {
  const _$QuizStateImpl({
    final List<Question> questions = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
    this.isCompleted = false,
    final Map<String, dynamic> answers = const {},
    this.isCurrentQuestionAnswered = false,
    this.isCurrentQuestionCorrect,
    this.currentCorrectAnswer,
    this.remainingSeconds,
    this.showCorrection = true,
  }) : _questions = questions,
       _answers = answers;

  final List<Question> _questions;
  @override
  @JsonKey()
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isCompleted;
  final Map<String, dynamic> _answers;
  @override
  @JsonKey()
  Map<String, dynamic> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  @JsonKey()
  final bool isCurrentQuestionAnswered;
  @override
  final bool? isCurrentQuestionCorrect;
  @override
  final dynamic currentCorrectAnswer;
  @override
  final int? remainingSeconds;
  @override
  @JsonKey()
  final bool showCorrection;

  @override
  String toString() {
    return 'QuizState(questions: $questions, currentIndex: $currentIndex, isLoading: $isLoading, error: $error, isCompleted: $isCompleted, answers: $answers, isCurrentQuestionAnswered: $isCurrentQuestionAnswered, isCurrentQuestionCorrect: $isCurrentQuestionCorrect, currentCorrectAnswer: $currentCorrectAnswer, remainingSeconds: $remainingSeconds, showCorrection: $showCorrection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStateImpl &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(
                  other.isCurrentQuestionAnswered,
                  isCurrentQuestionAnswered,
                ) ||
                other.isCurrentQuestionAnswered == isCurrentQuestionAnswered) &&
            (identical(
                  other.isCurrentQuestionCorrect,
                  isCurrentQuestionCorrect,
                ) ||
                other.isCurrentQuestionCorrect == isCurrentQuestionCorrect) &&
            const DeepCollectionEquality().equals(
              other.currentCorrectAnswer,
              currentCorrectAnswer,
            ) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.showCorrection, showCorrection) ||
                other.showCorrection == showCorrection));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_questions),
    currentIndex,
    isLoading,
    error,
    isCompleted,
    const DeepCollectionEquality().hash(_answers),
    isCurrentQuestionAnswered,
    isCurrentQuestionCorrect,
    const DeepCollectionEquality().hash(currentCorrectAnswer),
    remainingSeconds,
    showCorrection,
  );

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      __$$QuizStateImplCopyWithImpl<_$QuizStateImpl>(this, _$identity);
}

abstract class _QuizState implements QuizState {
  const factory _QuizState({
    final List<Question> questions,
    final int currentIndex,
    final bool isLoading,
    final String? error,
    final bool isCompleted,
    final Map<String, dynamic> answers,
    final bool isCurrentQuestionAnswered,
    final bool? isCurrentQuestionCorrect,
    final dynamic currentCorrectAnswer,
    final int? remainingSeconds,
    final bool showCorrection,
  }) = _$QuizStateImpl;

  @override
  List<Question> get questions;
  @override
  int get currentIndex;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  bool get isCompleted;
  @override
  Map<String, dynamic> get answers;
  @override
  bool get isCurrentQuestionAnswered;
  @override
  bool? get isCurrentQuestionCorrect;
  @override
  dynamic get currentCorrectAnswer;
  @override
  int? get remainingSeconds;
  @override
  bool get showCorrection;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
