import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';
import 'letters_screen.dart';
import 'rashidi_screen.dart';
import 'quran_screen.dart';
import 'games_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTab;
  const HomeScreen({super.key, required this.onTab});

  void _open(BuildContext c, Widget w) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item('تعليم اللغة العربية', 'الحروف • الكلمات • القراءة', Icons.menu_book,
          AppColors.green2, () => _open(context, const LettersScreen())),
      _Item('الجزء الرشيدي', 'دروس وتمارين تفاعلية', Icons.auto_stories,
          AppColors.blue, () => _open(context, const RashidiScreen())),
      _Item('القرآن الكريم', 'سور • حفظ • تلاوة', Icons.mosque,
          AppColors.purple, () => _open(context, const QuranScreen())),
      _Item('ألعاب وتدريبات', 'تعلم باللعب', Icons.sports_esports,
          AppColors.orange, () => _open(context, const GamesScreen())),
      _Item('إنجازاتي', 'نقاط • شارات • مستوى', Icons.emoji_events,
          AppColors.red, () => onTab(1)),
      _Item('حسابي', 'معلوماتي وتقدمي', Icons.person, AppColors.teal,
          () => onTab(2)),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => Column(children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Image.asset('assets/logo.png', width: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('مرحباً يا ${Progress.i.name} 👋',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Text('⭐ ${Progress.i.points}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: items.map((e) => _Card(e)).toList(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Item {
  final String title, sub;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _Item(this.title, this.sub, this.icon, this.color, this.onTap);
}

class _Card extends StatelessWidget {
  final _Item e;
  const _Card(this.e);

  @override
  Widget build(BuildContext context) => Material(
        color: e.color,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: e.onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(e.icon, size: 48, color: Colors.white),
              const SizedBox(height: 10),
              Text(e.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(e.sub,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ),
      );
}
