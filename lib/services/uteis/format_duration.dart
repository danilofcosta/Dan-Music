String formatDuration(Duration d) {
  String doisDigitos(int n) => n.toString().padLeft(2, '0');

  final horas = doisDigitos(d.inHours);
  final minutos = doisDigitos(d.inMinutes.remainder(60));
  final segundos = doisDigitos(d.inSeconds.remainder(60));

  return horas == "00"
      ? "$minutos:$segundos"
      : "$horas:$minutos:$segundos";
}
