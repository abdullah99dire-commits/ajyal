import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/lessons.dart';
import '../data/stories.dart';
import '../data/surahs.dart';

/// بيانات الطالب وتقدمه (محفوظة على الجهاز)
class Progress extends ChangeNotifier {
  static final Progress i = Progress._();
  Progress._();

  late SharedPreferences _p;
  bool registered = false;
  String name = 'طالب';
  int age = 0;
  String grade = '';
  String avatar = ''; // boy | girl
  int points = 0;
  String lastActivity = 'لم تبدأ بعد';
  Set<int> learned = {};
  Set<int> rashidi = {};
  Set<int> quran = {};
  Set<int> storiesDone = {};

  String get avatarEmoji =>
      avatar == 'girl' ? '👧' : (avatar == 'boy' ? '👦' : '🧒');
  String get gradeLabel =>
      grade.isEmpty ? '' : (grade == 'روضة' ? 'روضة' : 'الصف $grade');

  Set<int> _readSet(String k) =>
      (_p.getStringList(k) ?? []).map(int.parse).toSet();
  void _saveSet(String k, Set<int> s) =>
      _p.setStringList(k, s.map((e) => '$e').toList());

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    registered = _p.getBool('registered') ?? false;
    name = _p.getString('name') ?? 'طالب';
    age = _p.getInt('age') ?? 0;
    grade = _p.getString('grade') ?? '';
    avatar = _p.getString('avatar') ?? '';
    points = _p.getInt('points') ?? 0;
    lastActivity = _p.getString('activity') ?? 'لم تبدأ بعد';
    learned = _readSet('learned');
    rashidi = _readSet('rashidi');
    quran = _readSet('quran');
    storiesDone = _readSet('stories');
    notifyListeners();
  }

  Future<void> register(
      {required String name,
      required int age,
      required String grade,
      required String avatar}) async {
    this.name = name.trim();
    this.age = age;
    this.grade = grade;
    this.avatar = avatar;
    registered = true;
    await _p.setString('name', this.name);
    await _p.setInt('age', age);
    await _p.setString('grade', grade);
    await _p.setString('avatar', avatar);
    await _p.setBool('registered', true);
    notifyListeners();
  }

  /// تسجيل طالب جديد على نفس الجهاز: يمسح كل البيانات المحلية
  Future<void> reset() async {
    await _p.clear();
    registered = false;
    name = 'طالب';
    age = 0;
    grade = '';
    avatar = '';
    points = 0;
    lastActivity = 'لم تبدأ بعد';
    learned = {};
    rashidi = {};
    quran = {};
    storiesDone = {};
    notifyListeners();
  }

  void addPoints(int n) {
    points += n;
    _p.setInt('points', points);
    notifyListeners();
  }

  void _first(Set<int> set, int v, String key, int pts) {
    if (set.add(v)) {
      _saveSet(key, set);
      addPoints(pts);
    }
  }

  void markLearned(int v) => _first(learned, v, 'learned', 2);
  void markRashidi(int v) => _first(rashidi, v, 'rashidi', 3);
  void markSurah(int v) => _first(quran, v, 'quran', 3);
  void markStory(int v) => _first(storiesDone, v, 'stories', 3);

  void setActivity(String a) {
    if (a == lastActivity) return;
    lastActivity = a;
    _p.setString('activity', a);
    notifyListeners();
  }

  void setName(String v) {
    name = v.trim().isEmpty ? 'طالب' : v.trim();
    _p.setString('name', name);
    notifyListeners();
  }

  double get lettersPercent => learned.length / 28;
  double get rashidiPercent => rashidi.length / lessons.length;
  double get readingPercent =>
      (rashidi.length + storiesDone.length) / (lessons.length + stories.length);
  double get quranPercent => quran.length / surahs.length;
}
