import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/**
 *  JEU MARTEAU SOLO
 */

class MarteauSolo extends StatefulWidget {
  const MarteauSolo({Key? key}) : super(key: key);

  @override
  _MarteauSoloState createState() => _MarteauSoloState();
}

class _MarteauSoloState extends State<MarteauSolo> {
  int _score = 0;
  late int _targetCircleIndex;
  late List<bool> _isCircleActiveList;
  late Timer _timer;
  late int _remainingSeconds;
  bool _end = false;

  @override
  void initState() {
    super.initState();
    _isCircleActiveList = List.generate(9, (_) => false);
    _remainingSeconds = 15;
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
    _startNewGame();
  }

  void _startNewGame() {
    _targetCircleIndex = Random().nextInt(9);
    _isCircleActiveList = List.generate(9, (_) => false);
    _isCircleActiveList[_targetCircleIndex] = true;
  }

  void _handleCircleTap(int index) {
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
          color: _isCircleActiveList[index] ? Colors.orange : Colors.grey[200],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ecran de fin si le jeu est fini
    if (_end) {
      return _buildEndPage();
    }

    // Ecran de jeu
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hammer Game'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Temps restant: $_remainingSeconds',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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

  Widget _buildEndPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hammer Game',
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
