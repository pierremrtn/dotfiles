import 'package:bonemeal/bonemeal.dart';
import 'input_matcher.dart';

/// A "phase" in the build graph, which represents running a one or more
/// builders on a set of sources.
abstract class BuildPhase {
  /// Whether to run lazily when an output is read.
  ///
  /// An optional build action will only run if one of its outputs is read by
  /// a later [Builder], or is used as a primary input to a later [Builder].
  ///
  /// If no build actions read the output of an optional action, then it will
  /// never run.
  bool get isOptional;

  /// Whether generated assets should be placed in the build cache.
  ///
  /// When this is `false` the Builder may not run on any package other than
  /// the root.
  bool get hideOutput;

  /// The identity of this action in terms of a build graph. If the identity of
  /// any action changes the build will be invalidated.
  ///
  /// This should take into account everything except for the generatorOptions,
  /// which are tracked separately via a `GeneratorOptionsNode` which supports
  /// more fine grained invalidation.
  int get identity;
}

/// An "action" in the build graph which represents running a single builder
/// on a set of sources.
abstract class BuildAction {
  /// Either a [Builder] or a [PostProcessBuilder].
  dynamic get builder;
  String get builderLabel;
  GeneratorOptions get generatorOptions;
  InputMatcher get generateFor;
  String get package;
  InputMatcher get targetSources;
}

/// A [BuildPhase] that uses a single [Builder] to generate files.
class InBuildPhase extends BuildPhase implements BuildAction {
  @override
  final Generator builder;
  @override
  final String builderLabel;
  @override
  final GeneratorOptions generatorOptions;
  @override
  final InputMatcher generateFor;
  @override
  final String package;
  @override
  final InputMatcher targetSources;

  @override
  final bool isOptional;
  @override
  final bool hideOutput;

  InBuildPhase._(this.package, this.builder, this.generatorOptions,
      {required this.targetSources,
      required this.generateFor,
      required this.builderLabel,
      this.isOptional = false,
      this.hideOutput = false});

  /// Creates an [BuildPhase] for a normal [Builder].
  ///
  /// The build target is defined by [package] as well as [targetSources]. By
  /// default all sources in the target are used as primary inputs to the
  /// builder, but it can be further filtered with [generateFor].
  ///
  /// [isOptional] specifies that a Builder may not be run unless some other
  /// Builder in a later phase attempts to read one of the potential outputs.
  ///
  /// [hideOutput] specifies that the generated asses should be placed in the
  /// build cache rather than the source tree.
  InBuildPhase(
    Builder builder,
    String package, {
    String? builderKey,
    InputSet targetSources = const InputSet(),
    InputSet generateFor = const InputSet(),
    GeneratorOptions generatorOptions = const GeneratorOptions({}),
    bool isOptional = false,
    bool hideOutput = false,
  }) : this._(package, builder, generatorOptions,
            targetSources: InputMatcher(targetSources),
            generateFor: InputMatcher(generateFor),
            builderLabel: builderKey == null || builderKey.isEmpty
                ? _builderLabel(builder)
                : _simpleBuilderKey(builderKey),
            isOptional: isOptional,
            hideOutput: hideOutput);

  @override
  String toString() {
    final settings = <String>[];
    if (isOptional) settings.add('optional');
    if (hideOutput) settings.add('hidden');
    var result = '$builderLabel on $targetSources in $package';
    if (settings.isNotEmpty) result += ' $settings';
    return result;
  }

  @override
  int get identity => _deepEquals.hash([
        builderLabel,
        builder.buildExtensions,
        package,
        targetSources,
        generateFor,
        isOptional,
        hideOutput
      ]);
}