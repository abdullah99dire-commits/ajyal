import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';
import '../widgets.dart';
import 'achievements_screen.dart';
import 'register_screen.dart';

/// حساب الطالب
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context) async {
    final c = TextEditingController(text: Progress.i.name);
    final v = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('اسم الطالب'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.pop(context, c.text),
              child: const Text('حفظ')),
        ],
      ),
    );
    if (v != null) Progress.i.setName(v);
  }

  Future<void> _newStudent(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تسجيل طالب جديد؟'),
        content: const Text('سيتم حذف بيانات وتقدم الطالب الحالي من هذا الجهاز.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('نعم، متابعة')),
        ],
      ),
    );
    if (ok != true) return;
    await Progress.i.reset();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
        (r) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('حساب الطالب',
            back: false, icon: Icons.settings, onIcon: () => _editName(context)),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) {
            final p = Progress.i;
            final earned = badges.where((b) => b.unlocked(p)).take(3).toList();
            return ListView(padding: const EdgeInsets.all(16), children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFFD7ECFF),
                      child: Text(p.avatarEmoji,
                          style: const TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(
                                (p.age > 0 || p.gradeLabel.isNotEmpty)
                                    ? [
                                        if (p.age > 0) '${p.age} سنة',
                                        if (p.gradeLabel.isNotEmpty) p.gradeLabel
                                      ].join(' • ')
                                    : 'طالب في المدرسة الإسلامية العربية',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ]),
                    ),
                    IconButton(
                        onPressed: () => _editName(context),
                        icon: const Icon(Icons.edit)),
                  ]),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Ring(
                            value: p.lettersPercent,
                            color: AppColors.green2,
                            label: 'العربية'),
                        Ring(
                            value: p.readingPercent,
                            color: AppColors.blue,
                            label: 'القراءة والاستماع'),
                        Ring(
                            value: p.quranPercent,
                            color: AppColors.orange,
                            label: 'القرآن'),
                      ]),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: AppColors.blue),
                  title: const Text('آخر نشاط'),
                  subtitle: Text(p.lastActivity),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Text('🏅', style: TextStyle(fontSize: 28)),
                  title: const Text('نقاطي'),
                  trailing: Text('${p.points}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('شاراتي',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        if (earned.isEmpty)
                          const Text('اجمع النقاط لتحصل على شارات',
                              style: TextStyle(color: Colors.black54))
                        else
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: earned
                                  .map((b) => Column(children: [
                                        Text(b.emoji,
                                            style: const TextStyle(fontSize: 40)),
                                        Text(b.title,
                                            style: const TextStyle(fontSize: 12)),
                                      ]))
                                  .toList()),
                      ]),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _newStudent(context),
                icon: const Icon(Icons.person_add),
                label: const Text('تسجيل طالب جديد'),
              ),
            ]);
          },
        ),
      );
}
