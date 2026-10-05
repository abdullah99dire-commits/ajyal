import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import 'tracing_screen.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});
  @override State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int tab = 0;
  int letterIndex = 0;

  static const stories = [
    ('الأرنب الصغير', 'خرج أرنب صغير في الصباح، ورأى زهرة جميلة. شمّ الزهرة ثم عاد إلى أمه سعيداً.', 'أَرْنَبٌ صَغِيرٌ خَرَجَ فِي الصَّبَاحِ.'),
    ('الولد والأمانة', 'وجد سامر قلماً في الصف، فسأل عن صاحبه حتى أعاده إليه. فرح المعلم بأمانته.', 'سَامِرٌ وَلَدٌ أَمِينٌ.'),
    ('نحن نحب القراءة', 'جلست ليان مع كتابها، قرأت قصة قصيرة، ثم أخبرت أسرتها بما تعلمته.', 'نَحْنُ نُحِبُّ الْقِرَاءَةَ.'),
  ];

  @override Widget build(BuildContext context) => Scaffold(
    appBar: appBar('القراءة والاستماع', icon: Icons.headphones_rounded),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        _tab('الحروف', 0, Icons.translate_rounded), _tab('الاستماع', 1, Icons.headphones_rounded), _tab('قصص قصيرة', 2, Icons.auto_stories_rounded),
      ])),
      Expanded(child: [
        _letters(), _listening(), _stories()
      ][tab]),
    ]),
  );

  Widget _tab(String title, int i, IconData icon) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: ChoiceChip(label: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18), const SizedBox(width: 5), Text(title)]), selected: tab == i, onSelected: (_) => setState(() => tab = i), selectedColor: AppColors.green.withAlpha(35))));

  Widget _letters() {
    final l = letters[letterIndex];
    return ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.green, AppColors.green2]), borderRadius: BorderRadius.circular(28)), child: Column(children: [
        const Text('الحرف مع النطق', style: TextStyle(color: Colors.white70)),
        Text(l.ch, style: const TextStyle(fontSize: 90, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(l.name, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.green), onPressed: () => Speech.say('${l.name}. ${l.ch}. ${l.word}'), icon: const Icon(Icons.volume_up), label: const Text('استمع للحرف والكلمة')),
      ])),
      const SizedBox(height: 16),
      const Text('كل الحروف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 9, crossAxisSpacing: 9), itemCount: letters.length, itemBuilder: (_, i) => InkWell(borderRadius: BorderRadius.circular(18), onTap: () { setState(() => letterIndex = i); Progress.i.markLearned(i); Progress.i.setActivity('استماع حرف ${letters[i].ch}'); Speech.say(letters[i].name); }, child: Container(decoration: BoxDecoration(color: i == letterIndex ? AppColors.green : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: i == letterIndex ? AppColors.green : const Color(0xFFE1E9E2))), child: Center(child: Text(letters[i].ch, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: i == letterIndex ? Colors.white : AppColors.green))))),
      const SizedBox(height: 16),
      OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TracingScreen(letter: l))), icon: const Icon(Icons.edit_rounded), label: const Text('تدريب كتابة الحرف مع أسهم البداية')),
    ];
  }

  Widget _listening() => ListView(padding: const EdgeInsets.all(16), children: [
    _hero('استمع وتعلّم 🎧', 'اضغط على أي حرف لسماع اسمه ونطقه.', Icons.headphones),
    const SizedBox(height: 14),
    ...letters.map((l) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.green.withAlpha(25), child: Text(l.ch, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green))), title: Text(l.name), subtitle: Text(l.word), trailing: IconButton.filled(onPressed: () => Speech.say('${l.name}. ${l.ch}. ${l.word}'), icon: const Icon(Icons.volume_up))))),
  ]);

  Widget _stories() => ListView(padding: const EdgeInsets.all(16), children: [
    _hero('قصص قصيرة للاستماع 📖', 'قصص بسيطة مناسبة للطلاب مع زر استماع واضح.', Icons.auto_stories),
    const SizedBox(height: 14),
    ...stories.map((s) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.$1, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(s.$2, style: const TextStyle(height: 1.7)), const SizedBox(height: 8), FilledButton.icon(onPressed: () { Speech.say('${s.$1}. ${s.$3} ${s.$2}'); Progress.i.setActivity('استماع قصة: ${s.$1}'); }, icon: const Icon(Icons.play_arrow_rounded), label: const Text('استمع للقصة'))]))),
  ]);

  Widget _hero(String a, String b, IconData icon) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(24)), child: Row(children: [CircleAvatar(radius: 26, backgroundColor: AppColors.green, child: Icon(icon, color: Colors.white)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(b, style: const TextStyle(color: Colors.black54))]))]));
}
