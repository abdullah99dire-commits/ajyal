import 'package:flutter/material.dart';
import '../theme.dart';
import 'shell.dart';

/// شاشة الترحيب (الشعار + زر ابدأ الآن)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFDDF1FF), Color(0xFFEFF7DD), Color(0xFFCFE8BC)],
            ),
          ),
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 12),
              Image.asset('assets/logo.png', width: 110),
              const SizedBox(height: 6),
              const Text('المنتدى العربي الألماني',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('في مدينة Landshut',
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 12),
              const Text('المدرسة الإسلامية العربية',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green)),
              const Text('تعلم .. تربية .. قيم',
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              Expanded(
                child: Image.asset('assets/images/welcome.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                        child: Text('🧒🏻👧🏻', style: TextStyle(fontSize: 90)))),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(235),
                    borderRadius: BorderRadius.circular(22)),
                child: Column(children: [
                  const Text('مرحباً بك في تطبيق مدرستك الإسلامية',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const Text('هيا نبدأ رحلة التعلم معاً'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Shell())),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ابدأ الآن',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right),
                          ]),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      );
}
