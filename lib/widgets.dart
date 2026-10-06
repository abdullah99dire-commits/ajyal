import 'package:flutter/material.dart';
import 'theme.dart';

/// تبويبات على شكل أقراص (مثل التصميم)
class PillTabs extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final Color color;
  const PillTabs(
      {super.key,
      required this.labels,
      required this.index,
      required this.onChanged,
      this.color = AppColors.green2});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: List.generate(
            labels.length,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: i == index ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(labels[i],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: i == index ? Colors.white : Colors.black54)),
                ),
              ),
            ),
          ),
        ),
      );
}

/// حلقة تقدم دائرية مع نسبة مئوية
class Ring extends StatelessWidget {
  final double value;
  final Color color;
  final String label;
  const Ring(
      {super.key, required this.value, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
          width: 68,
          height: 68,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 7,
                color: color,
                backgroundColor: color.withAlpha(40),
              ),
            ),
            Text('${(value * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]);
}

/// صورة الطالب: boy.png / girl.png إن وُجدت، وإلا رمز تعبيري
class Avatar extends StatelessWidget {
  final String type; // boy | girl | ''
  final double radius;
  const Avatar({super.key, required this.type, this.radius = 26});

  @override
  Widget build(BuildContext context) {
    final emoji = type == 'girl' ? '👧' : (type == 'boy' ? '👦' : '🧒');
    final file = type == 'girl' ? 'girl' : 'boy';
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFD7ECFF),
      child: ClipOval(
        child: Image.asset('assets/images/$file.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Text(emoji, style: TextStyle(fontSize: radius * 1.05))),
      ),
    );
  }
}

/// صورة الكلمة: assets/images/words/NN.png إن وُجدت، وإلا رمز تعبيري
class WordPic extends StatelessWidget {
  final int index;
  final String emoji;
  final double size;
  const WordPic(
      {super.key, required this.index, required this.emoji, this.size = 60});

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/words/${(index + 1).toString().padLeft(2, '0')}.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Text(emoji, style: TextStyle(fontSize: size * 0.9)),
      );
}
