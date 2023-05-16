import 'package:flutter/material.dart';
import 'dart:math';

class QuizQuestion {
  String question;
  List<String> options;
  int correctOptionIndex;
  int number;

  QuizQuestion({
    required this.question,
    required this.number,
    required this.options,
    required this.correctOptionIndex,
  });
}

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _answeredQuestions = 0;

// Liste des questions
  List<QuizQuestion> _questions = [
    QuizQuestion(
      question: "Quelle est la capitale de la France ?",
      number: 1,
      options: ["Paris", "Londres", "Berlin", "Madrid"],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question:
          "Quel est le plus grand pays du monde en termes de superficie ?",
      number: 2,
      options: ["Russie", "Canada", "Chine", "Etats-Unis"],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "Qui est l'auteur de 'Les Misérables' ?",
      number: 3,
      options: [
        "Victor Hugo",
        "Emile Zola",
        "Gustave Flaubert",
        "Albert Camus"
      ],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "Quelle est la capitale de l'Australie ?",
      number: 4,
      options: ["Sydney", "Melbourn", "Canberra", "Perth"],
      correctOptionIndex: 2,
    ),
    QuizQuestion(
      question: "Qui a écrit le roman 1984 ?",
      number: 5,
      options: [
        "George Orwell",
        "Aldous Huxley",
        "Ernest Hemingway",
        "F. Scott Fitzgerald"
      ],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "Quel est le plus grand Océan du monde ?",
      number: 6,
      options: [
        "Océan Arctique",
        "Océan Pacifique",
        "Océan Indien",
        "Océan Atlantique"
      ],
      correctOptionIndex: 1,
    ),
    QuizQuestion(
      question: "Quelle est la planète la plus proche du soleil ?",
      number: 7,
      options: ["Mars", "Vénus", "Mercure", "Jupiter"],
      correctOptionIndex: 2,
    ),
    QuizQuestion(
      question: "Quel pays a remporté la coupe du monde de football en 2018 ?",
      number: 8,
      options: ["Allemagne", "Argentine", "France", "Brésil"],
      correctOptionIndex: 2,
    ),
    QuizQuestion(
      question: "Qui a peint La Joconde ?",
      number: 9,
      options: [
        "Michel-Ange",
        "Leonardo da Vinci",
        "Vincent van Gogh",
        "Pablo Picasso"
      ],
      correctOptionIndex: 1,
    ),
    QuizQuestion(
      question: "Quel est le plus haut sommet du monde ?",
      number: 10,
      options: [
        "Mont Kilimandjaro",
        "Mont Everest",
        "Mont McKinley (Denali)",
        "Mont Blanc"
      ],
      correctOptionIndex: 1,
    ),
    QuizQuestion(
      question: "Quelle est la capitale de l'Espagne ?",
      number: 11,
      options: ["Madrid", "Barcelone", "Séville", "Valence"],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "Combien de continents y a-t-il sur terre ?",
      number: 12,
      options: ["4", "5", "6", "7"],
      correctOptionIndex: 3,
    ),
    QuizQuestion(
      question: "Quel est l'animal terrestre le plus rapide ?",
      number: 13,
      options: ["Guépard", "Lion", "Gazelle", "Springbok"],
      correctOptionIndex: 0,
    ),
  ];

  List<QuizQuestion> _randomQuestions = [];

  List<QuizQuestion> _generateRandomQuestions() {
    final random = Random();
    // _randomQuestions = [];

    while (_currentQuestionIndex < 4) {
      final randomIndex = random.nextInt(_questions.length);
      final selectedQuestion = _questions[randomIndex];

      if (!_randomQuestions.contains(selectedQuestion)) {
        _randomQuestions.add(selectedQuestion);
      }
      if (_randomQuestions.length == 4) {
        break; // Arrête la boucle lorsque 4 questions ont été ajoutées
      }
    }

    return _randomQuestions;
  }

  @override
  void initState() {
    super.initState();
    _randomQuestions = _generateRandomQuestions();
  }

  void _checkAnswer(int selectedIndex) {
    if (selectedIndex ==
        _randomQuestions[_currentQuestionIndex].correctOptionIndex) {
      setState(() {
        _score++;
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Culture Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _currentQuestionIndex < 4
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        _randomQuestions[_currentQuestionIndex].question,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    ..._randomQuestions[_currentQuestionIndex]
                        .options
                        .asMap()
                        .entries
                        .map(
                          (option) => Container(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _checkAnswer(option.key);
                                },
                                child: Text(option.value),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous avez obtenu $_score/${_randomQuestions.length} points !",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
