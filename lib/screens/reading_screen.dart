import '../services/audio_paths.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/lessons.dart';
import '../data/letters.dart';
import '../data/stories.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import '../widgets.dart';

/// القراءة والاستماع: الحروف (استماع) + القصص القصيرة + الدروس
class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});
  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int tab = 0;

  @override
  void dispose() {
    Speech.stop();
    super.dispose();
  }

  Widget _letters() => Column(children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: letters.length,
            itemBuilder: (_, i) {
              final l = letters[i];
              return Material(
                color: Colors.white,
                elevation: 1.5,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Progress.i.markLearned(i);
                    Progress.i.setActivity('استماع: حرف ${l.ch}');
                    Speech.sayOr(letterAudio(i), l.name);
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l.ch,
                            style: const TextStyle(
                                fontSize: 38,
                                color: AppColors.green,
                                fontWeight: FontWeight.bold)),
                        Text(l.name,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ]),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green2,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () =>
                  Speech.say(letters.map((l) => l.name).join('، ')),
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع لكل الحروف',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ]);

  Widget _stories() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Text(stories[i].emoji, style: const TextStyle(fontSize: 36)),
            title: Text(stories[i].title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: const Text('قصة قصيرة للاستماع'),
            trailing: const CircleAvatar(
                backgroundColor: AppColors.green2,
                child: Icon(Icons.headphones, color: Colors.white)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoryScreen(index: i))),
          ),
        ),
      );

  Widget _lessons() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: AppColors.blue,
                child: Text('${i + 1}',
                    style: const TextStyle(color: Colors.white))),
            title: Text(lessons[i].title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Progress.i.markRashidi(i);
              Progress.i.setActivity('درس: ${lessons[i].title}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => _LessonPage(lesson: lessons[i])));
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('القراءة والاستماع', icon: Icons.headphones),
        body: Column(children: [
          PillTabs(
              labels: const ['الحروف', 'القصص', 'الدروس'],
              index: tab,
              onChanged: (i) => setState(() => tab = i)),
          Expanded(child: [_letters(), _stories(), _lessons()][tab]),
        ]),
      );
}

class _LessonPage extends StatelessWidget {
  final Lesson lesson;
  const _LessonPage({required this.lesson});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(lesson.title),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: lesson.words
                .map((w) => ActionChip(
                      backgroundColor: Colors.white,
                      label: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(w, style: const TextStyle(fontSize: 34)),
                      ),
                      onPressed: () => Speech.say(w),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.green2,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () => Speech.say(lesson.words.join('، ')),
            icon: const Icon(Icons.volume_up),
            label: const Text('استمع للكل'),
          ),
        ]),
      );
}

/// صفحة القصة: عنوان + نص + زر استماع / إيقاف
class StoryScreen extends StatefulWidget {
  final int index;
  const StoryScreen({super.key, required this.index});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  bool playing = false;
  StreamSubscription<void>? _sub;

  @override
  void initState() {
    super.initState();
    Speech.onDone = () {
      if (mounted) setState(() => playing = false);
    };
    _sub = Speech.onComplete.listen((_) {
      if (mounted) setState(() => playing = false);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    Speech.onDone = null;
    Speech.stop();
    super.dispose();
  }

  Future<void> _toggle() async {
    final s = stories[widget.index];
    if (playing) {
      await Speech.stop();
      if (mounted) setState(() => playing = false);
      return;
    }
    setState(() => playing = true);
    Progress.i.markStory(widget.index);
    Progress.i.setActivity('قصة: ${s.title}');
    await Speech.sayOr(storyAudio(widget.index), '${s.title}. ${s.text}');
  }

  @override
  Widget build(BuildContext context) {
    final s = stories[widget.index];
    return Scaffold(
      appBar: appBar(s.title),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(child: Text(s.emoji, style: const TextStyle(fontSize: 80))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Text(s.text, style: const TextStyle(fontSize: 22, height: 2.0)),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(
              backgroundColor: playing ? AppColors.red : AppColors.green,
              padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: _toggle,
          icon: Icon(playing ? Icons.stop : Icons.play_arrow),
          label: Text(playing ? 'إيقاف' : 'استمع للقصة',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
