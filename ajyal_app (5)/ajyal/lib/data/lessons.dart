class Lesson {
  final String title;
  final List<String> words;
  const Lesson(this.title, this.words);
}

// محتوى نموذجي؛ استبدله بدروس الكتاب الفعلية
const lessons = [
  Lesson('الحروف المفردة', ['ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ']),
  Lesson('الفتحة والكسرة والضمة',
      ['بَ', 'بِ', 'بُ', 'تَ', 'تِ', 'تُ', 'ثَ', 'ثِ', 'ثُ']),
  Lesson('حروف المد واللين',
      ['قَالَ', 'قِيلَ', 'يَقُولُ', 'نُورٌ', 'بَيْتٌ', 'بَابٌ']),
];
