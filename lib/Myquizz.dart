import 'package:flutter/material.dart';
// import 'package:quizz/Question.dart';
// import 'dart:convert';
// import 'dart:async';
import 'package:provider/provider.dart';
import 'package:quizz/QuizzProvider.dart';
// import 'package:http/http.dart' as http;

class Myquizz extends StatelessWidget {
  const Myquizz({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizzProvider()..mesquestion(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Consumer<QuizzProvider>(
            builder: (context, provider, _) => Text(
              'Score: ${provider.score}',
              style: TextStyle(color: Colors.red, fontSize: 20,),
            ),
          ),
          elevation: 12,
        ),
        backgroundColor: Colors.lightBlue,
        body: Consumer<QuizzProvider>(
          builder: (context, provider,_) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.questions.isEmpty) {
              return Center(child: Text("Aucune question disponible"));
            }
            if (provider.numeroQuestion >= provider.questions.length) {
              return _buildEndScreen(context, provider);
            }
            final question = provider.questions[provider.numeroQuestion];
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.only(bottom: 180.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        question.question ?? 'Question indisponible',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:Text(
                    question.category ?? 'Catégorie indisponible',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue,),
                  ),
                ),
                Text(
                  'Question ${provider.numeroQuestion + 1} sur ${provider.questions.length}',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => provider.verifierReponse(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                      ),
                      child: Text(
                        'VRAI',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () => provider.verifierReponse(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                      ),
                      child: Text(
                        'FAUX',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEndScreen(BuildContext context, QuizzProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Quiz terminé !', style: TextStyle(fontSize: 30)),
          Text(
            'Score final : ${provider.score}',
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              provider.reset();
            },
            child: Text('Rejouer'),
          ),
        ],
      ),
    );
  }
}
