import 'dart:io';
import 'package:work_1/person.dart';

class Dealer extends Person {
  Dealer(super.cards);

  @override
  Decision decide() {
    stdout.writeln('Ход Дилера');
    return sum < 17 ? Decision.take : Decision.skip;
  }

  bool showAllCards = false;

  @override
  void view() {
    var isHideCard = false;

    var view = hand.asMap().entries.map((e) {
      if (e.key == 1 &&
          hand.length == 2 &&
          hand[0].weight < 10 &&
          !showAllCards) {
        isHideCard = true;
        return '-';
      } else {
        return e.value.view;
      }
    }).toString();

    stdout.writeln('Д: $view ${isHideCard ? '' : '(сумма: $sum)'}');
  }
}
