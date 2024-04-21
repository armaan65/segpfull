import 'package:flutter/foundation.dart';

class ScortenScoreProvider extends ChangeNotifier {
  int? _scortenScore;

  int? get scortenScore => _scortenScore;

  set scortenScore(int? score) {
    _scortenScore = score;
    notifyListeners();
  }
}
