// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizNotifierHash() => r'a3ac3923a4ca2be03a669a030a2029a33a5037bf';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$QuizNotifier extends BuildlessAutoDisposeNotifier<QuizState> {
  late final String lessonId;

  QuizState build(String lessonId);
}

/// See also [QuizNotifier].
@ProviderFor(QuizNotifier)
const quizNotifierProvider = QuizNotifierFamily();

/// See also [QuizNotifier].
class QuizNotifierFamily extends Family<QuizState> {
  /// See also [QuizNotifier].
  const QuizNotifierFamily();

  /// See also [QuizNotifier].
  QuizNotifierProvider call(String lessonId) {
    return QuizNotifierProvider(lessonId);
  }

  @override
  QuizNotifierProvider getProviderOverride(
    covariant QuizNotifierProvider provider,
  ) {
    return call(provider.lessonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizNotifierProvider';
}

/// See also [QuizNotifier].
class QuizNotifierProvider
    extends AutoDisposeNotifierProviderImpl<QuizNotifier, QuizState> {
  /// See also [QuizNotifier].
  QuizNotifierProvider(String lessonId)
    : this._internal(
        () => QuizNotifier()..lessonId = lessonId,
        from: quizNotifierProvider,
        name: r'quizNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizNotifierHash,
        dependencies: QuizNotifierFamily._dependencies,
        allTransitiveDependencies:
            QuizNotifierFamily._allTransitiveDependencies,
        lessonId: lessonId,
      );

  QuizNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
  }) : super.internal();

  final String lessonId;

  @override
  QuizState runNotifierBuild(covariant QuizNotifier notifier) {
    return notifier.build(lessonId);
  }

  @override
  Override overrideWith(QuizNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizNotifierProvider._internal(
        () => create()..lessonId = lessonId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<QuizNotifier, QuizState> createElement() {
    return _QuizNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizNotifierRef on AutoDisposeNotifierProviderRef<QuizState> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _QuizNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<QuizNotifier, QuizState>
    with QuizNotifierRef {
  _QuizNotifierProviderElement(super.provider);

  @override
  String get lessonId => (origin as QuizNotifierProvider).lessonId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
