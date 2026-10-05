import 'package:flutter/material.dart';
import '../services/speech.dart';
import '../theme.dart';

/// الجزء الرشيدي - المحتوى هنا نموذج؛ استبدله بدروس الكتاب الفعلية
class _Lesson {
  final String title;
  final List<String> words;
  const _Lesson(this.title, this.words);
}

const _lessons = [
  _Lesson('الدرس الأول: الحروف المفردة', ['ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ']),
  _Lesson('الدرس الثاني: الفتحة والكسرة والضمة',
      ['بَ', 'بِ', 'بُ', 'تَ', 'تِ', 'تُ', 'ثَ', 'ثِ', 'ثُ']),
  _Lesson('الدرس الثالث: حروف المد واللين',
      ['قَالَ', 'قِيلَ', 'يَقُولُ', 'نُورٌ', 'بَيْتٌ', 'بَابٌ']),
];

class RashidiScreen extends StatelessWidget {
  const RashidiScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('الجزء الرشيدي', color: AppColors.blue),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _lessons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => Card(
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: AppColors.blue,
                  child: Text('${i + 1}',
                      style: const TextStyle(color: Colors.white))),
              title: Text(_lessons[i].title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => _LessonScreen(lesson: _lessons[i]))),
            ),
          ),
        ),
      );
}

class _LessonScreen extends StatelessWidget {
  final _Lesson lesson;
  const _LessonScreen({required this.lesson});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(lesson.title, color: AppColors.blue),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: lesson.words
                .map((w) => ActionChip(
                      label: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(w, style: const TextStyle(fontSize: 34)),
                      ),
                      onPressed: () => Speech.say(w),
                    ))
                .toList(),
          ),
        ),
      );
}
