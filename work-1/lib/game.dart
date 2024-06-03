import 'package:work_1/dealer.dart';
import 'package:work_1/deck.dart';
import 'package:work_1/person.dart';
import 'package:work_1/player.dart';
import 'dart:io';

class Game {
  Game() {
    deck = Deck();
    stdout.writeln('Раздача:');
    player = Player([deck.getCard(), deck.getCard()]);
    dealer = Dealer([deck.getCard(), deck.getCard()]);
    activePlayer = player;
    step();
  }

  late final Deck deck;
  late final Player player;
  late final Dealer dealer;
  late Person activePlayer;

  void step() {
    view();
    if (player.sum > 21 || dealer.sum == 21) {
      dealerWin();
      return;
    }
    if (dealer.sum > 21) {
      playerWin();
      return;
    }
    if (activePlayer.decide() == Decision.skip) {
      if (activePlayer is Player) {
        activePlayer = dealer;
        dealer.showAllCards = true;
        step();
        return;
      }
      if (activePlayer is Dealer) {
        if (dealer.sum > player.sum) {
          dealerWin();
          return;
        }
        if (dealer.sum < player.sum) {
          playerWin();
          return;
        }
        if (dealer.sum == player.sum) {
          draw();
          return;
        }
      }
    } else {
      activePlayer.hand.add(deck.getCard());
      step();
    }
  }

  void view() {
    dealer.view();
    player.view();
    stdout.writeln('---------');
  }

  void playerWin() {
    stdout.writeln('Игрок победил!');
  }

  void dealerWin() {
    stdout.writeln('Дилер победил!');
  }

  void draw() {
    stdout.writeln('Ничья!');
  }
}
