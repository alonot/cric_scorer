

class Batter{
  String name;
  int runs=0;
  int balls=0;
  int fours = 0;
  int sixes = 0;
  double strikeRate=0.0;
  String outBy= 'Not Out';

  void getReadyForNewMatch(){
     runs=0;
     balls=0;
     fours = 0;
     sixes = 0;
     strikeRate=0.0;
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