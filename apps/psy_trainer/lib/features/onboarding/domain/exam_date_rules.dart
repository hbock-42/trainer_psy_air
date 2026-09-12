/// Calendar rules for the exam date asked during onboarding.
///
/// An exam date is a *day*, never a time: every function here works on
/// `DateTime.utc(year, month, day)` values so the stored value does not
/// drift with the device time zone. [calendarDay] normalises any instant.
library;

/// Why an exam date is refused by [validateExamDate].
enum ExamDateError {
  /// The day is before today.
  inThePast,
}

/// Strips the time component: the same calendar day as [instant], at UTC
/// midnight. Local instants are read in local time (a candidate typing
/// "4 September" means that day where they live).
DateTime calendarDay(DateTime instant) =>
    DateTime.utc(instant.year, instant.month, instant.day);

/// The first Saturday of September of [year], the official PSY0 slot ("le
/// premier weekend de septembre", `docs/content/psy0-spec.md` §1).
DateTime firstSaturdayOfSeptember(int year) {
  final first = DateTime.utc(year, DateTime.september);
  final offset = (DateTime.saturday - first.weekday + 7) % 7;
  return first.add(Duration(days: offset));
}

/// The next PSY0 session on or after [now]: the first Saturday of September
/// of the current year if it is still ahead, otherwise next year's.
DateTime nextPsy0Date(DateTime now) {
  final today = calendarDay(now);
  final thisYear = firstSaturdayOfSeptember(today.year);
  return thisYear.isBefore(today)
      ? firstSaturdayOfSeptember(today.year + 1)
      : thisYear;
}

/// Checks [date] against [now]; null when the date is acceptable. Today is
/// accepted (the session may be in progress).
ExamDateError? validateExamDate(DateTime date, {required DateTime now}) {
  if (calendarDay(date).isBefore(calendarDay(now))) {
    return ExamDateError.inThePast;
  }
  return null;
}

/// Number of days in [month] of [year].
int daysInMonth(int year, int month) => DateTime.utc(year, month + 1, 0).day;

/// Builds a calendar day, clamping [day] to the length of the month so
/// stepping from 31 January to February lands on the 28th/29th.
DateTime clampedDay(int year, int month, int day) =>
    DateTime.utc(year, month, day.clamp(1, daysInMonth(year, month)));
