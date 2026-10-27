/// Format tanggal Bahasa Indonesia tanpa package `intl`.
library;

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

/// `10 Nov`
String formatShortDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]}';

/// `10 Nov 2026`
String formatDate(DateTime date) => '${formatShortDate(date)} ${date.year}';

/// `Sel`
String formatWeekday(DateTime date) => _weekdays[date.weekday - 1];

/// Jumlah hari cuti, inklusif tanggal mulai dan selesai.
int leaveDurationInDays(DateTime start, DateTime end) =>
    end.difference(start).inDays + 1;

/// `Sel · Nov 2026`
String formatWeekdayMonth(DateTime date) =>
    '${formatWeekday(date)} · ${_months[date.month - 1]} ${date.year}';
