import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/**
 *  JEU DU BOUTON QUI APPARAIT AU HASARD
 */

class RapidTap extends StatefulWidget {
  @override
  _RapidTapState createState() => _RapidTapState();
}

class _RapidTapState extends State<RapidTap> {
  late Timer _timer;
  int _score = 0;
  Offset _buttonPosition = Offset(0, 0);
  int _secondsRemaining = 15;
  bool end = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          end = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _incrementScore() {
    setState(() {
      _score++;
      _generateRandomPosition();
    });
  }

  void _generateRandomPosition() {
    final random = Random();
    // Taille predefini de la zone où les boutons peuvent apparaitre
    double maxX = MediaQuery.of(context).size.width - 175;
    double maxY = MediaQuery.of(context).size.height - 295;
    double x = random.nextDouble() * maxX;
    double y = random.nextDouble() * maxY;
    _buttonPosition = Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    // Page de fin de jeu si il est terminé
    if (end) {
      return _buildEndPage();
    }

    // Page de jeu
    return Scaffold(
      appBar: AppBar(
        title: Text('Reflex Game'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              'Temps restant: $_secondsRemaining secondes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              'Score: $_score',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _incrementScore();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.orange,
                  margin: EdgeInsets.only(
                    left: _buttonPosition.dx,
                    top: _buttonPosition.dy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              '    Temps écoulé ! \n Ton score est de: $_score',
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
