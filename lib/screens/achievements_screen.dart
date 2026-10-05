import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';

class AppBadge {
  final String emoji, title;
  final bool Function(Progress) unlocked;
  const AppBadge(this.emoji, this.title, this.unlocked);
}

final badges = <AppBadge>[
  AppBadge('🌱', 'أول خطوة', (p) => p.points >= 10),
  AppBadge('⭐', 'نجم صغير', (p) => p.points >= 50),
  AppBadge('🏅', 'المجتهد', (p) => p.points >= 100),
  AppBadge('🔤', 'حروف عربية', (p) => p.learned.length >= 10),
  AppBadge('🏆', 'بطل الحروف', (p) => p.learned.length >= 28),
  AppBadge('👑', 'نجم المدرسة', (p) => p.points >= 500),
];

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('التقدير والإنجازات', back: false),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) => GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            padding: const EdgeInsets.all(16),
            children: badges.map((b) {
              final on = b.unlocked(Progress.i);
              return Opacity(
                opacity: on ? 1 : 0.35,
                child: Card(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(b.emoji, style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 8),
                    Text(b.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (!on) const Text('🔒'),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
      );
}
