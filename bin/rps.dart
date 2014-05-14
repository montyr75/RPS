/*
 * A program that resolves the classic "Rock, Paper, Scissors" battle scenario.
 *
 * STANDARD RULES:
 * Paper covers rock.
 * Rock crushes scissors.
 * Scissors cuts paper.
 *
 * Note: As long as the number of moves available is an odd number and each move defeats
 * exactly half of the remaining moves while being defeated by the other half, any combination
 * of moves will function as a game.
 *
 * For more: http://www.reddit.com/r/dailyprogrammer_ideas/comments/1ecasd/intermediate_rock_paper_scissors_lizard_spock_ai/
 */

import "dart:math" as Math;

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> standard = const {
  "Rock": const {"Scissors": "crushes", "Lizard": "crushes"},
  "Paper": const {"Rock": "covers", "Spock": "disproves"},
  "Scissors": const {"Paper": "cuts", "Lizard": "decapitates"},
  "Lizard": const {"Paper": "eats", "Spock": "poisons"},
  "Spock": const {"Rock": "vaporizes", "Scissors": "melts"}
};

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> fantasy = const {
  "Giant": const {"Net": "tears"},
  "Net": const {"Knight": "ensnares"},
  "Knight": const {"Giant": "eviscerates"}
};

int p1WinCount, p2WinCount, tieCount;

void main() {
  p1WinCount = p2WinCount = tieCount = 0;
  
  final List<String> moves = standard.keys.toList(growable: false);

  final ChaosBot chaosBot = new ChaosBot(moves);
  final StubbornBot stubbornBot = new StubbornBot(moves);
  final SequenceBot sequenceBot = new SequenceBot(moves);

  for (int i = 0; i < 1000000; i++) {
    fight(chaosBot.move(), stubbornBot.move(), battleMatrix: standard);
//    print(fight(chaosBot.move(), sequenceBot.move(), battleMatrix: standard));
  }
  
  print("""RESULTS
P1: $p1WinCount
P2: $p2WinCount
T: $tieCount""");
}

String fight(String p1, String p2, {Map<String, Map<String, String>> battleMatrix}) {
  String defeats;
  final StringBuffer sb = new StringBuffer();

  sb.writeln("Player 1: $p1");
  sb.writeln("Player 2: $p2");

  // if Player 1's move has a "defeats" verb for Player 2's move, Player 1 wins -- otherise, reverse it
  defeats = battleMatrix[p1][p2];
  if (defeats != null) {
    sb.writeln("Player 1 wins! $p1 $defeats $p2.");
    p1WinCount++;
  }
  else {
    if (p1 == p2) {
      sb.writeln("A tie! Bleh...");
      tieCount++;
    }
    else {
      defeats = battleMatrix[p2][p1];
      sb.writeln("Player 2 wins! $p2 $defeats $p1.");
      p2WinCount++;
    }
  }

  return sb.toString();
}

abstract class IBot {
  String move();
}

class ChaosBot implements IBot {
  final List<String> _moves;

  ChaosBot(List<String> this._moves);

  String move() {
    int randomIndex = new Math.Random().nextInt(_moves.length);
    return _moves[randomIndex];
  }
}

class StubbornBot implements IBot {
  String _stubbornMove;

  StubbornBot(List<String> moves) {
    int randomIndex = new Math.Random().nextInt(moves.length);
    _stubbornMove = moves[randomIndex];
  }

  String move() => _stubbornMove;
}

class SequenceBot implements IBot {
  final List<String> _moves;
  Iterator _iterator;

  SequenceBot(List<String> this._moves) {
    _iterator = _moves.iterator;
  }

  String move() {
    if (!_iterator.moveNext()) {
      _iterator = _moves.iterator;
      _iterator.moveNext();
    }
    
    return _iterator.current;
  }
}

class LearnBot implements IBot {
  
}
