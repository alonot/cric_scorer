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

  BatterStat.fromMap(Map<String, dynamic> map,this.name) {
    if(map['I'] != null) {
      innings = map['I']?.toInt();
    }if(map['H'] != null) {
      highest = map['H']?.toInt();
    }if(map['R'] != null) {
      runs = map['R']?.toInt();
    }if(map['fifties'] != null) {
      fifties = map['fifties']?.toInt();
    }if(map['hundreds'] != null) {
      hundreds = map['hundreds']?.toInt();
    }if(map['thirties'] != null) {
      thirtys = map['thirties']?.toInt();
    }if(map['Sk.R'] != null) {
      strikeRate = map['Sk.R'].toDouble();
    }if(map['Avg'] != null) {
      average = map['Avg'].toDouble();
    }
  }
}
