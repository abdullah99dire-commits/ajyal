import 'dart:math';
import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/audio_paths.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import '../widgets.dart';
import 'tracing_screen.dart';

/// درس حرف: تعرّف ← استمع واقرأ ← اكتب ← اختبر نفسك ← النجوم
class LessonScreen extends StatefulWidget {
  final int index;
  const LessonScreen({super.key, required this.index});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  static const _marks = ['\u064E', '\u0650', '\u064F'];
  static const _keys = ['a', 'i', 'u'];
  static const _names = ['فتحة', 'كسرة', 'ضمة'];
  static const _pal = [AppColors.blue, AppColors.purple, AppColors.orange];

  final _rnd = Random();
  int step = 0; // 0..3 ثم 4 = النتيجة
  late List<int> targets;
  late List<int> options;
  int round = 0, correct = 0, stars = 0;
  int? picked;

  Letter get l => letters[widget.index];

  @override
  void initState() {
    super.initState();
    int rev() => widget.index == 0 ? 0 : _rnd.nextInt(widget.index + 1);
    targets = [widget.index, rev(), rev()];
    _options();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Progress.i.markLearned(widget.index);
      Progress.i.setActivity('درس حرف ${l.ch}');
      Speech.sayOr(letterAudio(widget.index), l.name);
    });
  }

  @override
  void dispose() {
    Speech.stop();
    super.dispose();
  }

  void _options() {
    final t = targets[round];
    final others = List<int>.generate(letters.length, (i) => i)
      ..remove(t)
      ..shuffle(_rnd);
    options = [t, others[0], others[1]]..shuffle(_rnd);
    picked = null;
  }

  void _answer(int i) {
    if (picked != null) return;
    setState(() {
      picked = i;
      if (i == targets[round]) correct++;
    });
  }

  void _next() {
    if (round < 2) {
      setState(() {
        round++;
        _options();
      });
      if (round == 1) {
        Speech.sayOr(letterAudio(targets[1]), letters[targets[1]].name);
      }
    } else {
      stars = correct >= 3 ? 3 : (correct == 2 ? 2 : 1);
      Progress.i.setStars(widget.index, stars);
      setState(() => step = 4);
    }
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 5))
        ],
      );

  Widget _bigBtn(IconData icon, String label, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient:
              LinearGradient(colors: [c, Color.alphaBlend(Colors.black26, c)]),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        ]),
      );

  Widget _nextBtn(String label, VoidCallback onTap) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22))),
          onPressed: onTap,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ]),
        ),
      );

  Widget _stepBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: List.generate(
              4,
              (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 8,
                      decoration: BoxDecoration(
                          color: i <= step ? AppColors.green2 : Colors.black12,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )),
        ),
      );

  // 1) تعرّف
  Widget _meet() => ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _card(),
          child: Column(children: [
            Floaty(
              dy: 5,
              child: Text(l.ch,
                  style: const TextStyle(
                      fontSize: 130,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: AppColors.green)),
            ),
            Text(l.name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Bouncy(
                onTap: () => Speech.sayOr(letterAudio(widget.index), l.name),
                child: _bigBtn(Icons.volume_up, 'استمع للحرف', AppColors.green2)),
            const Divider(height: 32),
            Bouncy(
              onTap: () => Speech.sayOr(wordAudio(widget.index), l.word),
              child: Column(children: [
                WordPic(index: widget.index, emoji: l.emoji, size: 110),
                Text(l.word,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
                const Text('اضغط على الصورة لتسمع الكلمة',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        _nextBtn('التالي', () => setState(() => step = 1)),
      ]);

  // 2) استمع واقرأ
  Widget _read() => ListView(padding: const EdgeInsets.all(16), children: [
        const Text('اضغط على كل بطاقة واستمع ثم اقرأ',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
        const SizedBox(height: 14),
        Row(
          children: List.generate(
              3,
              (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Bouncy(
                        onTap: () => Speech.sayOr(
                            syllableAudio(widget.index, _keys[i]),
                            '${l.ch}${_marks[i]}'),
                        child: Column(children: [
                          Container(
                            height: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(colors: [
                                _pal[i],
                                Color.alphaBlend(Colors.black26, _pal[i])
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: _pal[i].withAlpha(100),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5))
                              ],
                            ),
                            child: Text('${l.ch}${_marks[i]}',
                                style: const TextStyle(
                                    fontSize: 64,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 6),
                          Text(_names[i],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  )),
        ),
        const SizedBox(height: 24),
        _nextBtn('التالي', () => setState(() => step = 2)),
      ]);

  // 3) اكتب
  Widget _write() => ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: _card(),
          child: Column(children: [
            const Text('✏️', style: TextStyle(fontSize: 54)),
            const Text('هيا نكتب الحرف!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            const Text('اتبع الأسهم وابدأ من الرقم 1',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 14),
            Text(l.ch,
                style: TextStyle(
                    fontSize: 110, color: Colors.grey.shade300, height: 1.1)),
            const SizedBox(height: 8),
            Bouncy(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TracingScreen(
                          letter: l,
                          onNext: () {
                            if (mounted) setState(() => step = 3);
                          }))),
              child: _bigBtn(Icons.edit, 'ابدأ الكتابة', AppColors.orange),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        TextButton(
            onPressed: () => setState(() => step = 3),
            child: const Text('تخطَّ الكتابة')),
      ]);

  // 4) الاختبار
  Widget _quiz() {
    final t = letters[targets[round]];
    final sound = round == 1;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('سؤال ${round + 1} من 3',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: _card(),
        child: Column(children: [
          Text(sound ? 'اسمع ثم اختر الحرف' : 'بأي حرف تبدأ هذه الكلمة؟',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          sound
              ? Bouncy(
                  onTap: () => Speech.sayOr(letterAudio(targets[round]), t.name),
                  child: _bigBtn(Icons.volume_up, 'اضغط للاستماع', AppColors.blue))
              : Column(children: [
                  WordPic(index: targets[round], emoji: t.emoji, size: 110),
                  Text(t.word,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
        ]),
      ),
      const SizedBox(height: 14),
      Row(
        children: List.generate(3, (k) {
          final o = options[k];
          Color c = const [AppColors.blue, AppColors.purple, AppColors.green2][k];
          if (picked != null) {
            if (o == targets[round]) {
              c = AppColors.green2;
            } else if (o == picked) {
              c = AppColors.red;
            } else {
              c = Colors.grey;
            }
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Bouncy(
                onTap: () => _answer(o),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: c.withAlpha(100),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Text(letters[o].ch,
                      style: const TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          );
        }),
      ),
      const SizedBox(height: 14),
      if (picked != null) ...[
        Text(
            picked == targets[round] ? 'أحسنت! ⭐' : 'الجواب الصحيح: ${t.ch}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _nextBtn(round < 2 ? 'التالي' : 'شاهد نتيجتك', _next),
      ],
    ]);
  }

  // النتيجة
  Widget _result() => Stack(children: [
        ListView(padding: const EdgeInsets.all(16), children: [
          const SizedBox(height: 30),
          Center(
            child: Floaty(
              child: Text(stars == 3 ? '🏆' : (stars == 2 ? '🌟' : '👍'),
                  style: const TextStyle(fontSize: 90)),
            ),
          ),
          Text(
              stars == 3
                  ? 'ممتاز!'
                  : (stars == 2
                      ? 'أحسنت!'
                      : 'جيد! حاول مرة أخرى لتأخذ نجوماً أكثر'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Center(child: StarsRow(stars: stars, size: 52)),
          const SizedBox(height: 8),
          Text('أجبت صح $correct من 3', textAlign: TextAlign.center),
          const SizedBox(height: 26),
          if (widget.index < letters.length - 1)
            _nextBtn(
                'الدرس التالي: حرف ${letters[widget.index + 1].ch}',
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LessonScreen(index: widget.index + 1)))),
          const SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('العودة إلى الرحلة')),
        ]),
        const Positioned.fill(child: StarBurst()),
      ]);

  Widget _page() {
    switch (step) {
      case 0:
        return _meet();
      case 1:
        return _read();
      case 2:
        return _write();
      case 3:
        return _quiz();
      default:
        return _result();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('حرف ${l.ch} • ${l.name}'),
        body: Column(children: [
          _stepBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(key: ValueKey(step), child: _page()),
            ),
          ),
        ]),
      );
}
