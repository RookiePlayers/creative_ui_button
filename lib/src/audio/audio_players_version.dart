import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayersVersion {
  AudioPlayersVersion();

  AudioPlayer player = AudioPlayer();

  Future<void> clean({bool dispose = false}) async {
    try {
      if (dispose) {
        await player.dispose();
      } else {
        await player.stop();
      }

      // await player.release();
    } catch (e) {
      debugPrint("Error cleaning player: $e");
    }
  }

  Future<void> setTrack({
    required String url,
    bool caching = false,
    bool isLoop = false,
  }) async {
    try {
      if (caching) {
        // await AudioPlayer.global.();
        // final audioSourceCached = LockCachingAudioSource(Uri.parse(url));
        // await player.setAudioSource(audioSourceCached);
        // await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
        // await audioSourceCached.clearCache();
      } else {
        final audioSource = UrlSource(url);
        await player.setSource(audioSource);
        await player.setReleaseMode(
          isLoop ? ReleaseMode.loop : ReleaseMode.release,
        );
      }
    } on AudioPlayerException {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      // Fallback for all errors
    }
    await player.setPlayerMode(PlayerMode.mediaPlayer);
  }

  playBGM(filename, {double volume = 1.0, bool? loop, double pan = 0.0}) async {
    //AudioCache cache = new AudioCache();
    try {
      await player.setSourceUrl(filename);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(volume);
    } on AudioPlayerException {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
    } catch (e) {
      // Fallback for all errors
    }
    return await player.resume();
    // return await player.play(filename,volume: GameSetting.setting.musicVolume);
  }

  get onPlayerStateChanged => player.onPlayerStateChanged;

  play() async {
    try {
      return await player.resume();
    } catch (e) {
      debugPrint("Error resuming audio: $e");
    }
  }

  Future<dynamic> playAssetAudio({
    required String filename,
    bool singleUse = false,
    double volume = 1.0,
    bool? loop,
    double pan = 0.0,
  }) async {
    try {
      final player = singleUse ? AudioPlayer() : this.player;
      await player.setSource(AssetSource(filename));
      await player.setVolume(volume);
      await player.setReleaseMode(
        loop == true ? ReleaseMode.loop : ReleaseMode.release,
      );
      await player.resume();
      return player;
    } catch (e) {
      debugPrint("Error playing asset audio: $e");
      return null;
    }
  }

  Future<dynamic> playFileAudio({
    required String filename,
    bool singleUse = false,
    double volume = 1.0,
    bool? loop,
    double pan = 0.0,
  }) async {
    try {
      final player = singleUse ? AudioPlayer() : this.player;
      await player.setSourceDeviceFile(filename);
      await player.setReleaseMode(
        loop == true ? ReleaseMode.loop : ReleaseMode.release,
      );
      await player.setVolume(clampDouble(volume, 0, 1));
      player.resume();
      return player;
    } catch (e) {
      debugPrint("Error playing file audio: $e");
      return null;
    }
  }

  pauseBGM() async {
    return await player.pause();
  }

  Future<void> pause() async {
    if (player.state != PlayerState.disposed) {
      return await player.pause();
    }
  }

  Future<void> stop() async {
    if (player.state != PlayerState.disposed) {
      await player.stop();
    }
  }

  seekTo(Duration position) async {
    return player.seek(position);
  }

  playDuration({
    required Duration from,
    Duration? length,
    double? volume,
  }) async {
    try {
      debugPrint("Playing from: ${player.source}");
      //await player.seek(from);
      if (player.source == null) {
        await player.resume();
      } else {
        await player.play(player.source!);
      }
    } on AudioPlayerException catch (e) {
      debugPrint("AudioPlayerException: $e");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  updateVolume(double volume) {
    player.setVolume(clampDouble(volume, 0, 1));
  }

  void playRemoteFile(url, {caching, loop = false}) async {
    await setTrack(url: url, caching: caching);
    await player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    await player.resume();
  }
}
