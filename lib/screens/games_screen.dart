import 'dart:math';
import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';

/// لعبة: اختر الحرف الذي يبدأ به اسم الصورة
class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});
  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final _rnd = Random();
  late Letter target;
  late List<Letter> options;
  bool answered = false;
  String feedback = '';

  static const _colors = [AppColors.blue, AppColors.purple, AppColors.green2];

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = letters[_rnd.nextInt(letters.length)];
    final others = letters.where((l) => l.ch != target.ch).toList()..shuffle(_rnd);
    options = [target, others[0], others[1]]..shuffle(_rnd);
    answered = false;
    feedback = '';
  }

  void _answer(Letter l) {
    if (answered) return;
    final ok = l.ch == target.ch;
    if (ok) Progress.i.addPoints(10);
    setState(() {
      answered = true;
      feedback = ok ? 'أحسنت! ✅ +10 نقاط' : 'الجواب الصحيح: ${target.ch}';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('ألعاب وتدريبات', color: AppColors.orange),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Chip(label: Text('⭐ ${Progress.i.points} نقطة')),
              ),
              const SizedBox(height: 8),
              const Text('اختر الحرف الذي يبدأ به اسم الصورة؟',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: InkWell(
                    onTap: () => Speech.say(target.word),
                    child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(target.emoji, style: const TextStyle(fontSize: 110)),
                        Text(target.word,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(3, (i) {
                  final l = options[i];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: _colors[i],
                            padding: const EdgeInsets.symmetric(vertical: 20)),
                        onPressed: () => _answer(l),
                        child: Text(l.ch, style: const TextStyle(fontSize: 34)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 28,
                child: Text(feedback,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              FilledButton(
                onPressed: answered ? () => setState(_next) : null,
                child: const Text('التالي'),
              ),
            ]),
          ),
        ),
      );
}
