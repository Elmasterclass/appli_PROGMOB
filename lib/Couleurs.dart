import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class Couleurs extends StatefulWidget {
  @override
  _CouleursState createState() => _CouleursState();
}

class _CouleursState extends State<Couleurs> {
  List<String> colorNames = ['ROUGE', 'VERT', 'BLEU'];
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];
  // Score
  List<int> score = [0, 0];
  int currentScore = 0;

  // Timer
  late Timer _timer;
  late int _remainingSeconds;
  bool _end = false;
  bool _changeColor = false;

  // Gestion aléatoire
  Random random = Random();
  int randomIndex = 0;
  int correctIndex = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 15;
    // Met à jour le jeu avec le temps
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _end = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Page de fin si le jeu est terminé
    if (_end) {
      return _buildEndPage();
    }
    // Page de jeu
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Color Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Appuyez sur le cercle correspondant à la couleur écrite',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              colorNames[correctIndex],
              style: TextStyle(
                fontSize: 32.0,
                color: _changeColor
                    ? colors[random.nextInt(colors.length)]
                    : colors[randomIndex],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (correctIndex == 0) {
                      setState(() {
                        currentScore++;
                      });
                      _changeColor = true;
                    } else {
                      if (currentScore > 0) currentScore--;
                      _changeColor = true;
                    }
                    _nextRound();
                  },
                  child: CircleAvatar(
                    backgroundColor: colors[0],
                    radius: 50.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (correctIndex == 1) {
                      setState(() {
                        currentScore++;
                      });
                      _changeColor = true;
                    } else {
                      if (currentScore > 0) currentScore--;
                      _changeColor = true;
                    }
                    _nextRound();
                  },
                  child: CircleAvatar(
                    backgroundColor: colors[1],
                    radius: 50.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (correctIndex == 2) {
                      setState(() {
                        currentScore++;
                      });
                      _changeColor = true;
                    } else {
                      if (currentScore > 0) currentScore--;
                      _changeColor = true;
                    }
                    _nextRound();
                  },
                  child: CircleAvatar(
                    backgroundColor: colors[2],
                    radius: 50.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Score: $currentScore',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Temps restant: $_remainingSeconds',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _nextRound() {
    setState(() {
      correctIndex = random.nextInt(colors.length);
      randomIndex = random.nextInt(colors.length); // Nouvelle ligne
      _changeColor = false;
    });
  }

  Widget _buildEndPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Color Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '    Temps écoulé ! \n Ton score est de: $currentScore',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
