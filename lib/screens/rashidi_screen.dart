import 'package:flutter/material.dart';
import '../data/lessons.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games_screen.dart';

const _ord = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];

class RashidiScreen extends StatefulWidget {
  const RashidiScreen({super.key});
  @override
  State<RashidiScreen> createState() => _RashidiScreenState();
}

class _RashidiScreenState extends State<RashidiScreen> {
  int tab = 0, cur = 0;
  String last = lessons.first.words.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open(0));
  }

  void _open(int i) {
    setState(() {
      cur = i;
      tab = 0;
      last = lessons[i].words.first;
    });
    Progress.i.markRashidi(i);
    Progress.i.setActivity('الجزء الرشيدي: ${lessons[i].title}');
  }

  void _say(String w) {
    last = w;
    Speech.say(w);
  }

  @override
  void dispose() {
    Speech.stop();
    super.dispose();
  }

  Widget _action(IconData icon, String label, Color c, VoidCallback onTap) =>
      Column(children: [
        Material(
          color: c,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(icon, color: Colors.white, size: 26)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]);

  Widget _current() {
    final l = lessons[cur];
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('الدرس ${cur < _ord.length ? _ord[cur] : '${cur + 1}'}',
                  style: const TextStyle(color: Colors.black54)),
              Text(l.title,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
            ]),
          ),
          const Icon(Icons.auto_stories, color: AppColors.blue, size: 40),
        ]),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5D3A8), width: 2),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: l.words
              .map((w) => InkWell(
                    onTap: () => _say(w),
                    child: Center(
                        child: Text(w, style: const TextStyle(fontSize: 28))),
                  ))
              .toList(),
        ),
      ),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
            onPressed: cur > 0 ? () => _open(cur - 1) : null,
            icon: const Icon(Icons.chevron_left)),
        Text('${cur + 1} / ${lessons.length}'),
        IconButton(
            onPressed: cur < lessons.length - 1 ? () => _open(cur + 1) : null,
            icon: const Icon(Icons.chevron_right)),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _action(Icons.volume_up, 'استماع', AppColors.green2,
            () => Speech.say(l.words.join('، '))),
        _action(Icons.repeat, 'تكرار', AppColors.blue, () => Speech.say(last)),
        _action(
            Icons.edit,
            'تمرين',
            AppColors.purple,
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const GamesScreen()))),
      ]),
    ]);
  }

  Widget _list() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: AppColors.blue,
                child: Text('${i + 1}',
                    style: const TextStyle(color: Colors.white))),
            title: Text(lessons[i].title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(i),
          ),
        ),
      );

  Widget _level() => ListenableBuilder(
        listenable: Progress.i,
        builder: (_, __) => Center(
          child: Ring(
              value: Progress.i.rashidiPercent,
              color: AppColors.blue,
              label: 'تقدمك في الجزء الرشيدي'),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('الجزء الرشيدي', icon: Icons.menu_book),
        body: Column(children: [
          PillTabs(
              labels: const ['الدرس الحالي', 'الدروس', 'المستوى'],
              index: tab,
              onChanged: (i) => setState(() => tab = i)),
          Expanded(child: [_current(), _list(), _level()][tab]),
        ]),
      );
}
