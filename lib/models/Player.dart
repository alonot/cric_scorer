class Player {
  late String name;
  int ArenaId = -1;
  int innings = 0;
  int runs = 0;
  int balls = 0;
  int highest = 0;
  double Bataverage = 0;
  double strikeRate = 0;
  int fifties = 0;
  int hundreds = 0;
  int thirtys = 0;

  double economy = 0.0;
  int bowlerRuns = 0;
  int wickets = 0;
  int matches = 0;
  double Bowlaverage = 0.0;

  Player(this.name,
      {this.innings = 0,
        this.ArenaId = 0,
      this.runs = 0,
        this.balls = 0,
      this.highest = 0,
      this.Bataverage = 0,
      this.strikeRate = 0,
      this.fifties = 0,
      this.hundreds = 0,
      this.thirtys = 0,
        //
      this.economy = 0.0,
        this.bowlerRuns = 0,
      this.wickets = 0,
      this.matches = 0,
      this.Bowlaverage = 0.0});

  Player.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    ArenaId = map['ArenaId'];
    // batter
    innings = map['innings'];
    runs = map['runs'];
    balls = map['balls'];
    highest = map['highest'];
    Bataverage = map['Bataverage'];
    strikeRate = map['strikeRate'];
    fifties = map['fifties'];
    hundreds = map['hundreds'];
    thirtys = map['thirtys'];
    // bowler
    bowlerRuns = map['bowlerRuns'];
    economy = map['economy'];
    wickets = map['wickets'];
    matches = map['matches'];
    Bowlaverage = map['Bowlaverage'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['ArenaId'] = ArenaId;
    map['innings'] = innings;
    map['runs'] = runs;
    map['balls'] = balls;
    map['highest'] = highest;
    map['Bataverage'] = Bataverage;
    map['Bowlaverage'] = Bowlaverage;
    map['strikeRate'] = strikeRate;
    map['fifties'] = fifties;
    map['hundreds'] = hundreds;
    map['thirtys'] = thirtys;
    map['economy'] = economy;
    map['bowlerRuns'] = bowlerRuns;
    map['wickets'] = wickets;
    map['matches'] = matches;

    return map;
  }
}
