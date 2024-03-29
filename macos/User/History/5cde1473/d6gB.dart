import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:unusable_player/unusable_player.dart' as up;

final int _minAnimDurationMS = up.Feel.animationDuration.inMilliseconds;
final int _maxAnimDurationMS = up.Feel.animationDuration.inMilliseconds * 3;

class TiedArtistCard extends StatelessWidget {
  const TiedArtistCard({
    required this.random,
    required this.artist,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Random random;
  final VoidCallback? onTap;
  final up.Artist artist;

  int get _animDuration =>
      ((_maxAnimDurationMS - _minAnimDurationMS) * random.nextDouble())
          .toInt() +
      _minAnimDurationMS;

  @override
  Widget build(BuildContext context) {
    return FlipInX(
      duration: Duration(milliseconds: _animDuration),
      child: up.Tied(
        minAngle: -0.05,
        maxAngle: 0.05,
        random: random,
        child: up.ArtistCard(
          artist: artist,
          onTap: onTap,
        ),
      ),
    );
  }
}
