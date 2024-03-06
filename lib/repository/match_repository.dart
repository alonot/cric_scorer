
import '../exports.dart';


class MatchRepository extends ChangeNotifier{
  TheMatch? currentMatch;
  int battersCount = 0;
  int bowlersCount = 0;
  List<BatterStat>?  batters;
  List<BowlerStat>? bowlers;
  int baseId = 0;
  bool isSignedIn = false;

  void setMatch(TheMatch match) async{
    currentMatch = match;
    notifyListeners();
  }
}