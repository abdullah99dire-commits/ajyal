import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('حساب الطالب', color: AppColors.teal),
        body: ListenableBuilder(
          listenable: Progress.i,
          builder: (context, _) {
            final p = Progress.i;
            return ListView(padding: const EdgeInsets.all(16), children: [
              Center(
                child: CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.teal,
                    child: Text(p.name.characters.first,
                        style: const TextStyle(fontSize: 40, color: Colors.white))),
              ),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(p.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => _editName(context),
                    icon: const Icon(Icons.edit)),
              ]),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Text('⭐', style: TextStyle(fontSize: 28)),
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
                        Text('الحروف المتعلَّمة: ${p.learned.length} / 28',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                            value: p.lettersPercent,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.green2),
                      ]),
                ),
              ),
            ]);
          },
        ),
      );
}
