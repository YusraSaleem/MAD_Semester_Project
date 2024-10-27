// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'audio.dart';
// import 'audio_db.dart';
// import 'audio_provider.dart';

// class SaveScreen extends StatefulWidget {
//   const SaveScreen({super.key});

//   @override
//   State<SaveScreen> createState() => _SaveScreenState();
// }

// class _SaveScreenState extends State<SaveScreen> {
//   List<Audio> audios = [];
//   AudioDatabase db = AudioDatabase();
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   //bool isPlaying2 = false; //Here it was global that's why all tiles were changing states
//   List<bool> isPlayingList = [];

//   void initState() {
//     super.initState();
//     _loadAudios();
//   }

//   _loadAudios() async {
//     final audiolist =
//         await db.getAllAudios(); //fetch audios from DB and store it
//     setState(() {
//       audios = audiolist;
//       isPlayingList = List.filled(audios.length, false); //fills the list with
//     });
//   }

//   playAudioAgain(int index) async {
//     if (!isPlayingList[index]) {
//       try {
//         await _audioPlayer.play(DeviceFileSource(audios[index].path));
//         print(audios[index].path);

//         _audioPlayer.onPlayerComplete.listen((event) {
//           setState(() {
//             isPlayingList[index] =
//                 false; // update the icon when audio finishes //as soon as audio finishes it should stop
//           });
//         });
//       } catch (e) {
//         print(e);
//       }
//     } else if (isPlayingList[index]) {
//       await _audioPlayer.pause();
//     } else if (isPlayingList.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please click reduce audio to apply noise reduction'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       print("No audio file available to play");
//     }

//     setState(() {
//       isPlayingList[index] = !isPlayingList[index];

//       /// EXCEPTION HERE. Solved
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final audios = context.watch<AudioProvider>().audios;

//     // Future<void> _loadAudios() async { //!!!!
//     //   await Provider.of<AudioProvider>(context, listen: false).loadAudios();
//     // }
//     // final audios = context
//     //     .watch<AudioProvider>()
//     //     .audios; // Use context.watch to get the updated list

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Save Audio'),
//         backgroundColor: const Color.fromARGB(255, 1, 33, 75),
//         foregroundColor: const Color.fromARGB(255, 45, 198, 245),
//       ),
//       body: FutureBuilder(
//         future: context.read<AudioProvider>().loadAudios(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child:
//                     CircularProgressIndicator()); // Show a loading indicator while fetching
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error: ${snapshot.error}')); // Show if any errors
//           }

//           final audios = context
//               .watch<AudioProvider>()
//               .audios; // Use context.watch to get the updated list

//           if (audios.isEmpty) {
//             return const Center(
//                 child: Text('No saved audios.')); // Handle empty list
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: audios.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.width * 0.02,
//                           left: MediaQuery.of(context).size.width * 0.04,
//                           right: MediaQuery.of(context).size.width * 0.04),
//                       child: Card(
//                         color: const Color.fromARGB(255, 1, 33, 75),
//                         child: ListTile(
//                           title: Text(audios[index].name,
//                               style: const TextStyle(
//                                 color: Color.fromARGB(255, 93, 211, 247),
//                               )),
//                           //subtitle: Text(audios[index].path),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete,
//                                 color: Color.fromARGB(255, 93, 211, 247)),
//                             onPressed: () {
//                               //await db.deleteAudio(audios[index].id!);
//                               context.read<AudioProvider>().removeAudio(audios[
//                                       index]
//                                   .id!); //not context.watch b/c we dont need updates
//                             },
//                           ),
//                           leading: IconButton(
//                               onPressed: () => playAudioAgain(index),
//                               icon: Icon(
//                                   isPlayingList[index]
//                                       ? Icons.pause
//                                       : Icons.play_arrow,
//                                   color: Color.fromARGB(255, 93, 211, 247))),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'audio.dart';
// import 'audio_db.dart';
// import 'audio_provider.dart';

// class SaveScreen extends StatefulWidget {
//   const SaveScreen({super.key});

//   @override
//   State<SaveScreen> createState() => _SaveScreenState();
// }

// class _SaveScreenState extends State<SaveScreen> {
//   List<Audio> audios = [];
//   AudioDatabase db = AudioDatabase();
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   //bool isPlaying2 = false; //Here it was global that's why all tiles were changing states
//   List<bool> isPlayingList = [];

//   void initState() {
//     super.initState();
//     _loadAudios();
//   }

//   _loadAudios() async {
//     final audiolist =
//         await db.getAllAudios(); //fetch audios from DB and store it
//     setState(() {
//       audios = audiolist;
//       isPlayingList = List.filled(audios.length, false); //fills the list with
//     });
//   }

//   playAudioAgain(int index) async {
//     if (!isPlayingList[index]) {
//       try {
//         await _audioPlayer.play(DeviceFileSource(audios[index].path));
//         print(audios[index].path);

//         _audioPlayer.onPlayerComplete.listen((event) {
//           setState(() {
//             isPlayingList[index] =
//                 false; // update the icon when audio finishes //as soon as audio finishes it should stop
//           });
//         });
//       } catch (e) {
//         print(e);
//       }
//     } else if (isPlayingList[index]) {
//       await _audioPlayer.pause();
//     } else if (isPlayingList.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please click reduce audio to apply noise reduction'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       print("No audio file available to play");
//     }

//     setState(() {
//       isPlayingList[index] = !isPlayingList[index];

//       /// EXCEPTION HERE. Solved
//     });
//   }

//   String searchQuery = ''; // Search query

//   @override
//    List<Audio> filteredAudios = [];

//   void _filterAudios(String query) {
//     if (query.isNotEmpty) {
//       setState(() {
//         searchQuery = query;
//         filteredAudios = audios
//             .where((audio) => audio.(query))
//             .toList();
//       });
//     } else {
//       setState(() {
//         searchQuery = '';
//         filteredAudios = audios; // Reset to the original list if query is empty
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final audios = context.watch<AudioProvider>().audios;

//     // Future<void> _loadAudios() async { //!!!!
//     //   await Provider.of<AudioProvider>(context, listen: false).loadAudios();
//     // }
//     // final audios = context
//     //     .watch<AudioProvider>()
//     //     .audios; // Use context.watch to get the updated list

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saved Audios'),
//         backgroundColor: const Color.fromARGB(255, 1, 33, 75),
//         foregroundColor: const Color.fromARGB(255, 45, 198, 245),
//       ),
//       body: 
//       FutureBuilder(
//         future: context.read<AudioProvider>().loadAudios(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child:
//                     CircularProgressIndicator()); // Show a loading indicator while fetching
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error: ${snapshot.error}')); // Show if any errors
//           }

//           final audios = context
//               .watch<AudioProvider>()
//               .audios; // Use context.watch to get the updated list

//           if (audios.isEmpty) {
//             return const Center(
//                 child: Text('No saved audios.')); // Handle empty list
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: audios.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.width * 0.02,
//                           left: MediaQuery.of(context).size.width * 0.04,
//                           right: MediaQuery.of(context).size.width * 0.04),
//                       child: Card(
//                         color: const Color.fromARGB(255, 1, 33, 75),
//                         child: ListTile(
//                           title: Text(audios[index].name,
//                               style: const TextStyle(
//                                 color: Color.fromARGB(255, 93, 211, 247),
//                               )),
//                           //subtitle: Text(audios[index].path),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete,
//                                 color: Color.fromARGB(255, 93, 211, 247)),
//                             onPressed: () {
//                               //await db.deleteAudio(audios[index].id!);
//                               context.read<AudioProvider>().removeAudio(audios[
//                                       index]
//                                   .id!); //not context.watch b/c we dont need updates
//                             },
//                           ),
//                           leading: IconButton(
//                               onPressed: () => playAudioAgain(index),
//                               icon: Icon(
//                                   isPlayingList[index]
//                                       ? Icons.pause
//                                       : Icons.play_arrow,
//                                   color: Color.fromARGB(255, 93, 211, 247))),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audio.dart';
import 'audio_db.dart';
import 'audio_provider.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<Audio> audios = [];
  List<Audio> filteredAudios = [];
  AudioDatabase db = AudioDatabase();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<bool> isPlayingList = [];
  String searchQuery = '';
   final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAudios();
  }

  _loadAudios() async {
    final audiolist = await db.getAllAudios(); //fetch audios from DB and store it
    setState(() {
      audios = audiolist;
      filteredAudios = audios; // Initially show all audios
      isPlayingList = List.filled(audios.length, false); //fills the list with
    });
  }

  void _filterAudios(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchQuery = query;
        filteredAudios = audios
            .where((audio) => audio.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        searchQuery = '';
        filteredAudios = audios; // Reset to the original list if query is empty
      });
    }
  }

  playAudioAgain(int index) async {
    if (!isPlayingList[index]) {
      try {
        await _audioPlayer.play(DeviceFileSource(filteredAudios[index].path));
        print(filteredAudios[index].path);

        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlayingList[index] = false; // update the icon when audio finishes
          });
        });
      } catch (e) {
        print(e);
      }
    } else if (isPlayingList[index]) {
      await _audioPlayer.pause();
    }

    setState(() {
      isPlayingList[index] = !isPlayingList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Audios'),
        backgroundColor: const Color.fromARGB(255, 1, 33, 75),
        foregroundColor: const Color.fromARGB(255, 45, 198, 245),
      ),
      body: FutureBuilder(
        future: context.read<AudioProvider>().loadAudios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final audios = context.watch<AudioProvider>().audios;

          if (audios.isEmpty) {
            return const Center(child: Text('No saved audios.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterAudios,
                  decoration: InputDecoration(
                    labelText: 'Search Audio',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAudios.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.02,
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: Card(
                        color: const Color.fromARGB(255, 1, 33, 75),
                        child: ListTile(
                          title: Text(
                            filteredAudios[index].name,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 93, 211, 247),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 93, 211, 247)),
                            onPressed: () {
                              context.read<AudioProvider>().removeAudio(
                                  filteredAudios[index].id!);
                            },
                          ),
                          leading: IconButton(
                            onPressed: () => playAudioAgain(index),
                            icon: Icon(
                              isPlayingList[index]
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Color.fromARGB(255, 93, 211, 247),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
