/*
 * Write a program that resolves the classic "Rock, Paper, Scissors" battle scenario.
 * 
 * RULES:
 * Paper covers rock.
 * Rock crushes scissors.
 * Scissors cuts paper.
 * 
 * Note: As long as the number of moves available is an odd number and each move defeats
 * exactly half of the remaining moves while being defeated by the other half, any combination
 * of moves will function as a game.
 * 
 * For more: http://www.reddit.com/r/dailyprogrammer_ideas/comments/1ecasd/intermediate_rock_paper_scissors_lizard_spock_ai/
 * Add "Lizard" and "Spock" moves.
 * Add AI entities.
 */

import "dart:math" as Math;

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> standard = {
  "Paper": {"Rock": "covers", "Spock": "disproves"},
  "Rock": {"Scissors": "crushes", "Lizard": "crushes"},
  "Scissors": {"Paper": "cuts", "Lizard": "decapitates"},
  "Lizard": {"Paper": "eats", "Spock": "poisons"},
  "Spock": {"Rock": "vaporizes", "Scissors": "melts"}
};

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> fantasy = {
  "Giant": {"Net": "tears"},
  "Net": {"Knight": "ensnares"},
  "Knight": {"Giant": "eviscerates"}
};

void main() {
  List<String> moves = new List<String>()
    ..addAll(standard.keys);
  
  ChaosBot chaosBot = new ChaosBot(moves);
  StubbornBot stubbornBot = new StubbornBot(moves);
  
  for (int i = 0; i < 10; i++) {
    print(fight(chaosBot.move(), stubbornBot.move(), battleMatrix: standard));
  }
}

String fight(String p1, String p2, {Map<String, Map<String, String>> battleMatrix}) {
  String defeats;
  StringBuffer sb = new StringBuffer();
  
  sb.writeln("Player 1: $p1");
  sb.writeln("Player 2: $p2");
  
  // if Player 1's move has a "defeats" verb for Player 2's move, Player 1 wins -- otherise, reverse it
  defeats = battleMatrix[p1][p2];
  if (defeats != null) {
    sb.writeln("Player 1 wins! $p1 $defeats $p2.");
  }
  else {
    if (p1 == p2) {
      sb.writeln("A tie! Bleh...");
    }
    else {
      defeats = battleMatrix[p2][p1];
      sb.writeln("Player 2 wins! $p2 $defeats $p1.");
    }
  }
  
  return sb.toString();
}

class ChaosBot {
  List<String> _moves;
  
  ChaosBot(List<String> this._moves);
  
  String move() {
    int randomIndex = new Math.Random().nextInt(_moves.length);
    return _moves[randomIndex];
  }
}

class StubbornBot {
  String _stubbornMove;
  
  StubbornBot(List<String> moves) {
    int randomIndex = new Math.Random().nextInt(moves.length);
    _stubbornMove = moves[randomIndex];
  }
  
  String move() => _stubbornMove;
}