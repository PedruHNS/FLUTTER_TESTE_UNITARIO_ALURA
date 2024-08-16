String getTextualTimePassed(DateTime dateTime) {
  Duration timePassed = DateTime.now().difference(dateTime);

  if (timePassed > const Duration(days: 365)) {
    return "há mais de um ano";
  }

  if (timePassed > const Duration(days: 30)) {
    return "há ${(timePassed.inDays / 30).floor()} meses";
  }

  if (timePassed > const Duration(hours: 24)) {
    return "há ${(timePassed.inHours / 24).floor()} dias";
  }

  if (timePassed > const Duration(minutes: 60)) {
    return "há ${(timePassed.inMinutes / 60).floor()} horas";
  }

  if (timePassed > const Duration(seconds: 60)) {
    return "há ${(timePassed.inSeconds / 60).floor()} minutos";
  }

  return "agora mesmo";
}
