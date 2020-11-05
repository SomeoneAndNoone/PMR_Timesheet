class SingleSummaryContent {
  const SingleSummaryContent(
    this.weekEnding,
    this.siteName,
    this.workedHours,
    this.position,
  );

  final String weekEnding;
  final String siteName;
  final String workedHours;
  final String position;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return weekEnding;
      case 1:
        return siteName;
      case 2:
        return workedHours;
      case 3:
        return position;
    }
    return '';
  }
}
