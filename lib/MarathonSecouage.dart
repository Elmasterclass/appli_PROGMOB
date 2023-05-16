import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MarathonSecouage extends StatefulWidget {
  @override
  _MarathonSecouage createState() => _MarathonSecouage();
}

class _MarathonSecouage extends State<MarathonSecouage> {
  double _acceleration = 0.0;
  int _score = 0;
  int _duration = 15; // Durée du jeu en secondes
  int _interval = 500; // Intervalle de mesure en millisecondes
  int _currentTime = 0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool end = false;

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    _startTimer();
  }

  void _startAccelerometer() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      final double acceleration = event.x.abs() + event.y.abs() + event.z.abs();
      setState(() {
        _acceleration = acceleration;
      });
    });
  }

  void _startTimer() {
    Future.delayed(Duration(milliseconds: _interval), () {
      if (_currentTime >= _duration * 1000) {
        _stopAccelerometer(); // Arrêter l'écoute de l'accéléromètre
        end = true;
      } else {
        _currentTime += _interval;
        final double acceleration = _acceleration;
        if (acceleration.toInt() >= 30)
          setState(() {
            _score += acceleration.toInt();
          });
        _startTimer();
      }
      setState(() {}); // Met à jour l'affichage du temps restant
    });
  }

  void _stopAccelerometer() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    if (end) {
      return _buildEndPage();
    }
    String timeRemaining = ((_duration * 1000 - _currentTime) / 1000)
        .toStringAsFixed(1); // Convertit le temps restant en format décimal
    return Scaffold(
      appBar: AppBar(
        title: Text('Shaking Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temps restant : $timeRemaining s',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Score : $_score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
          'Shaking Game',
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
