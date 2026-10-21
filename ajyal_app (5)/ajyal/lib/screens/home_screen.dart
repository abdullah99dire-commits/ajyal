import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games_screen.dart';
import 'journey_screen.dart';
import 'lesson_screen.dart';
import 'quran_screen.dart';
import 'reading_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTab;
  const HomeScreen({super.key, required this.onTab});

  void _open(BuildContext c, Widget w) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  Widget _kid(String file, String emoji, double h) => Image.asset(
        'assets/images/$file',
        height: h,
        errorBuilder: (_, __, ___) =>
            Text(emoji, style: TextStyle(fontSize: h * 0.6)),
      );

  Widget _hero(BuildContext context) => Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8FD0FF), Color(0xFFE3F4FF), Color(0xFFCFEBB8)],
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 6))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(children: [
            Positioned(
                top: 12,
                left: 14,
                child: Floaty(dy: 5, child: const Text('☁️', style: TextStyle(fontSize: 34)))),
            Positioned(
                top: 60,
                right: 16,
                child: Floaty(
                    dy: 7,
                    duration: const Duration(milliseconds: 2300),
                    child: const Text('⭐', style: TextStyle(fontSize: 26)))),
            Positioned(
                top: 96,
                left: 22,
                child: Floaty(
                    dy: 6,
                    duration: const Duration(milliseconds: 2000),
                    child: const Text('✨', style: TextStyle(fontSize: 22)))),
            Positioned(
              top: 14,
              left: 40,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
                  ],
                ),
                child: Text('أهلاً يا ${Progress.i.name}! 👋\nهيا نتعلم معاً اليوم',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, height: 1.5)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Floaty(dy: 4, child: _kid('boy_cut.png', '👦', 165)),
                  const SizedBox(width: 6),
                  Floaty(
                      dy: 4,
                      duration: const Duration(milliseconds: 2100),
                      child: _kid('girl_cut.png', '👧', 158)),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 34,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF8FCB6B),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(260, 34)),
                ),
              ),
            ),
          ]),
        ),
      );

  Widget _continueButton(BuildContext context) {
    final done = Progress.i.completed;
    final all = done >= letters.length;
    final next = all ? 0 : done;
    return Bouncy(
      onTap: () => _open(context, LessonScreen(index: next)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFD9B766), width: 2.4),
          gradient: const LinearGradient(
              colors: [Color(0xFF0F6B45), Color(0xFF0A4F34)]),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 5))
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Text(
              all
                  ? 'أنهيت الرحلة! ابدأ من جديد 🎉'
                  : (done == 0
                      ? 'ابدأ رحلة الحروف'
                      : 'تابع رحلتك: حرف ${letters[next].ch}'),
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item('تعليم الحروف', 'دروس قصيرة بالصوت والصورة', '🔤', AppColors.green2,
          () => _open(context, const JourneyScreen())),
      _Item('القراءة والاستماع', 'حروف • قصص • دروس', '🎧', AppColors.blue,
          () => _open(context, const ReadingScreen())),
      _Item('القرآن الكريم', 'سور • حفظ • تلاوة', '🕌', AppColors.purple,
          () => _open(context, const QuranScreen())),
      _Item('ألعاب وتدريبات', 'تعلم باللعب', '🎮', AppColors.orange,
          () => _open(context, const GamesScreen())),
      _Item('إنجازاتي', 'نقاط • شارات • مستوى', '🏆', AppColors.red,
          () => onTab(2)),
      _Item('حسابي', 'معلوماتي وتقدمي', '😊', AppColors.teal, () => onTab(3)),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            children: [
              Row(children: [
                Avatar(type: Progress.i.avatar, radius: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('مرحباً يا ${Progress.i.name}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ]),
                  child: Row(children: [
                    const Icon(Icons.star_rounded, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('${Progress.i.points}',
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                  ]),
                ),
              ]),
              const SizedBox(height: 14),
              _hero(context),
              const SizedBox(height: 14),
              _continueButton(context),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.98,
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
  final String title, sub, emoji;
  final Color color;
  final VoidCallback onTap;
  _Item(this.title, this.sub, this.emoji, this.color, this.onTap);
}

class _Card extends StatelessWidget {
  final _Item e;
  const _Card(this.e);

  @override
  Widget build(BuildContext context) => Bouncy(
        onTap: e.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [e.color, Color.alphaBlend(Colors.black26, e.color)],
            ),
            boxShadow: [
              BoxShadow(
                  color: e.color.withAlpha(110),
                  blurRadius: 12,
                  offset: const Offset(0, 6))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(children: [
              Positioned(
                left: -8,
                bottom: -14,
                child: Opacity(
                    opacity: 0.16,
                    child: Text(e.emoji, style: const TextStyle(fontSize: 96))),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmojiBadge(emoji: e.emoji, color: Colors.white, size: 62),
                      const SizedBox(height: 10),
                      Text(e.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text(e.sub,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ]),
              ),
            ]),
          ),
        ),
      );
}
