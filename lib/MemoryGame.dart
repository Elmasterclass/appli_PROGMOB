import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/**
 *  JEU DES CHIFFRES/BOUTONS
 */

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<int> _sequence = [];
  List<int> _userInput = [];
  int _score = 0;
  late Timer _timer;
  int _secondsRemaining = 15;

  bool end = false;
  @override
  void initState() {
    super.initState();
    _generateSequence();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _generateSequence() {
    _sequence.clear();
    final random = Random();
    for (int i = 0; i < 3; i++) {
      _sequence.add(random.nextInt(3) + 1);
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);

    // Gere le temps et les actions associées
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_secondsRemaining == 0) {
        end = true;
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _validateInput() {
    String userInput = _userInput.join();
    String sequenceString = _sequence.join();
    if (userInput == sequenceString) {
      setState(() {
        _score++;
        _generateSequence();
        _userInput.clear();
      });
    } else {
      setState(() {
        _score = max(0, _score - 1);
        _userInput.clear();
      });
    }
  }

  void _onButtonPressed(int value) {
    if (_userInput.length < _sequence.length) {
      setState(() {
        _userInput.add(value);
      });
      if (_userInput.length == _sequence.length) {
        _validateInput();
      }
    }
  }

  Widget _buildButton(int value) {
    return GestureDetector(
      onTap: () => _onButtonPressed(value),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey,
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (end) {
      return _buildEndPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Memory Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$_secondsRemaining secondes restantes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Combinaison: ${_sequence.join()}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 3; i++)
                Row(
                  children: [
                    _buildButton(i),
                    SizedBox(height: 10),
                  ],
                ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '${_userInput.join()}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Score: $_score',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEndPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Memory Game',
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
