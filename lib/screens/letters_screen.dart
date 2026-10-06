import '../widgets.dart';
import '../services/audio_paths.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import 'tracing_screen.dart';

/// تعليم الحروف: الحرف + الصورة + النطق + الحركات
class LettersScreen extends StatefulWidget {
  final bool embedded; // true عند استخدامه كتبويب (بدون زر رجوع)
  const LettersScreen({super.key, this.embedded = false});
  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  int idx = 0;
  int get group => idx ~/ 6;

  void _select(int i) {
    setState(() => idx = i);
    Progress.i.markLearned(i);
    Progress.i.setActivity('درس حرف ${letters[i].ch}');
    Speech.sayOr(letterAudio(i), letters[i].name);
  }

  @override
  void dispose() {
    Speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = letters[idx];
    const marks = ['\u064E', '\u0650', '\u064F']; // فتحة، كسرة، ضمة
    final groupIdx = [
      for (var i = group * 6; i < min(group * 6 + 6, letters.length); i++) i
    ];

    return Scaffold(
      appBar: appBar('تعليم اللغة العربية',
          back: !widget.embedded, icon: Icons.menu_book),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // خطوات الدرس (5 مجموعات من الحروف)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (s) {
            final on = s == group;
            return GestureDetector(
              onTap: () => _select(s * 6),
              child: Column(children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: on ? AppColors.green2 : Colors.white,
                  child: Text('${s + 1}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: on ? Colors.white : Colors.black54)),
                ),
                if (s == 0)
                  const Text('الحروف',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groupIdx
              .map((i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text(letters[i].ch,
                          style: const TextStyle(fontSize: 22)),
                      selected: i == idx,
                      selectedColor: AppColors.green2,
                      labelStyle:
                          TextStyle(color: i == idx ? Colors.white : Colors.black),
                      onSelected: (_) => _select(i),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Column(children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.green2),
                onPressed: () {
                  Progress.i.markLearned(idx);
                  Speech.sayOr(letterAudio(idx), l.name);
                },
                icon: const Icon(Icons.volume_up),
              ),
            ),
            Text(l.ch,
                style: const TextStyle(
                    fontSize: 110,
                    height: 1.1,
                    color: AppColors.green,
                    fontWeight: FontWeight.bold)),
            Text(l.name, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Speech.sayOr(wordAudio(idx), l.word),
              child: Container(
                width: 130,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5D3A8)),
                ),
                child: Column(children: [
                  WordPic(index: idx, emoji: l.emoji, size: 70),
                  Text(l.word,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        const Text('استمع ثم اقرأ:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: marks
              .map((m) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            side: const BorderSide(color: Color(0xFFD5E5CF))),
                        onPressed: () => Speech.sayOr(
                            syllableAudio(idx, ['a', 'i', 'u'][marks.indexOf(m)]),
                            '${l.ch}$m'),
                        child: Text('${l.ch}$m',
                            style: const TextStyle(
                                fontSize: 32, color: AppColors.green)),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تسجيل الصوت قريباً إن شاء الله'))),
              icon: const Icon(Icons.mic),
              label: const Text('سجّل صوتك', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.green),
            onPressed: idx < letters.length - 1 ? () => _select(idx + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ]),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12)),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TracingScreen(
                        letter: l,
                        onNext: idx < letters.length - 1
                            ? () => _select(idx + 1)
                            : null,
                      ))),
          icon: const Icon(Icons.edit),
          label: const Text('اكتب الحرف'),
        ),
      ]),
    );
  }
}
