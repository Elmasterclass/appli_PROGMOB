import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/MarathonSecouage.dart';
import 'package:flutter_application_1/MemoryGame.dart';
import 'package:flutter_application_1/RapidTap.dart';
import 'Couleurs.dart';
import 'Quiz.dart';
import 'package:flutter_application_1/Marteau.dart';
import 'package:flutter_application_1/MarteauSolo.dart';
import 'Wifi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fun App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[600],
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
      routes: {
        '/multiplayer': (context) => MultiplayerPage(),
        '/solo': (context) => SoloPage(),
      },
    );
  }
}

// Page principale
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Have Fun !'),
        centerTitle: true, // Titre centré
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/multiplayer');
              },
              child: Text(
                'Mode multijoueur',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/solo');
              },
              child: Text(
                'Mode solo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page Multi
class MultiplayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode multijoueur'),
        centerTitle: true,
      ),
      body: WifiPage(), // Appel de WifiPage
    );
  }
}

// Page Solo
class SoloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              // Jeu 1
              child: Text(
                'Color Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Couleurs()),
                );
              },
            ),
            SizedBox(height: 20),
            // Jeu 2
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              child: Text(
                'Culture Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz()),
                );
              },
            ),
            SizedBox(height: 20),
            // Jeu 3
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              child: Text(
                'Hammer Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarteauSolo()),
                );
              },
            ),
            SizedBox(height: 20),
            // Jeu 4
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              child: Text(
                'Shaking Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarathonSecouage()),
                );
              },
            ),
            SizedBox(height: 20),
            // Jeu 5
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              child: Text(
                'Memory Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoryGame()),
                );
              },
            ),
            SizedBox(height: 20),
            // Jeu 6
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50), // Taille fixe
              ),
              child: Text(
                'Reflex Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RapidTap()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
