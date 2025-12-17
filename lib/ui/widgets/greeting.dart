import 'package:danmusic/services/uteis/helper.dart';

String greeting() {
  final hora = DateTime.now().hour;
  printInfoDebug('hora atual do sistema: $hora');

  if (hora >= 5 && hora < 12) {
    return "Bom dia!";
  } else if (hora >= 12 && hora < 18) {
    return "Boa tarde!";
  } else {
    return "Boa noite!";
  }
}
