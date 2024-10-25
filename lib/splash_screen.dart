import 'package:flutter/material.dart';
import 'package:sound_sweep/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      //Navigator.pushReplacementNamed(context, '/welcome');
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //   return const WelcomeScreen();
      // }));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 23, 51),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              //padding: EdgeInsets.only(top: 50.0),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.06,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04),
              child: const Text(
                'SoundSweep',
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 211, 247),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Display GIF
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width * 1.0,
              child: Image.asset(
                  'assets/noise_reduction.gif'), // Display GIF from assets
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
              child: Text(
                '"Silence the noise, enhance the sound."',
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 211, 247),
                  fontSize: 20,
                  // fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
