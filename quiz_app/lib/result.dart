import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetQuiz;

  const Result(this.resultScore, this.resetQuiz, {Key? key}) : super(key: key);

  String get resultPhrase {
    var resultText = 'You did it! Score: $resultScore';

    if (resultScore <= 8) {
      resultText = 'Go study kid!';
    } else if (resultScore <= 20) {
      resultText = 'Still need to imporve';
    } else {
      resultText = 'You have known god himself!';
    }

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhrase,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.blue,
              side: const BorderSide(
                color: Colors.blue,
              ),
            ),
            onPressed: resetQuiz,
            child: const Text(
              'Restart Quiz',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
