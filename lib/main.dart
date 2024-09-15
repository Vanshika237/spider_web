import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider Web',
      theme: ThemeData(
          useMaterial3: true, scaffoldBackgroundColor: Colors.blueGrey[900]),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var circleIndexes = [2, 5, 9, 12, 16, 18];
  List<int> glow = [];

  bool play = false;

  int? score;

  Timer? timer;

  final String url = "https://vanshika237.github.io/";

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  _startPlaying() {
    play = true;
    score = 0;
    if (mounted) {
      setState(() {});
    }
    _startPlayTimer();
    Timer(const Duration(seconds: 30), () {
      timer?.cancel();
      if (mounted) {
        setState(() {
          play = false;
        });
      }
    });
  }

  _startPlayTimer() {
    _setGlow();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _setGlow();
    });
  }

  _setGlow() {
    glow.clear();
    var count = Random().nextInt(6);
    for (int i = 0; i <= count; i++) {
      glow.add(Random().nextInt(6));
    }
    glow = glow.toSet().toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showSmallButton = MediaQuery.sizeOf(context).width < 600;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Stack(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0, left: 16, right: 16),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Tap the buttons that glow",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      )),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: showSmallButton ? 375 : 425,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_circle(showSmallButton, 0)],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            _circle(showSmallButton, 1),
                            Expanded(child: Container()),
                            _circle(showSmallButton, 2),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_circle(showSmallButton, 3)],
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            Expanded(child: _circle(showSmallButton, 4)),
                            Expanded(child: _circle(showSmallButton, 5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!play)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _startPlaying();
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                    child: Center(
                      child: Text(
                        score == null ? 'START' : 'PLAY AGAIN',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ),
                  ),
                ),
              if (!play && score != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Score: $score",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 32),
                      )),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    padding: const EdgeInsets.all(16),
                    splashRadius: 16,
                    tooltip: "Say Hi!",
                    onPressed: () async {
                      try {
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url,
                              mode: LaunchMode.platformDefault);
                        } else {
                          throw "Could not launch $url";
                        }
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                    icon: Icon(Icons.waving_hand_outlined,
                        color: Colors.white.withOpacity(0.5))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _circle(bool showSmallButton, int index) {
    bool isGlowing = glow.contains(index);
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: isGlowing
            ? () {
                glow.remove(index);
                score = (score ?? 0) + 10;
                if (mounted) {
                  setState(() {});
                }
              }
            : null,
        child: SizedBox(
          height: showSmallButton ? 70 : 90,
          width: showSmallButton ? 70 : 90,
          child: Container(
            width: showSmallButton ? 70 : 90,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                boxShadow: isGlowing
                    ? [
                        const BoxShadow(
                          color: Colors.red,
                          spreadRadius: 4,
                          blurRadius: 15,
                        ),
                      ]
                    : []),
          ),
        ));
  }
}
