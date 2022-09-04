import 'dart:async';

import 'package:bonemeal_core/bonemeal_core.dart';

abstract class FileNameBasedGenerator extends Generator {
  @override
  FutureOr<void> build(BuildStep step) {
    for (final input in step.inputs) {}
  }

  FutureOr<void> buildFor(AssetId id, BuildStep step) {}
}