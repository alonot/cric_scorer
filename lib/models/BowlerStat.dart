class BowlerStat {
  String name = "";
  double economy = 0.0;
  int wickets = 0;
  int matches = 0;
  double average = 0.0;

  BowlerStat.fromMap(Map<String, dynamic> map,this.name) {
    economy = map['Eco']!;
    wickets = map['W']!.toInt();
    matches = map['M']!.toInt();
    average = map['Avg']!;
  }
}
