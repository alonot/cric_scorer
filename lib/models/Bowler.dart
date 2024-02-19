

import 'package:flutter/cupertino.dart';

class Bowler{
  late String name;
  late int runs=0;
  late int wickets=0;
  late double overs=0.0;
  late int maidens=0;
  late double economy=0;

  @override
  String toString(){
    return "$name#$runs#$wickets#$overs#$maidens#$economy";
  }

  Bowler.fromString(String bowlerString){
    debugPrint(bowlerString);
    List<String> arrayOfDatas = bowlerString.split("#");
    debugPrint(arrayOfDatas.toString());
    name = arrayOfDatas[0];
    runs = int.parse(arrayOfDatas[1]);
    wickets = int.parse(arrayOfDatas[2]);
    overs = double.parse(arrayOfDatas[3]);
    maidens = int.parse(arrayOfDatas[4]);
    economy = double.parse(arrayOfDatas[5]);
  }

  Bowler(this.name,{ this.runs=0, this.wickets=0, this.overs=0, this.maidens=0,});

  void addBowl(int run,String type,bool isWicket,int runInOver){
    runs+=run;
    if (isWicket){
      wickets+=1;
    }
    if (type != "Wd" && type != "Nb"){
      if((overs*10).toInt()%10 ==5){
        overs+=0.5;
        maidens +=runInOver ==0?1:0;
      }else{
        overs+=0.1;
      }
    }
    double overInPercen = (overs*10).toInt() /10 + (((overs *10).toInt() % 10)/6);
    economy = runs / overInPercen;
  }

  void removeBowl(int run, String type,bool wasWicket,int runInOver){
    runs-=run;
    if (wasWicket){
      wickets-=1;
    }
    if (type != "Wd" && type != "Nb"){
      if((overs*10).toInt()%10 ==0){
        overs-=0.5;
        maidens -=runInOver ==0?1:0;
      }else{
        overs-=0.1;
      }
    }
    double overInPercen = (overs*10).toInt() /10 + (((overs *10).toInt() % 10)/6);
    if (overInPercen == 0){
      economy = 0.0;
    }else {
      economy = runs / overInPercen;
    }
  }

}