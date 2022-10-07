///Duration in seconds
String convertTime(int duration) {
  int min = (duration / 60).floor();
  int sec = duration % 60;

  return '$min min $sec sec';
}
