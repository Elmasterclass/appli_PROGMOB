import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'Wifi.dart';
import 'package:just_audio/just_audio.dart';

// Score adversaire
int scoreJ1 = 0;

/**
 *  JEU MARTEAU WIFI
 */

class Marteau extends StatefulWidget {
  const Marteau({Key? key}) : super(key: key);

  @override
  _MarteauState createState() => _MarteauState();

  static void recScore(int score) {
    scoreJ1 = score;
    print("receive from wifiPage" + scoreJ1.toString());
  }
}

class _MarteauState extends State<Marteau> {
  // Score joueur instance
  int _score = 0;
  late int _targetCircleIndex;
  late List<bool> _isCircleActiveList;
  late Timer _timer;
  late int _remainingSeconds;
  bool _end = false;
  late AudioPlayer player;

  // Envoi le score du joueur courant à l'adversaire
  void sendToJ2() {
    WifiPage.receiveScore(_score);
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _isCircleActiveList = List.generate(9, (_) => false);
    _remainingSeconds = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        sendToJ2();
        scoreJ1;
        setState(() {
          _remainingSeconds--;
        });
      } else {
        sendToJ2();
        scoreJ1;
        setState(() {
          _timer.cancel();
          _end = true;
          /*
          * Essai du son, non fonctionnel, erreur d'asynchro
          *
          if (_remainingSeconds == 0 && _score > scoreJ1) {
            print("son");
            player.setAsset('assets/winner.mp3');
            player.play();
          }
          if (_remainingSeconds == 0 && _score < scoreJ1) {
            print("son loose");
            player.setAsset('assets/looser.mp3');
            player.play();
          }
          */
        });
      }
    });

    _startNewGame();
  }

  @override
  void dispose() {
    scoreJ1 = 0;
    player.stop();
    player.dispose();
    super.dispose();
  }

  void _startNewGame() {
    _targetCircleIndex = Random().nextInt(9);
    _isCircleActiveList = List.generate(9, (_) => false);
    _isCircleActiveList[_targetCircleIndex] = true;
  }

  void _handleCircleTap(int index) {
    if (_end) return; // Ignore taps when the game has ended
    if (index == _targetCircleIndex) {
      setState(() {
        _score++;
        _startNewGame();
      });
    } else {
      setState(() {
        if (_score > 0) {
          _score--;
        }
      });
    }
  }

  Widget _buildCircle(int index) {
    return GestureDetector(
      onTap: () => _handleCircleTap(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: _isCircleActiveList[index] ? Colors.orange : Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Ecran de fin
  Widget _buildEndPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Hammer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_score > scoreJ1)
              Text(
                'Tu as gagné avec un score de : $_score',
                style: TextStyle(fontSize: 24),
              ),
            if (_score > scoreJ1)
              Text(
                'Le score adverse est : $scoreJ1',
                style: TextStyle(fontSize: 24),
              ),
            if (_score < scoreJ1)
              Text(
                'Tu as perdu avec un score de : $_score',
                style: TextStyle(fontSize: 24),
              ),
            if (_score < scoreJ1)
              Text(
                'Le score adverse est : $scoreJ1',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> playSound() async {
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    // Affichage de l'ecran de fin si le jeu est terminé
    if (_end) {
      sendToJ2();
      return _buildEndPage();
    }

    // Affichage de l'ecran de jeu
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Hammer'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Temps restant: $_remainingSeconds',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(9, (index) => _buildCircle(index)),
            ),
          ],
        ),
      ),
    );
  }
}
