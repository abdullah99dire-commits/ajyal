import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import 'tracing_screen.dart';

/// تعليم الحروف: الحرف + الصورة + النطق + الحركات
class LettersScreen extends StatefulWidget {
  const LettersScreen({super.key});
  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  int idx = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Progress.i.markLearned(0));
  }

  void _select(int i) {
    setState(() => idx = i);
    Progress.i.markLearned(i);
    Speech.say(letters[i].name);
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
    return Scaffold(
      appBar: appBar('تعليم اللغة العربية'),
      body: Column(children: [
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: letters.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(letters[i].ch, style: const TextStyle(fontSize: 22)),
                selected: i == idx,
                selectedColor: AppColors.green2,
                labelStyle:
                    TextStyle(color: i == idx ? Colors.white : Colors.black),
                onSelected: (_) => _select(i),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text(l.ch,
                        style: const TextStyle(
                            fontSize: 120,
                            height: 1.2,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold)),
                    Text(l.name, style: const TextStyle(fontSize: 22)),
                    IconButton.filled(
                      iconSize: 32,
                      onPressed: () => Speech.say(l.name),
                      icon: const Icon(Icons.volume_up),
                    ),
                    const Divider(height: 32),
                    InkWell(
                      onTap: () => Speech.say(l.word),
                      child: Column(children: [
                        Text(l.emoji, style: const TextStyle(fontSize: 64)),
                        Text(l.word,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              const Text('استمع ثم اقرأ:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: marks
                    .map((m) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: OutlinedButton(
                            onPressed: () => Speech.say('${l.ch}$m'),
                            child: Text('${l.ch}$m',
                                style: const TextStyle(fontSize: 32)),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TracingScreen(letter: l))),
                    icon: const Icon(Icons.edit),
                    label: const Text('اكتب الحرف'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: idx < letters.length - 1 ? () => _select(idx + 1) : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton.filledTonal(
                  onPressed: idx > 0 ? () => _select(idx - 1) : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
