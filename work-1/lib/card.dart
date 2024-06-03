enum Suit { clubs, diamonds, hearts, pikes }

enum Rank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace
}

class Card {
  Card(this.suit, this.rank);

  final Suit suit;
  final Rank rank;

  int get weight {
    switch (rank) {
      case Rank.two:
        return 2;
      case Rank.three:
        return 3;
      case Rank.four:
        return 4;
      case Rank.five:
        return 5;
      case Rank.six:
        return 6;
      case Rank.seven:
        return 7;
      case Rank.eight:
        return 8;
      case Rank.nine:
        return 9;
      case Rank.ten:
      case Rank.jack:
      case Rank.queen:
      case Rank.king:
        return 10;
      case Rank.ace:
        return 11;
    }
  }

  String get view {
    var str = '';
    switch (suit) {
      case Suit.clubs:
        str = '♣';
        break;
      case Suit.diamonds:
        str = '♦';
        break;
      case Suit.hearts:
        str = '♥';
        break;
      case Suit.pikes:
        str = '♠';
        break;
    }
    switch (rank) {
      case Rank.two:
        return '2$str';
      case Rank.three:
        return '3$str';
      case Rank.four:
        return '4$str';
      case Rank.five:
        return '5$str';
      case Rank.six:
        return '6$str';
      case Rank.seven:
        return '7$str';
      case Rank.eight:
        return '8$str';
      case Rank.nine:
        return '9$str';
      case Rank.ten:
        return '10$str';
      case Rank.jack:
        return 'J$str';
      case Rank.queen:
        return 'Q$str';
      case Rank.king:
        return 'K$str';
      case Rank.ace:
        return 'A$str';
    }
  }
}
