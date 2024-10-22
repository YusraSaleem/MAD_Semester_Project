//import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_sweep/audio.dart';
import 'package:sound_sweep/audio_provider.dart';
import 'package:provider/provider.dart';

class AddAudio extends StatefulWidget {
  final String? outputFile;
  @override
  State<AddAudio> createState() => _AddAudioState();
  const AddAudio({required this.outputFile});
}

class _AddAudioState extends State<AddAudio> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController nc = TextEditingController();
  final TextEditingController pc = TextEditingController();

  String? oldOutputPath = "";

  @override
  void initState() {
    super.initState();

    oldOutputPath = widget.outputFile;

    // Add listener to the first text field
    nc.addListener(() async {
      // Call the function and set the value for the second text field
      //String name = nc.text;
      pc.text = await getCustomOutputFilePath(nc.text);
    });
  }

  Future<String> getCustomOutputFilePath(String customFileName) async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get document directory
    return '${directory.path}/$customFileName'; // Return full file path
  }

  String outputFilePath = "";

  Future<void> saveReducedAudio() async {
    //String? customFileName = await _showFileNameDialog();

    // if (nc.text == null || nc.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please enter a name for the audio!'),
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    //   return;
    // }

    if (oldOutputPath == null || oldOutputPath!.isEmpty) {
      print('No reduced audio to save');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No reduced audio available to save.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Exit early if no reduced audio file exists
    }

    if (oldOutputPath != null) // && nc.text != null)
    {
      // Use the custom file name for saving
      try {
        outputFilePath = await getCustomOutputFilePath(nc.text);

        final tempFile = File(oldOutputPath!);
        final savedFile = await tempFile.rename(outputFilePath);

        setState(() {
          oldOutputPath = savedFile.path;
        });

        context.read<AudioProvider>().addAudio(
              //this addAudio uses Database insert method
              Audio(name: nc.text, path: outputFilePath),
            );

        // setState(() {
        //   _isSaved = true;
        // });

        print(
            'Audio saved as ${nc.text} at $oldOutputPath'); //outputfile path is still empty
      } catch (e) {
        print(e);
      }
      // } else {
      //   print('No reduced audio to save');
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noise reduction App"),
      ),
      body: Form(
        key: _key,
        child: Column(
          children: [
            TextFormField(
              controller: nc,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a name";
                }
              },
            ),
            TextFormField(
              controller: pc,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Path",
              ),
              readOnly: true,
            ),
            ElevatedButton(
              onPressed: () {
                if (_key.currentState!.validate()) {
                  saveReducedAudio(); //print on debug console NOT on screen
                  // CHECK IF POP SHOULD BE USED
                  Navigator.pop(context); //// CHECK THIS
                }
              }, //call insert method here
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
