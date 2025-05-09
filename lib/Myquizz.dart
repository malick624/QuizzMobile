// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizz/QuizzProvider.dart';

class Myquizz extends StatelessWidget {
  const Myquizz({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizzProvider()..mesquestion(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Consumer<QuizzProvider>(
            builder: (context, provider, _) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'Score: ${provider.score}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Consumer<QuizzProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
              if (provider.questions.isEmpty) {
                return Center(
                  child: Text(
                    "Aucune question disponible",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                );
              }
              if (provider.numeroQuestion >= provider.questions.length) {
                return _buildEndScreen(context, provider);
              }
              final question = provider.questions[provider.numeroQuestion];

              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                      child: _ProgressBar(
                        value: (provider.numeroQuestion + 1) / provider.questions.length,
                      ),
                    ),
                    // Question Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(28.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              question.question ?? 'Question indisponible',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category, color: Colors.blue[400]),
                                SizedBox(width: 6),
                                Text(
                                  question.category ?? 'Catégorie indisponible',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blue[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    // Question Number
                    Center(
                      child: Text(
                        'Question ${provider.numeroQuestion + 1} sur ${provider.questions.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    // Answer Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AnswerButton(
                            label: 'VRAI',
                            color: Colors.green,
                            icon: Icons.check_circle,
                            onTap: () => provider.verifierReponse(true),
                          ),
                          _AnswerButton(
                            label: 'FAUX',
                            color: Colors.red,
                            icon: Icons.cancel,
                            onTap: () => provider.verifierReponse(false),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 36),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEndScreen(BuildContext context, QuizzProvider provider) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.all(32),
        margin: EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 60),
            SizedBox(height: 16),
            Text(
              'Quiz terminé !',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Score final : ${provider.score}',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blueGrey[700],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                provider.reset();
              },
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Rejouer',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Progress Bar Widget
class _ProgressBar extends StatelessWidget {
  final double value;
  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        backgroundColor: Colors.white.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      ),
    );
  }
}

// Answer Button Widget
class _AnswerButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
