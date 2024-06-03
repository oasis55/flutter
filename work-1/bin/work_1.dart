import 'dart:io';

import 'package:work_1/game.dart';

void main(List<String> arguments) {
  while (true) {
    Game();
    stdout.writeln('Играть еще? (y/n)');
    final variant = stdin.readLineSync();
    if (variant != 'y') {
      break;
    }
  }
}
