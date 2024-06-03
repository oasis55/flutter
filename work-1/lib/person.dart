import 'package:work_1/card.dart';

enum Decision { take, skip }

abstract class Person {
  Person(this.hand);

  List<Card> hand;

  Decision decide();

  void view();

  int get sum {
    return hand.fold<int>(0, (value, element) {
      var weight = element.weight;
      weight = weight == 11 && value > 21 ? 1 : weight;
      return value + weight;
    });
  }
}
