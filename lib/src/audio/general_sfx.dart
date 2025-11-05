import 'package:creative_ui_button/src/audio/audio_players_version.dart';

enum SfxSource { asset, file, remote }

class GeneralSFX {
  // Private constructor
  GeneralSFX._internal();

  // Singleton instance
  static final GeneralSFX _instance = GeneralSFX._internal();

  // Factory constructor
  factory GeneralSFX() => _instance;

  static GeneralSFX get instance => _instance;

  AudioPlayersVersion audio = AudioPlayersVersion();

  Map<String, AudioPlayersVersion> sfxAudioPlayerTracker = {};

  playFx(
    String filename, {
    double volume = 1.0,
    SfxSource source = SfxSource.asset,
    bool loop = false,
  }) {
    switch (source) {
      case SfxSource.asset:
        return playLocalAsset(filename, volume: volume, loop: loop);
      case SfxSource.file:
        return playFileAsset(filename, volume: volume, loop: loop);
      case SfxSource.remote:
        if (filename.startsWith('http')) {
          return playRemoteFile(filename);
        } else {
          return;
        }
    }
  }

  _disposeFunc({String? id}) {
    sfxAudioPlayerTracker[id]?.stop();
  }

  dispose({String? id}) {
    if (id == null) {
      for (var key in sfxAudioPlayerTracker.keys) {
        _disposeFunc(id: key);
      }
      return;
    }
    _disposeFunc(id: id);
  }

  playLocalAsset(filename, {double volume = 1.0, loop = false}) async {
    final data = await audio.playAssetAudio(
      filename: filename,
      singleUse: true,
      volume: volume,
      loop: loop,
    );
    if (loop == false) return;
    sfxAudioPlayerTracker[filename] = (data);
    return data;
  }

  playFileAsset(String filename, {double volume = 1.0, loop = false}) async {
    final data = await audio.playFileAudio(
      filename: filename,
      singleUse: true,
      volume: volume,
      loop: loop,
    );
    if (loop == false) return;
    sfxAudioPlayerTracker[filename] = (data);
    return data;
  }

  playRemoteFile(url) async {
    return audio.playRemoteFile(url, caching: true);
  }
}
