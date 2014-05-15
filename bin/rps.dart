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

library rps;

import "dart:math" as Math;

part "bots.dart";

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

const int ITERATIONS = 10000;

int p1WinCount, p2WinCount, tieCount;

void main() {
  final Map<String, Map<String, String>> battleMatrix = fantasy;
  p1WinCount = p2WinCount = tieCount = 0;

  // for convenience, create one of each bot
  final ChaosBot chaosBot = new ChaosBot(battleMatrix);
  final ChaosBot chaosBot2 = new ChaosBot(battleMatrix);
  final StubbornBot stubbornBot = new StubbornBot(battleMatrix);
  final StubbornBot stubbornBot2 = new StubbornBot(battleMatrix);
  final SequenceBot sequenceBot = new SequenceBot(battleMatrix);
  final LearnBot learnBot = new LearnBot(battleMatrix);
  final LearnBot learnBot2 = new LearnBot(battleMatrix);

  // set the two combatants
  final IBot p1 = learnBot;
  final IBot p2 = stubbornBot;

  for (int i = 0; i < ITERATIONS; i++) {
    final StringBuffer sb = new StringBuffer();

    String p1Move = p1.move();
    String p2Move = p2.move();

    sb.writeln("${p1.id}: $p1Move");
    sb.writeln("${p2.id}: $p2Move");

    final FightResult fightResult = fight(p1Move, p2Move, battleMatrix: battleMatrix);

    switch (fightResult.winner) {
      case 0: sb.writeln("A tie! Bleh..."); tieCount++; break;
      case 1: sb.writeln("${p1.id} wins! $p1Move ${fightResult.defeats} $p2Move."); p1WinCount++; break;
      case 2: sb.writeln("${p2.id} wins! $p2Move ${fightResult.defeats} $p1Move."); p2WinCount++; break;
    }

//    print(sb.toString());

    // LearnBots need to record their opponent's moves
    if (p1 is LearnBot) {
      p1.recordOpponentMove(p2Move);
    }
    if (p2 is LearnBot) {
      p2.recordOpponentMove(p1Move);
    }
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
    return fightResult
      ..winner = 0;
  }

  // did player 1 win?
  if (battleMatrix[p1Move][p2Move] != null) {
    return fightResult
      ..winner = 1
      ..defeats = battleMatrix[p1Move][p2Move];
  }

  // player 2 won
  return fightResult
    ..winner = 2
    ..defeats = battleMatrix[p2Move][p1Move];
}

class FightResult {
  int winner;       // 0 = tie, 1 = player1, 2 = player2
  String defeats;   // null = tie, <any String> = winning verb
}