import 'package:work_1/card.dart';

class Deck {
  Deck() {
    cards.shuffle();
  }

  Card getCard() {
    return cards.removeLast();
  }

  List<Card> cards = List.generate(52, (index) {
    var suit = Suit.values[index ~/ 13];
    var rank = Rank.values[index % 13];
    return Card(suit, rank);
  });
}
