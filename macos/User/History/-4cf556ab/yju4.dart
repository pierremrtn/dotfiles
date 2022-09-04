import 'dart:ffi';

import 'package:common/src/widgets/prefixed_text/prefixed_text.dart';
import 'package:flutter/material.dart';

class EmojiText extends StatelessWidget {
  const EmojiText(
    this.emoji,
    this.text, {
    super.key,
  });

  Char emoji;
  String text;

  @override
  Widget build(BuildContext context) {
    return PrefixedText(prefix: FittedBox(child: Text(emoji)), text: text);
  }
}