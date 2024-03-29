import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:unusable_player/pages/player/models/player_parameters.dart';
import 'package:unusable_player/unusable_player.dart' as up;
import 'models/player_control_state.dart';
import 'widgets/cover/cover.dart';

class PlayerController extends GetxController
    with StateMixin<PlayerControlState>, GetSingleTickerProviderStateMixin {
  PlayerController({
    required this.audioService,
  });

  @override
  void onInit() {
    final params = Get.arguments as PlayerParameters;
    _initCover(params);
    _bindStreams();
    super.onInit();
  }

  @override
  void onReady() {
    try {
      final params = Get.arguments as PlayerParameters;
      _initPlayer(params);
    } catch (e) {
      Get.back();
    }
  }

  @override
  void onClose() {
    coverController.dispose();
  }

  final up.AudioPlayerService audioService;
  late CoverController coverController;
  int _currentSongIndex = 0;
  
late final StreamSubscription<Song?> songStream;
late final StreamSubscription<> playerStateStream;
late final StreamSubscription<> volumeStream;
late final StreamSubscription<> currentTimeStream;
late final StreamSubscription<> loopModeStream;
late final StreamSubscription<> shuffleModeStream;

  Future<void> play() async => audioService.play();
  Future<void> pause() async => audioService.pause();
  Future<void> setTime(Duration time) async => audioService.setTime(time);
  Future<void> setVolume(double volume) async => audioService.setVolume(volume);
  Future<void> toggleShuffleMode() async => audioService.toggleShuffleMode();
  Future<void> toggleLoopMode() async => audioService.toggleLoopMode();
  Future<void> previous() async => audioService.previous();
  Future<void> next() async => audioService.next();

  void _initCover(PlayerParameters params) {
    if (params.openCurrentSong == false) {
      final _idx = params.index!;
      final _songs = params.songs!;
      final _prevSong = _idx > 0 ? _songs[_idx - 1] : null;
      final _nextSong = _idx + 1 < _songs.length ? _songs[_idx + 1] : null;
      _currentSongIndex = _idx;
      coverController = CoverController(
        song: _songs[_idx],
        prevSong: _prevSong,
        nextSong: _nextSong,
        onNext: next,
        onPrev: previous,
        vsync: this,
      );
    } else {
      _currentSongIndex = audioService.currentSongIndex;
      coverController = CoverController(
        song: audioService.playingSong!,
        prevSong: audioService.previousSong,
        nextSong: audioService.nextSong,
        onNext: next,
        onPrev: previous,
        vsync: this,
      );
    }
  }

  Future<void> _initPlayer(PlayerParameters params) async {
    if (!params.openCurrentSong) {
      await audioService.setSongsList(params.songs!, params.index);
      play();
    }
  }

  void _bindStreams() {
    songStream = audioService.songStream.listen((_) => _onSongChange());
    playerStateStream = audioService.playerStateStream.listen((_) => _updateControlState());
    volumeStream = audioService.volumeStream.listen((_) => _updateControlState());
    currentTimeStream = audioService.currentTimeStream.listen((_) => _updateControlState());
    loopModeStream = audioService.loopModeStream.listen(_onLoopModeChange);
    shuffleModeStream = audioService.shuffleModeStream.listen((_) => _updateControlState());
  }

  void _onSongChange() {
    _updateCover();
    _updateControlState();
  }

  Future<void> _updateCover() async {
    final idx = audioService.currentSongIndex;
    if (idx == _currentSongIndex) {
      return;
    }
    CoverAnimation animate = CoverAnimation.none;
    if (_currentSongIndex == audioService.previousSongIndex) {
      animate = CoverAnimation.down;
    } else {
      animate = CoverAnimation.up;
    }
    _currentSongIndex = idx;
    coverController.setSongs(
      audioService.playingSong!,
      animate,
      prevSong: audioService.previousSong,
      nextSong: audioService.nextSong,
    );
  }

  void _onLoopModeChange(bool enabled) {
    coverController.setSongs(
      audioService.playingSong!,
      CoverAnimation.none,
      prevSong: audioService.previousSong,
      nextSong: audioService.nextSong,
    );
    _updateControlState();
  }

  void _updateControlState() {
    change(_controlState, status: RxStatus.success());
  }

  PlayerControlState get _controlState => PlayerControlState(
        isPlaying: audioService.isPlaying,
        currentTime: audioService.currentTime,
        songDuration: audioService.playingSong?.duration,
        nextSongButtonEnabled: audioService.hasNext,
        previousSongButtonEnabled: audioService.hasPrevious,
        loopModeEnabled: audioService.loopModeEnabled,
        canEnableShuffleMode: audioService.canEnableShuffleMode,
        shuffleModeEnabled: audioService.shuffleModeEnabled,
        volume: audioService.volume,
      );
}
