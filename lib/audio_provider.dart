import 'package:flutter/material.dart';
import 'audio.dart';
import 'audio_db.dart';

class AudioProvider with ChangeNotifier {
  List<Audio> _audios = [Audio(name: "sample", path: "samplePath")];

  List<Audio> get audios => _audios;

  Future<void> loadAudios() async {
    _audios = await AudioDatabase().getAllAudios();
    notifyListeners(); // Notify listeners when data changes
  }

  Future<void> addAudio(Audio audio) async {
    await AudioDatabase().insertAudio(audio);
    //_audios.add(audio);
    notifyListeners();
  }

  Future<void> removeAudio(int id) async {
    await AudioDatabase().deleteAudio(id);
    //_audios.remove(Audio(id: id, name: '', path: ''));
    _audios.removeWhere((audio) => audio.id == id);
    notifyListeners();
  }
}
