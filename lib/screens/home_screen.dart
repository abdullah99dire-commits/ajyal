import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';
import 'letters_screen.dart';
import 'reading_screen.dart';
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
          const Color(0xFF2E9E54), () => _open(context, const LettersScreen())),
      _Item('القراءة والاستماع', 'حروف • قصص • دروس', Icons.headphones,
          AppColors.blue, () => _open(context, const ReadingScreen())),
      _Item('القرآن الكريم', 'سور • حفظ • تلاوة', Icons.mosque, AppColors.purple,
          () => _open(context, const QuranScreen())),
      _Item('ألعاب وتدريبات', 'تعلم باللعب', Icons.sports_esports,
          AppColors.orange, () => _open(context, const GamesScreen())),
      _Item('إنجازاتي', 'نقاط • شارات • مستوى', Icons.emoji_events,
          AppColors.red, () => onTab(2)),
      _Item('حسابي', 'معلوماتي وتقدمي', Icons.person, AppColors.teal,
          () => onTab(3)),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFD7ECFF),
                  child: Text(Progress.i.avatarEmoji,
                      style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مرحباً يا ${Progress.i.name}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(children: [
                          const Icon(Icons.star,
                              color: AppColors.gold, size: 18),
                          const SizedBox(width: 4),
                          Text('${Progress.i.points} نقطة'),
                        ]),
                      ]),
                ),
              ]),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: Image.asset('assets/images/banner.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [AppColors.green, AppColors.green2])),
                            child: const Text('بالعلم نرتقي .. وبالقرآن نحيا',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          )),
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: items.map((e) => _Card(e)).toList(),
              ),
            ],
          ),
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
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [e.color, Color.alphaBlend(Colors.black26, e.color)],
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: e.onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.icon, size: 46, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(e.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    Text(e.sub,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_right,
                          color: Colors.white, size: 18),
                    ),
                  ]),
            ),
          ),
        ),
      );
}
