import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_sweep/add_audio.dart';

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
  String? _outputFilePath; //for temporary file path to play the audio
  String? _fileName = ""; // selected audio file name

  @override
  void initState() {
    super.initState();
  }

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
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlaying = false; //as soon as audio finishes it should stop
          });
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select audio  file to play'),
          duration: Duration(seconds: 3),
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

      // Execute the FFmpeg command
      await _flutterFFmpeg.execute(command).then((rc) {
        if (rc == 0) {
          setState(() {
            _outputFilePath = outputFilePath;
          });
          print('Noise reduction completed. File saved at $outputFilePath');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Noise reduction completed. Please save the file'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print('Error in noise reduction');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected for noise reduction'),
          duration: Duration(seconds: 3),
        ),
      );
      print('No file selected for noise reduction');
    }
  }

  Future<String> getOutputFilePath() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get document directory
    String fileName =
        'noise_reduced_output.wav'; // Specify output file name //This is temporary file name which will be changed once audio is saved
    return '${directory.path}/$fileName'; // Full file path
  }

  bool isPlaying1 = false;

  Future<void> playReducedAudio() async {
    if (_outputFilePath != null && _outputFilePath!.isNotEmpty) {
      if (isPlaying1 == false) {
        try {
          await _audioPlayer.play(DeviceFileSource(
              _outputFilePath!)); //exception here because i have changed the name but in this var it is same old path
          _audioPlayer.onPlayerComplete.listen((event) {
            setState(() {
              isPlaying1 = false;
            });
          });
        } catch (e) {
          print(e);
        }
      } else {
        //if (isPlaying1)
        await _audioPlayer.pause();
      }
      setState(() {
        isPlaying1 = !isPlaying1;
      });
    } else {
      //if (_outputFilePath == null)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please click reduce audio to apply noise reduction'),
          duration: Duration(seconds: 5),
        ),
      );
      print("No reduced audio file available to play");
    }
    // setState(() {
    //   isPlaying1 = !isPlaying1;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Audio Processing')),
        backgroundColor: const Color.fromARGB(255, 1, 33, 75),
        foregroundColor: const Color.fromARGB(255, 93, 211, 247),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //         return const SaveScreen();
        //       }));
        //     },
        //     child: const Text("Saved Audios"),
        //   )
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickAudio,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 33, 75),
                // Button color
              ),
              child: const Text("Pick Audio",
                  style: TextStyle(color: Color.fromARGB(255, 93, 211, 247))),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Selected audio: $_fileName"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                playAudio(); // Call function to play the audio
              },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Color.fromARGB(255, 93, 211, 247)),
              label: const Text(
                'Play Selected Audio',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 33, 75),
                // Button color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                reduceNoise(); // Call function to reduce noise
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 1, 33, 75), // Button color
              ),
              child: const Text(
                'Reduce Noise',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                playReducedAudio(); // Call function to play reduced audio
              },
              icon: Icon(isPlaying1 ? Icons.pause : Icons.play_arrow,
                  color: Color.fromARGB(255, 93, 211, 247)),
              label: const Text(
                'Play Reduced Audio',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 1, 33, 75), // Button color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //saveReducedAudio();

                if (_outputFilePath != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddAudio(outputFile: _outputFilePath);
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No audio available to save'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 1, 33, 75), // Button color
              ),
              child: const Text(
                'Save Reduced Audio',
                style: TextStyle(color: Color.fromARGB(255, 93, 211, 247)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
