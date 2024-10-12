//import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_new/add_audio.dart';
//import 'package:project_new/audio.dart';
//import 'package:project_new/audio_provider.dart';
import 'package:project_new/save_screen.dart';
//import 'package:provider/provider.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenPage();
}

class _AudioScreenPage extends State<AudioScreen> {
  //File? _selectedFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  String? _selectedFilePath; //selected audio file path
  String? _outputFilePath;
  String? _fileName = ""; // selected audio file name

  Future<String> pickAudio() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result != null) {
        setState(() {
          //_selectedFile = File(result.files.single.path!);
          _selectedFilePath = result.files.single.path;
          _fileName = result.files.single.name;
        });
      } else {
        print("No file selected");
      }
    } catch (e) {
      print(e);
    }
    return "Nothing happen";
  }

  bool isPlaying = false;

  Future<void> playAudio() async {
    // Play the .wav audio from assets
    //await _audioPlayer.play(AssetSource('audio.wav'));
    // if (_selectedFilePath != null && isPlaying==false) {
    //   await _audioPlayer.play(DeviceFileSource(_selectedFilePath!));
    // } else {
    //   print('No file selected to play');
    // }

    if (_selectedFilePath != null) {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(DeviceFileSource(_selectedFilePath!));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select audio  file to play'),
          duration: Duration(seconds: 2),
        ),
      );
      print("No file selected to play");
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> reduceNoise() async {
    if (_selectedFilePath != null) {
      // Get the output file path
      String outputFilePath = await getOutputFilePath();
      print(outputFilePath);

      // Define FFmpeg noise reduction command
      //String command =
      // '-i $_selectedFilePath -af "anlmdn=n=1:cos=15:out_mode=d" $outputFilePath';

      //Basic
      //String command = '-i $_selectedFilePath -af afftdn $outputFilePath';

      //Complex
      //final String command =
      //'-y -i $_selectedFilePath -af afftdn=nr=15:om=d $outputFilePath';

      //final String command =
      //  '-y -i $_selectedFilePath -af afftdn=nr=10:nf=-30:tn=1 $outputFilePath';

      final String command =
          '-y -i $_selectedFilePath -af "highpass=f=300, lowpass=f=3000" $outputFilePath';

      // // Execute the FFmpeg command
      await _flutterFFmpeg.execute(command).then((rc) {
        if (rc == 0) {
          setState(() {
            _outputFilePath = outputFilePath;
          });
          print('Noise reduction completed. File saved at $outputFilePath');
        } else {
          print('Error in noise reduction');
        }
      });
    } else {
      print('No file selected for noise reduction');
    }
  }

  Future<String> getOutputFilePath() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get document directory
    String fileName = 'noise_reduced_output.wav'; // Specify output file name
    return '${directory.path}/$fileName'; // Full file path
  }

  bool isPlaying1 = false;

  Future<void> playReducedAudio() async {
    if (_outputFilePath != null &&
        _outputFilePath!.isNotEmpty &&
        isPlaying1 == false) {
      await _audioPlayer.play(DeviceFileSource(_outputFilePath!));
    } else if (isPlaying1) {
      await _audioPlayer.pause();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please click reduce audio to apply noise reduction'),
          duration: Duration(seconds: 2),
        ),
      );
      print("No reduced audio file available to play");
    }

    setState(() {
      isPlaying1 = !isPlaying1;
    });
  }

  // Future<String> getCustomOutputFilePath(String customFileName) async {
  //   final directory =
  //       await getApplicationDocumentsDirectory(); // Get document directory
  //   return '${directory.path}/$customFileName'; // Return full file path
  // }

  // Future<String?> _showFileNameDialog() async {
  //   String? fileName;
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Enter File Name'),
  //         content: TextField(
  //           onChanged: (value) {
  //             fileName =
  //                 value; //here is the issue, if i dont press save it will still save it!!!!
  //           },
  //           decoration: const InputDecoration(hintText: "File Name"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(fileName);
  //             },
  //             child: const Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   return fileName;
  // }

  //bool _isSaved = false;

  // Future<void> saveReducedAudio() async {
  //   String? customFileName = await _showFileNameDialog();

  //   if (customFileName == null || customFileName.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter a name for the audio!'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     return;
  //   }

  //   // if (_outputFilePath == null || _outputFilePath!.isEmpty) {
  //   //   print('No reduced audio to save');
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(
  //   //       content: Text('No reduced audio available to save.'),
  //   //       duration: Duration(seconds: 2),
  //   //     ),
  //   //   );
  //   //   return; // Exit early if no reduced audio file exists
  //   // }

  //   if (_outputFilePath != null && customFileName != null) {
  //     // Use the custom file name for saving
  //     try {
  //       String outputFilePath = await getCustomOutputFilePath(customFileName);

  //       final tempFile = File(_outputFilePath!);
  //       final savedFile = await tempFile.rename(outputFilePath);

  //       setState(() {
  //         _outputFilePath = savedFile.path;
  //       });

  //       context.read<AudioProvider>().addAudio(
  //             Audio(
  //                 name: customFileName,
  //                 path:
  //                     _outputFilePath!), //set state karke custom one has been changed to outputfilepath
  //           );

  //       // setState(() {
  //       //   _isSaved = true;
  //       // });

  //       print('Audio saved as $customFileName at $outputFilePath');
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print('No reduced audio to save');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Noise Reduction App"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const SaveScreen();
              }));
            },
            child: const Text("Saved Audios"),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: pickAudio, child: const Text("Pick Audio")),
            const SizedBox(
              height: 20,
            ),
            Text("Selected audio $_fileName"),
            //ElevatedButton(
            //onPressed: playAudio, child: const Text("Play audio")),
            IconButton(
                onPressed: playAudio,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
            ElevatedButton(
                onPressed: reduceNoise, child: const Text("Reduce Noise")),
            IconButton(
                icon: Icon(isPlaying1 ? Icons.pause : Icons.play_arrow),
                onPressed: playReducedAudio),

            ElevatedButton(
                //onPressed: _isSaved ? null : () => saveReducedAudio(),
                onPressed: () {
                  //saveReducedAudio();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddAudio(outputFile: _outputFilePath);
                      },
                    ),
                  );
                },
                child: const Text("Save the audio"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
