import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();
void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // A list of Icon objects is used to keep track of the score. This List will be displayed at the bottom of the screen as the score card
  List<Icon> score = [];

  // The counter is used to keep track of the total correct number of answers
  int counter = 0;

  //the total number of questions
  int total = QuizBrain().getTotal();

//checkAnswer takes in a bool answer from the user as the argument and does the main functionality of checking whether correct or nah
  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    //SetState is used to continuously update the screen when a button is placed
    setState(() {

      //created function to check if the number of questions in the List has been met
      if (quizBrain.isFinished() == true) {

        //pop up is sent if the end of the quiz is reached
        Alert(
          context: context,
          title: 'Finished!',
          desc:
              'You\'ve reached the end of the quiz. \n You scored: \n  $counter/$total',
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                print("Finished");
              },
            )
          ],
        ).show();

        //created function that sends the user back to the beginning of the quiz
        quizBrain.reset();

        //empties/clears the score card list
        score = [];

        //resets the counter back to 0
        counter = 0;
      } else {
        //adds check icon to the score card List 
        if (userPickedAnswer == correctAnswer) {
          score.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          //increment counter as this indicates a correct answer
          counter = counter + 1;
        } else {
          score.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        //loads up the next question to state
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        //Title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Quizzler",
              style: GoogleFonts.lobster(
                color: Colors.white,
                fontSize: 60.0,
              ),
            ),
          ),
        ),

        //Question text
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        //true buttton
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),

        //false button
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            //this displays the score card List 
            children: score,
          ),
        )
      ],
    );
  }
}
