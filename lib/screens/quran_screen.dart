import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/surahs.dart';
import '../services/speech.dart';
import '../services/progress.dart';
import '../theme.dart';
import '../widgets.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  int tab = 0;

  void _open(Surah s) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => SurahScreen(surah: s)));

  Widget _list() => ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سورة ${surahs.first.name}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('${surahs.first.ayahs} آيات',
                          style: const TextStyle(color: Colors.black54)),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFE3F4E8),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.auto_awesome,
                    color: AppColors.green2, size: 30),
              ),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green2,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => _open(surahs.first),
                icon: const Icon(Icons.play_arrow),
                label: const Text('ابدأ التلاوة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        ...surahs.skip(1).map((s) => Card(
              child: ListTile(
                title: Text('سورة ${s.name}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('${s.ayahs} آيات'),
                trailing: const CircleAvatar(
                    backgroundColor: AppColors.green2,
                    child: Icon(Icons.play_arrow, color: Colors.white)),
                onTap: () => _open(s),
              ),
            )),
        const SizedBox(height: 8),
        Image.asset('assets/images/quran.png',
            errorBuilder: (_, __, ___) => const SizedBox.shrink()),
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('القرآن الكريم', icon: Icons.mosque),
        body: Column(children: [
          PillTabs(
              labels: const ['السور القصيرة', 'الحفظ', 'متابعتي'],
              index: tab,
              onChanged: (i) => setState(() => tab = i)),
          Expanded(
              child: tab == 0
                  ? _list()
                  : const Center(child: Text('قريباً إن شاء الله'))),
        ]),
      );
}

class SurahScreen extends StatefulWidget {
  final Surah surah;
  const SurahScreen({super.key, required this.surah});
  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  late Future<List<Map<String, dynamic>>> _future;
  StreamSubscription<void>? _sub;
  int? current;
  bool autoPlay = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Progress.i.markSurah(widget.surah.n);
      Progress.i.setActivity('سورة ${widget.surah.name}');
    });
    _sub = Speech.onComplete.listen((_) {
      if (!mounted) return;
      if (autoPlay && current != null && current! < widget.surah.ayahs) {
        _play(current! + 1, all: true);
      } else {
        setState(() {
          current = null;
          autoPlay = false;
        });
      }
    });
  }

  // نص القرآن من واجهة Al-Quran Cloud (طبعة المصحف العثماني)
  Future<List<Map<String, dynamic>>> _load() async {
    final r = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/${widget.surah.n}/quran-uthmani'));
    final j = jsonDecode(utf8.decode(r.bodyBytes));
    return List<Map<String, dynamic>>.from(j['data']['ayahs']);
  }

  // بعض الطبعات تضع البسملة في أول آية؛ نعرضها في رأس الصفحة بدلاً من ذلك
  String _clean(int n, String text) {
    if (n == 1 || widget.surah.n == 1 || widget.surah.n == 9) return text;
    if (text.startsWith('بِسْمِ')) {
      return text.split(' ').skip(4).join(' ');
    }
    return text;
  }

  Future<void> _play(int a, {bool all = false}) async {
    setState(() {
      current = a;
      autoPlay = all;
    });
    await Speech.playAyah(widget.surah.n, a);
  }

  @override
  void dispose() {
    _sub?.cancel();
    Speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surah;
    return Scaffold(
      appBar: appBar('سورة ${s.name}'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('تعذّر تحميل السورة. تأكد من الاتصال بالإنترنت.'),
                const SizedBox(height: 12),
                FilledButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('إعادة المحاولة')),
              ]),
            );
          }
          final ayahs = snap.data!;
          return ListView(padding: const EdgeInsets.all(16), children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.green2),
              onPressed: () => _play(1, all: true),
              icon: const Icon(Icons.play_arrow),
              label: const Text('ابدأ التلاوة'),
            ),
            if (s.n != 1 && s.n != 9)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
            ...ayahs.map((a) {
              final n = a['numberInSurah'] as int;
              final playing = current == n;
              return Card(
                color: playing ? const Color(0xFFE3F4E8) : Colors.white,
                child: ListTile(
                  title: Text(_clean(n, a['text'] as String),
                      style: const TextStyle(fontSize: 26, height: 1.9)),
                  leading: IconButton(
                    icon: Icon(playing ? Icons.stop_circle : Icons.play_circle,
                        color: AppColors.green2, size: 34),
                    onPressed: () => playing
                        ? Speech.stop().then((_) => setState(() => current = null))
                        : _play(n),
                  ),
                  trailing: Text('$n'),
                ),
              );
            }),
          ]);
        },
      ),
    );
  }
}
