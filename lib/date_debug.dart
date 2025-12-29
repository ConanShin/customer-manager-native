void main() {
  final now = DateTime.now(); // e.g., 2025-12-29
  // Test cases
  final dates = [
    '2025-12-29', // Today
    '2025-12-28', // Yesterday (1 day ago)
    '2025-12-22', // 7 days ago
    '2025-12-21', // 8 days ago
    '2024-12-29', // 1 year ago
    '2024-12-28', // 1 year + 1 day ago
    '2025/12/29', // Invalid format?
    '2025.12.29', // Invalid format?
    'invalid-date',
    '',
    null,
  ];

  print('Now: $now');

  for (final dateStr in dates) {
    bool matches1Week = checkFilter(dateStr, now, 1);
    bool matches1Year = checkFilter(dateStr, now, 4);

    print('Date: "$dateStr" -> 1W: $matches1Week, 1Y: $matches1Year');
  }
}

bool checkFilter(String? registrationDate, DateTime now, int filterIndex) {
  if (registrationDate == null || registrationDate.isEmpty) {
    return filterIndex == 0;
  }

  // Current Logic imitation
  final dateToCheck = DateTime.tryParse(registrationDate) ?? now;
  final diff = now.difference(dateToCheck).inDays;

  // Debug print for invalid parsing
  if (DateTime.tryParse(registrationDate) != null) {
    // parsed ok
  } else {
    print('  (Failed to parse "$registrationDate", using Now)');
  }

  print('  Diff for "$registrationDate": $diff days');

  switch (filterIndex) {
    case 1: // 1 Week
      return diff <= 7;
    case 4: // 1 Year
      return diff <= 365;
    default:
      return true;
  }
}
