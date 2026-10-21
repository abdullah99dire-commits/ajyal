import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'journey_screen.dart';
import 'achievements_screen.dart';
import 'profile_screen.dart';

/// الإطار الرئيسي مع شريط التنقل السفلي (الرئيسية، الدروس، التقدير، المزيد)
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: tab, children: [
          HomeScreen(onTab: (i) => setState(() => tab = i)),
          const JourneyScreen(embedded: true),
          const AchievementsScreen(),
          const ProfileScreen(),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.green2.withAlpha(60),
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(
                icon: Text('🏠', style: TextStyle(fontSize: 24)), label: 'الرئيسية'),
            NavigationDestination(
                icon: Text('📚', style: TextStyle(fontSize: 24)), label: 'الدروس'),
            NavigationDestination(
                icon: Text('🏆', style: TextStyle(fontSize: 24)), label: 'التقدير'),
            NavigationDestination(
                icon: Text('😊', style: TextStyle(fontSize: 24)), label: 'المزيد'),
          ],
        ),
      );
}
