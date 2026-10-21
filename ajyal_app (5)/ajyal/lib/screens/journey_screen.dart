import 'dart:math';
import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../theme.dart';
import '../widgets.dart';
import 'lesson_screen.dart';

const _pal = [
  AppColors.green2,
  AppColors.blue,
  AppColors.purple,
  AppColors.orange,
  AppColors.red,
  AppColors.teal,
];

/// رحلة الحروف: مراحل تُفتح تدريجياً، كل مرحلة درس قصير بالصوت والصورة
class JourneyScreen extends StatelessWidget {
  final bool embedded;
  const JourneyScreen({super.key, this.embedded = false});

  Widget _node(BuildContext context, int i, int done) {
    final l = letters[i];
    final locked = i > done;
    final current = i == done;
    final color = locked ? Colors.grey.shade400 : _pal[i % _pal.length];
    final stars = Progress.i.stars[i] ?? 0;

    Widget circle = Bouncy(
      onTap: () {
        if (locked) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('أكمل الدرس السابق أولاً 🔒')));
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => LessonScreen(index: i)));
      },
      child: Container(
        width: 90,
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [color, Color.alphaBlend(Colors.black26, color)]),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
                color: color.withAlpha(110),
                blurRadius: 14,
                offset: const Offset(0, 6))
          ],
        ),
        child: locked
            ? const Icon(Icons.lock, color: Colors.white70, size: 34)
            : Text(l.ch,
                style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w900)),
      ),
    );
    if (current) circle = Floaty(dy: 6, child: circle);

    return Align(
      alignment: Alignment(sin(i * 1.1) * 0.65, 0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (current)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.gold, borderRadius: BorderRadius.circular(14)),
            child: const Text('ابدأ هنا',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        circle,
        const SizedBox(height: 4),
        locked ? const SizedBox(height: 20) : StarsRow(stars: stars, size: 20),
        const SizedBox(height: 18),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('رحلة الحروف', back: !embedded, icon: Icons.map),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) {
            final done = Progress.i.completed;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              itemCount: letters.length,
              itemBuilder: (_, i) => _node(context, i, done),
            );
          },
        ),
      );
}
