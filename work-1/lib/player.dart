import 'dart:io';
import 'package:work_1/person.dart';

class Player extends Person {
  Player(super.cards);

  @override
  Decision decide() {
    stdout.writeln('Ход Игрока (1 - Взять, 2 - Пас):');
    final variant = stdin.readLineSync();
    return variant == '1' ? Decision.take : Decision.skip;
  }

  @override
  void view() {
    stdout.writeln('И: ${hand.map((e) => e.view)} (сумма: $sum)');
  }
}
