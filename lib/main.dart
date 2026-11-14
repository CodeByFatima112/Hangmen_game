import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman Game',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
      ),
      home: const HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> words = [
    'FLUTTER',
    'PYTHON',
    'COMPUTER',
    'KEYBOARD',
    'DEVELOPER',
    'INTERNET',
    'MOBILE',
    'PROGRAMMING',
    'DATABASE',
    'SOFTWARE',
  ];

  String word = '';
  final Set<String> guessedLetters = {};

  int wrongAttempts = 0;
  final int maxAttempts = 6;

  bool get won =>
      word.isNotEmpty &&
      word.split('').every((letter) => guessedLetters.contains(letter));

  bool get lost => wrongAttempts >= maxAttempts;

  bool get gameOver => won || lost;

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    setState(() {
      word = words[Random().nextInt(words.length)];
      guessedLetters.clear();
      wrongAttempts = 0;
    });
  }

  void guessLetter(String letter) {
    if (guessedLetters.contains(letter) || gameOver) return;

    setState(() {
      guessedLetters.add(letter);

      if (!word.contains(letter)) {
        wrongAttempts++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Column(
                children: [
                  const Icon(
                    Icons.sports_esports,
                    size: 45,
                    color: Color(0xFF6750A4),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'HANGMAN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Color(0xFF35245E),
                    ),
                  ),

                  const Text(
                    'Guess the hidden word!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // Attempts information
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('WRONG GUESSES'),
                            const SizedBox(height: 5),
                            Text(
                              '$wrongAttempts / $maxAttempts',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('REMAINING'),
                            const SizedBox(height: 5),
                            Text(
                              '${maxAttempts - wrongAttempts}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hangman drawing
                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(painter: HangmanPainter(wrongAttempts)),
                  ),

                  const SizedBox(height: 25),

                  // Hidden word
                  const Text(
                    'GUESS THE WORD',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 12,
                    children: word.split('').map((letter) {
                      bool revealed = guessedLetters.contains(letter) || lost;

                      return Container(
                        width: 35,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF6750A4),
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          revealed ? letter : '',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // Game status
                  if (gameOver)
                    Text(
                      won ? '🎉 YOU WON!' : 'GAME OVER! Word: $word',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: won ? Colors.green : Colors.red,
                      ),
                    )
                  else
                    const Text(
                      'SELECT A LETTER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                  const SizedBox(height: 15),

                  // Alphabet keyboard
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 7,
                    runSpacing: 9,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((
                      letter,
                    ) {
                      bool selected = guessedLetters.contains(letter);
                      bool correct = word.contains(letter);

                      return SizedBox(
                        width: 39,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: selected || gameOver
                              ? null
                              : () => guessLetter(letter),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: selected
                                ? (correct ? Colors.green : Colors.red)
                                : const Color(0xFF6750A4),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: selected
                                ? (correct ? Colors.green : Colors.red)
                                : Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // Restart button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: newGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'NEW GAME',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35245E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Hangman drawing
class HangmanPainter extends CustomPainter {
  final int mistakes;

  HangmanPainter(this.mistakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF35245E)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = size.width / 2;
    final base = size.height - 15;

    // Gallows
    canvas.drawLine(
      Offset(center - 65, base),
      Offset(center + 65, base),
      paint,
    );

    canvas.drawLine(Offset(center - 35, base), Offset(center - 35, 15), paint);

    canvas.drawLine(Offset(center - 35, 15), Offset(center + 35, 15), paint);

    canvas.drawLine(Offset(center + 35, 15), Offset(center + 35, 35), paint);

    final bodyPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Head
    if (mistakes >= 1) {
      canvas.drawCircle(Offset(center + 35, 52), 17, bodyPaint);
    }

    // Body
    if (mistakes >= 2) {
      canvas.drawLine(
        Offset(center + 35, 69),
        Offset(center + 35, 115),
        bodyPaint,
      );
    }

    // Left arm
    if (mistakes >= 3) {
      canvas.drawLine(
        Offset(center + 35, 82),
        Offset(center + 10, 100),
        bodyPaint,
      );
    }

    // Right arm
    if (mistakes >= 4) {
      canvas.drawLine(
        Offset(center + 35, 82),
        Offset(center + 60, 100),
        bodyPaint,
      );
    }

    // Left leg
    if (mistakes >= 5) {
      canvas.drawLine(
        Offset(center + 35, 115),
        Offset(center + 10, 145),
        bodyPaint,
      );
    }

    // Right leg
    if (mistakes >= 6) {
      canvas.drawLine(
        Offset(center + 35, 115),
        Offset(center + 60, 145),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) {
    return oldDelegate.mistakes != mistakes;
  }
}
