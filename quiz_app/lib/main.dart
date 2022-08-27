import 'package:flutter/material.dart';

import 'quiz.dart';
import 'result.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      'questionText': 'Which snake can build its own nest?',
      'answers': [
        {
          'text': 'Black Mamba',
          'score': 1,
        },
        {
          'text': 'King Cobra',
          'score': 10,
        },
        {
          'text': 'Inland Typhan',
          'score': 1,
        },
        {
          'text': 'Rattle Snake',
          'score': 1,
        },
      ],
    },
    {
      'questionText': 'Which best colour?',
      'answers': [
        {
          'text': 'Black',
          'score': 8,
        },
        {
          'text': 'White',
          'score': 10,
        },
        {
          'text': 'Orange',
          'score': 7,
        },
        {
          'text': 'Brown',
          'score': 5,
        },
      ],
    },
    {
      'questionText': 'Who is God?',
      'answers': [
        {
          'text': 'Ram',
          'score': 10,
        },
        {
          'text': 'You',
          'score': 7,
        },
        {
          'text': 'Rupal',
          'score': 8,
        },
        {
          'text': 'Krishna',
          'score': 10,
        },
      ],
    },
  ];
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                _questions,
                _questionIndex,
                _answerQuestion,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
