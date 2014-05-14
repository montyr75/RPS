part of rps;

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

    // randomly choose which of the least used moves to counter
    String moveToCounter = movesLeastUsed[_random.nextInt(movesLeastUsed.length)];

    // get a list of possible counter moves
    final List<String> counterMoves = _battleMatrix[moveToCounter].keys.toList(growable: false);

    // for DEBUG
//    print("movesLeastUsed: $movesLeastUsed");
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
