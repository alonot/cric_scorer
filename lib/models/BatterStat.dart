class BatterStat {
  String name = "";
  int innings = 0;
  int runs = 0;
  int highest = 0;
  double average = 0;
  double strikeRate = 0;
  int fifties = 0;
  int hundreds = 0;
  int thirtys = 0;

  BatterStat.fromMap(Map<String, dynamic> map,String name) {
    print(name);
    this.name = name;
    innings = map['I']!.toInt();
    highest = map['H']!.toInt();
    runs = map['R']!.toInt();
    fifties = map['fifties']!.toInt();
    hundreds = map['hundreds']!.toInt();
    thirtys = map['thirties']!.toInt();
    strikeRate = map['Sk.R']!;
    average = map['Avg']!;
  }
}
