import 'package:flutter/material.dart';
import 'package:sound_sweep/audio_screen.dart';
import 'package:sound_sweep/save_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Welcome to SoundSweep',
          style: TextStyle(fontSize: 20),
        )),
        backgroundColor: const Color.fromARGB(255, 1, 33, 75),
        foregroundColor: const Color.fromARGB(255, 93, 211, 247),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.audiotrack,
                size: 50,
                color: Color.fromARGB(255, 93, 211, 247),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 1, 33, 75),
                // Button color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SaveScreen()),
                );
              },
              label: const Text(
                'Saved Audios',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.folder_open,
                size: 50,
                color: Color.fromARGB(255, 93, 211, 247),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 33, 75),
                // Button color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AudioScreen()),
                );
              },
              //For reference if pick method is used here
              //async {
              //   // This part should handle picking audio file from storage.
              //   // In this case, we'll navigate to the audio processing screen after selection.
              //   final pickedAudio = await _pickAudioFromStorage();
              //   if (pickedAudio != null) {
              //     Navigator.push(
              //       // ignore: use_build_context_synchronously
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => AudioProcessingScreen(audioFile: pickedAudio)),
              //     );
              //   }
              // },
              label: const Text(
                'Pick Audio',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<String?> _pickAudioFromStorage() async {
  //   // You can use a package like file_picker for this functionality.
  //   // Placeholder for actual audio file path.
  //   return 'path_to_audio_file.mp3';
  // }
}
