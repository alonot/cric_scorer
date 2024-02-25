class BowlerStat {
  String name = "";
  double economy = 0.0;
  int wickets = 0;
  int matches = 0;
  double average = 0.0;

  BowlerStat.fromMap(Map<String, dynamic> map, this.name) {
    if (map['E'] != null) {
      economy = map['Eco']!;
    }
    if (map['W'] != null) {
      wickets = map['W']!.toInt();
    }
    if (map['M'] != null) {
      matches = map['M']!.toInt();
    }
    if (map['Avg'] != null) {
      average = (map['Avg']!).toDouble();
    }
  }
}
