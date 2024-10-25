import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_sweep/audio.dart';
import 'package:sound_sweep/audio_db.dart';
import 'package:sound_sweep/audio_provider.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<Audio> audios = [];
  AudioDatabase db = AudioDatabase();
  final AudioPlayer _audioPlayer = AudioPlayer();

  //bool isPlaying2 = false; //Here it was global that's why all tiles were changing states
  List<bool> isPlayingList = [];

  void initState() {
    super.initState();
    _loadAudios();
  }

  _loadAudios() async {
    final audiolist =
        await db.getAllAudios(); //fetch audios from DB and store it
    setState(() {
      audios = audiolist;
      isPlayingList = List.filled(audios.length, false); //fills the list with
    });
  }

  playAudioAgain(int index) async {
    if (!isPlayingList[index]) {
      try {
        await _audioPlayer.play(DeviceFileSource(audios[index].path));
        print(audios[index].path);

        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlayingList[index] =
                false; // update the icon when audio finishes //as soon as audio finishes it should stop
          });
        });
      } catch (e) {
        print(e);
      }
    } else if (isPlayingList[index]) {
      await _audioPlayer.pause();
    } else if (isPlayingList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please click reduce audio to apply noise reduction'),
          duration: Duration(seconds: 2),
        ),
      );
      print("No audio file available to play");
    }

    setState(() {
      isPlayingList[index] = !isPlayingList[index];

      /// EXCEPTION HERE. Solved
    });
  }

  @override
  Widget build(BuildContext context) {
    //final audios = context.watch<AudioProvider>().audios;

    // Future<void> _loadAudios() async { //!!!!
    //   await Provider.of<AudioProvider>(context, listen: false).loadAudios();
    // }
    // final audios = context
    //     .watch<AudioProvider>()
    //     .audios; // Use context.watch to get the updated list

    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Audio'),
        backgroundColor: const Color.fromARGB(255, 1, 33, 75),
        foregroundColor: const Color.fromARGB(255, 45, 198, 245),
      ),
      body: FutureBuilder(
        future: context.read<AudioProvider>().loadAudios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while fetching
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show if any errors
          }

          final audios = context
              .watch<AudioProvider>()
              .audios; // Use context.watch to get the updated list

          if (audios.isEmpty) {
            return const Center(
                child: Text('No saved audios.')); // Handle empty list
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.04,
                          right: MediaQuery.of(context).size.width * 0.04),
                      child: Card(
                        color: const Color.fromARGB(255, 1, 33, 75),
                        child: ListTile(
                          title: Text(audios[index].name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 93, 211, 247),
                              )),
                          //subtitle: Text(audios[index].path),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 93, 211, 247)),
                            onPressed: () {
                              //await db.deleteAudio(audios[index].id!);
                              context.read<AudioProvider>().removeAudio(audios[
                                      index]
                                  .id!); //not context.watch b/c we dont need updates
                            },
                          ),
                          leading: IconButton(
                              onPressed: () => playAudioAgain(index),
                              icon: Icon(
                                  isPlayingList[index]
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Color.fromARGB(255, 93, 211, 247))),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
