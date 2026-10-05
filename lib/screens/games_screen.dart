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
  bool answered = false, correct = false;
  int solved = 0;

  static const _colors = [AppColors.blue, AppColors.purple, AppColors.green2];

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = letters[_rnd.nextInt(letters.length)];
    final others = letters.where((l) => l.ch != target.ch).toList()
      ..shuffle(_rnd);
    options = [target, others[0], others[1]]..shuffle(_rnd);
    answered = false;
  }

  void _answer(Letter l) {
    if (answered) return;
    final ok = l.ch == target.ch;
    if (ok) {
      Progress.i.addPoints(10);
      solved++;
    }
    setState(() {
      answered = true;
      correct = ok;
    });
  }

  @override
  void dispose() {
    Speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('ألعاب وتدريبات',
            color: AppColors.orange, icon: Icons.sports_esports),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  const Icon(Icons.star, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text('${Progress.i.points} نقطة',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (solved % 10) / 10,
                      minHeight: 10,
                      color: AppColors.green2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.card_giftcard, color: AppColors.red),
                ]),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Speech.say(target.word),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('اختر الحرف الصحيح',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const Text('ما هو الحرف الذي يبدأ به اسم الصورة؟',
                              style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 16),
                          Text(target.emoji, style: const TextStyle(fontSize: 100)),
                          Text(target.word,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                        ]),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: List.generate(3, (i) {
                  final l = options[i];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: _colors[i],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 20)),
                        onPressed: () => _answer(l),
                        child: Text(l.ch, style: const TextStyle(fontSize: 34)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 62,
                child: answered
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: correct ? AppColors.green2 : AppColors.orange,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(children: [
                          Text(correct ? '⭐' : '💡',
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                                correct
                                    ? 'أحسنت! إجابة صحيحة'
                                    : 'الجواب الصحيح: ${target.ch}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ),
                          if (correct)
                            const Text('+10 نقاط',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                        ]),
                      )
                    : null,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: answered ? () => setState(_next) : null,
                  child: const Text('التالي', style: TextStyle(fontSize: 16)),
                ),
              ),
            ]),
          ),
        ),
      );
}
