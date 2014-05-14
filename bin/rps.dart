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

  // for convenience, create one of each bot
  final ChaosBot chaosBot = new ChaosBot(standard);
  final StubbornBot stubbornBot = new StubbornBot(standard);
  final SequenceBot sequenceBot = new SequenceBot(standard);
  final LearnBot learnBot = new LearnBot(standard);

  // set the two combatants
  final IBot p1 = chaosBot;
  final IBot p2 = learnBot;

  for (int i = 0; i < 10000; i++) {
    final StringBuffer sb = new StringBuffer();

    String p1Move = p1.move();
    String p2Move = p2.move();

    sb.writeln("Player 1: $p1Move");
    sb.writeln("Player 2: $p2Move");

    FightResult fightResult = fight(p1Move, p2Move, battleMatrix: standard);

    switch (fightResult.winner) {
      case 0: sb.writeln("A tie! Bleh..."); tieCount++; break;
      case 1: sb.writeln("Player 1 wins! $p1Move ${fightResult.defeats} $p2Move."); p1WinCount++; break;
      case 2: sb.writeln("Player 2 wins! $p2Move ${fightResult.defeats} $p1Move."); p2WinCount++; break;
    }

//    print(sb.toString());

    // only do this if there is a LearnBot in the fight
    learnBot.recordOpponentMove(p1Move);
  }

  print("""RESULTS
P1: $p1WinCount
P2: $p2WinCount
T: $tieCount""");
}

FightResult fight(String p1Move, String p2Move, {Map<String, Map<String, String>> battleMatrix}) {
  FightResult fightResult = new FightResult();

  // check for tie
  if (p1Move == p2Move) {
    fightResult.winner = 0;
  }
  else {
    // did player 1 win?
    if (battleMatrix[p1Move][p2Move] != null) {
      fightResult.winner = 1;
      fightResult.defeats = battleMatrix[p1Move][p2Move];
    }
    else {
      fightResult.winner = 2;
      fightResult.defeats = battleMatrix[p2Move][p1Move];
    }
  }

  return fightResult;
}

class FightResult {
  int winner;       // 0 = tie, 1 = player1, 2 = player2
  String defeats;   // null = tie, <any String> = winning verb
}

abstract class IBot {
  String id;
  String move();
}

class ChaosBot implements IBot {
  String id = "ChaosBot";
  List<String> _moves;
  Math.Random _random = new Math.Random();

  ChaosBot(Map<String, Map<String, String>> battleMatrix){
    _moves = battleMatrix.keys.toList(growable: false);
  }

  String move() => _moves[_random.nextInt(_moves.length)];
}

class StubbornBot implements IBot {
  String id = "StubbornBot";
  String _stubbornMove;

  StubbornBot(Map<String, Map<String, String>> battleMatrix) {
    // get list of possible moves
    final List<String> moves = battleMatrix.keys.toList(growable: false);

    // save a random move to use all the time
    _stubbornMove = moves[new Math.Random().nextInt(moves.length)];
  }

  String move() => _stubbornMove;
}

class SequenceBot implements IBot {
  String id = "SequenceBot";
  List<String> _moves;
  Iterator _iterator;

  SequenceBot(Map<String, Map<String, String>> battleMatrix) {
    // get list of possible moves
    _moves = battleMatrix.keys.toList(growable: false);

    // create an iterator
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
  String id = "LearnBot";
  final Map<String, Map<String, String>> _battleMatrix;
  Map<String, int> _opponentMoves;
  Math.Random _random = new Math.Random();

  LearnBot(Map<String, Map<String, String>> this._battleMatrix) {
    // initialize _opponentMoves Map with all possible moves set to 0 reps
    final List<String> moves = _battleMatrix.keys.toList(growable: false);
    _opponentMoves = new Map.fromIterable(moves, key: (String move) => move, value: (String move) => 0);
  }

  String move() {
    int min = 0;
    final List<String> movesLeastUsed = [];

    // find minimum number in _opponentMoves Map
    if (_opponentMoves.isNotEmpty) {
      min = _opponentMoves.values.reduce((int value, int element) => Math.min(value, element));
    }

    // find the moves least used by the opponent
    _opponentMoves.forEach((String move, int reps) {
      if (reps <= min) {
        movesLeastUsed.add(move);
      }
    });

//    print("movesLeastUsed: $movesLeastUsed");

    // randomly choose which of the least used moves to counter
    String moveToCounter = movesLeastUsed[_random.nextInt(movesLeastUsed.length)];

    // get a list of possible counter moves
    final List<String> counterMoves = _battleMatrix[moveToCounter].keys.toList(growable: false);

//    print("counterMoves: $counterMoves");

    // return random counter move
    return counterMoves[_random.nextInt(counterMoves.length)];
  }

  void recordOpponentMove(String move) {
    _opponentMoves.putIfAbsent(move, () => 0);
    _opponentMoves[move]++;

//    print(_opponentMoves);
  }
}
