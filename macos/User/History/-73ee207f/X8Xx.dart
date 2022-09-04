import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:neat/neat.dart';

List<Widget> texts(BuildContext context) => [
      context.displayLarge('DisplayLarge'),
      context.displayMedium('DisplayMedium'),
      context.displaySmall('DisplaySmall'),
      const SpaceSmall(),
      context.titleLarge('TitleLarge'),
      context.bodyLarge('BodyLarge'),
      const SpaceSmall(),
      context.titleMedium('TitleMedium'),
      context.bodyMedium('BodyMedium'),
      const SpaceSmall(),
      context.titleSmall('TitleSmall'),
      context.bodyMedium('BodySmall'),
      const SpaceSmall(),
      Text('Test'),
      (() => Text("test"))(),
      context.labelLarge('LabelLarge'),
      context.labelMedium('LabelMedium'),
      context.labelSmall('LabelSmall'),
    ];