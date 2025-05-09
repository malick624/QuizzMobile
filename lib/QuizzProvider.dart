// ignore_for_file: prefer_final_fields
import 'package:quizz/Question.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class QuizzProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _score = 0;
  int _numeroQuestion = 0;
  bool _isLoading = false;

  int get score => _score;
  int get numeroQuestion => _numeroQuestion;
  bool get isLoading => _isLoading;
  List<Question> get questions => _questions;

  Future<void> mesquestion() async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await http.get(
        Uri.parse(
          "https://opentdb.com/api.php?amount=10&difficulty=medium&type=boolean",
        ),
      );
      var repjson = jsonDecode(response.body);
      var results = repjson["results"];
      var unescape = HtmlUnescape();
      _questions =
          results.map<Question>((one) {
            String category = unescape.convert(one["category"]);
            String question = unescape.convert(one["question"]);
            bool correctAnswer = one["correct_answer"] == "True";
            return Question(
              question: question,
              category: category,
              correctAnswer: correctAnswer,
            );
          }).toList();
      _score = 0;
      _numeroQuestion = 0;
    } catch (e) {
      _questions = [];
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  // _isLoading = false;
  // notifyListeners();
  // _isLoading = true;
  // notifyListeners();
  // try {
  //   var response = await http.get(
  //     Uri.parse(
  //       "https://opentdb.com/api.php?amount=10&difficulty=medium&type=boolean",
  //     ),
  //   );

  //   var repjson = jsonDecode(response.body);
  //   var results = repjson["results"];

  //   List<Question> listquestion = [];
  //   for (var one in results) {
  //     String category = one["category"];
  //     String question = one["question"];
  //     bool correctAnswer = one["correct_answer"] == "True";

  //     Question maliste = Question(
  //       question: question,
  //       category: category,
  //       correctAnswer: correctAnswer,
  //     );
  //     listquestion.add(maliste);
  //   }
  //   notifyListeners();
  //   return listquestion;
  // } catch (e) {
  //   throw Exception("Error fetching data: $e");
  // }

  void verifierReponse(bool reponse) {
    if (_questions.isEmpty || _numeroQuestion >= _questions.length) {
      return;
    }
    if (reponse == _questions[_numeroQuestion].correctAnswer) {
      _score += 10;
    } else {
      _score = _score > 0 ? _score - 5 : 0;
    }
    if (_numeroQuestion < _questions.length - 1) {
      _numeroQuestion++;
    } else {
      _numeroQuestion++;
      // Fin du quiz
    }
    notifyListeners();
  }

  void reset() {
    _score = 0;
    _numeroQuestion = 0;
    notifyListeners();
    mesquestion();
  }
}
