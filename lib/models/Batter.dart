

class Batter{
  late String name;
  late int runs=0;
  late int balls=0;
  late int fours = 0;
  late int sixes = 0;
  late double strikeRate=0.0;
  late String outBy= 'Not Out';

  void getReadyForNewMatch(){
     runs=0;
     balls=0;
     fours = 0;
     sixes = 0;
     strikeRate=0.0;
  }


  @override
  String toString() {
    return "$name#$runs#$balls#$fours#$sixes#${strikeRate.toStringAsFixed(2)}#${outBy}";
  }

  Batter.fromString(String batterString){
    List<String> arrayOfDatas = batterString.split("#");
    name = arrayOfDatas[0];
    runs = int.parse(arrayOfDatas[1]);
    balls = int.parse(arrayOfDatas[2]);
    fours = int.parse(arrayOfDatas[3]);
    sixes = int.parse(arrayOfDatas[4]);
    strikeRate = double.parse(arrayOfDatas[5]);
    outBy = (arrayOfDatas[6]);
  }

  Batter(this.name, {this.runs=0, this.balls=0, this.fours=0, this.sixes=0, this.strikeRate=0.0,});

  void addRun(int run){
    balls+=1;
    runs += run;
    fours += run ==4? 1 : 0;
    sixes += run == 6? 1:0;
    strikeRate = runs /balls *100;
  }

  void removeRun(int run){
    balls-=1;
    runs -= run;
    fours -= run ==4? 1 : 0;
    sixes -= run == 6? 1:0;
    if (balls != 0)    strikeRate = runs /balls *100;
    else strikeRate = 0.0;
  }

}