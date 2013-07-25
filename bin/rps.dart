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

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> standard = {
  "Paper": {"Rock": "covers"},
  "Rock": {"Scissors": "crushes"},
  "Scissors": {"Paper": "cuts"}
};

// each move refers to a Map of moves that it can defeat
final Map<String, Map<String, String>> fantasy = {
  "Giant": {"Net": "tears"},
  "Net": {"Knight": "ensnares"},
  "Knight": {"Giant": "eviscerates"}
};

void main() {
  print(fight("Paper", "Scissors", battleMatrix: standard));
  
  print(fight("Knight", "Giant", battleMatrix: fantasy));
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
    defeats = battleMatrix[p2][p1];
    sb.writeln("Player 2 wins! $p2 $defeats $p1.");
  }
  
  return sb.toString();
}