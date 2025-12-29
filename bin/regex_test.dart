void main() {
  final inputs = [
    "7세",
    "만 7세",
    "약 7세입니다",
    "1955",
    "1955.",
    "57세(2019년기준)",
    "  7세 ",
  ];

  for (final input in inputs) {
    print('Testing: "$input"');

    final yearMatch = RegExp(r'^(\d{4})[\.\s]*$').firstMatch(input);
    final ageYearMatch = RegExp(
      r'^(\d+)세\s?\((\d{4})년\s?기준\)$',
    ).firstMatch(input);
    final partialAgeMatch = RegExp(r'(\d+)세').firstMatch(input);

    if (yearMatch != null) {
      print('  -> Matched Year: ${yearMatch.group(1)}');
    } else if (ageYearMatch != null) {
      print(
        '  -> Matched Age Criteria: Age ${ageYearMatch.group(1)}, Year ${ageYearMatch.group(2)}',
      );
    } else if (partialAgeMatch != null) {
      print('  -> Matched Partial Age: ${partialAgeMatch.group(1)}');
    } else {
      print('  -> NO MATCH');
    }
    print('---');
  }
}
