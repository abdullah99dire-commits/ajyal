#!/usr/bin/env python3
"""
يولّد ملفات الصوت (mp3) لكل الحروف والحركات والكلمات والقصص تلقائياً
عبر Google Cloud Text-to-Speech (الواجهة الرسمية، وفيها حصة مجانية شهرية).

الاستخدام (في Codespaces من مجلد المشروع):
    export GOOGLE_TTS_KEY="مفتاح_API_الخاص_بك"
    python3 tools/generate_audio.py

- يقرأ الحروف والقصص من lib/data/*.dart فلا حاجة لتكرار النصوص.
- لا يعيد توليد ملف موجود. احذف الملف لو أردت إعادة توليده.
- ملفاتك المسجّلة يدوياً بنفس الأسماء تُستخدم بدل هذه الملفات.
- متغيرات اختيارية: TTS_VOICE (الافتراضي ar-XA-Wavenet-A) و TTS_RATE (0.85).
"""
import base64, json, os, re, sys, time, urllib.error, urllib.request

KEY = os.environ.get('GOOGLE_TTS_KEY')
VOICE = os.environ.get('TTS_VOICE', 'ar-XA-Wavenet-A')
RATE = float(os.environ.get('TTS_RATE', '0.85'))
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MARKS = [('a', '\u064E'), ('i', '\u0650'), ('u', '\u064F')]


def read(rel):
    with open(os.path.join(ROOT, rel), encoding='utf-8') as f:
        return f.read()


letters = re.findall(r"Letter\('([^']+)',\s*'([^']+)',\s*'([^']+)',\s*'([^']+)'\)", read('lib/data/letters.dart'))
stories = re.findall(r"Story\('([^']+)',\s*'([^']+)',\s*'([^']+)'\)", read('lib/data/stories.dart'), re.S)

jobs = []  # (path, text)
for i, (ch, name, word, _emoji) in enumerate(letters):
    n = '%02d' % (i + 1)
    jobs.append((f'assets/audio/letters/{n}.mp3', name))
    jobs.append((f'assets/audio/words/{n}.mp3', word))
    for key, mark in MARKS:
        jobs.append((f'assets/audio/letters/{n}_{key}.mp3', ch + mark))
for i, (title, _emoji, text) in enumerate(stories):
    jobs.append((f'assets/audio/stories/{i + 1}.mp3', f'{title}. {text}'))

todo = [(p, t) for p, t in jobs if not os.path.exists(os.path.join(ROOT, p))]
chars = sum(len(t) for _, t in todo)
print(f'الحروف: {len(letters)} | القصص: {len(stories)} | ملفات مطلوبة: {len(todo)} | حروف نصية: {chars}')
if not KEY:
    sys.exit('عيّن المتغير GOOGLE_TTS_KEY أولاً.')


def synth(text, path):
    body = json.dumps({
        'input': {'text': text},
        'voice': {'languageCode': 'ar-XA', 'name': VOICE},
        'audioConfig': {'audioEncoding': 'MP3', 'speakingRate': RATE},
    }).encode()
    req = urllib.request.Request(
        'https://texttospeech.googleapis.com/v1/text:synthesize?key=' + KEY,
        data=body, headers={'Content-Type': 'application/json'})
    try:
        with urllib.request.urlopen(req) as r:
            data = json.load(r)
    except urllib.error.HTTPError as e:
        sys.exit('خطأ من الخدمة: %s %s' % (e.code, e.read().decode('utf-8', 'ignore')[:300]))
    full = os.path.join(ROOT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, 'wb') as f:
        f.write(base64.b64decode(data['audioContent']))


for k, (path, text) in enumerate(todo, 1):
    synth(text, path)
    print(f'[{k}/{len(todo)}] {path}')
    time.sleep(0.15)
print('تم. ارفع المجلد assets/audio إلى GitHub ثم أعد تشغيل التطبيق.')
