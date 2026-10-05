class Surah {
  final int n; // رقم السورة في المصحف
  final String name;
  final int ayahs;
  const Surah(this.n, this.name, this.ayahs);
}

const surahs = [
  Surah(1, 'الفاتحة', 7),
  Surah(103, 'العصر', 3),
  Surah(106, 'قريش', 4),
  Surah(108, 'الكوثر', 3),
  Surah(109, 'الكافرون', 6),
  Surah(110, 'النصر', 3),
  Surah(111, 'المسد', 5),
  Surah(112, 'الإخلاص', 4),
  Surah(113, 'الفلق', 5),
  Surah(114, 'الناس', 6),
];
