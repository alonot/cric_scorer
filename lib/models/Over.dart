
class Over{
  late int over_no;
  late bool wasMaiden;
  late String bowlerName;
  late List<String> batters;
  late List<List<String>> bowls;
  late int runs;


  Over.fromString(String s){
    List<String> arrayOfData = s.split('#');
    // print(arrayOfData.toString());
    over_no = int.parse(arrayOfData[0]);
    wasMaiden = bool.parse(arrayOfData[1]);
    bowlerName = (arrayOfData[2]);
    runs = int.parse(arrayOfData[4]);

    // getting batters
    batters= [];
    List<String> arrayOfBatters = arrayOfData[3].split('&');
    for(String s in arrayOfBatters){
      batters.add(s);
    }

    // getting bowls
    bowls = [];
    List<String> arrayOfBowls = arrayOfData[5].split('@');
    for (String s in arrayOfBowls){
      List<String> eachBowl = s.split('&');
      // debugPrint(eachBowl.toString());
      if (eachBowl.toString() != "[]"){
        // debugPrint("all");
      bowls.add(eachBowl);
      }
    }
    // debugPrint("FromOver:${bowls.toString()}");

  }

  @override
  String toString() {
    String resultString = "";

    resultString = "$over_no#$wasMaiden#$bowlerName#${batters.join('&')}#$runs#";

    int count = bowls.length;
    for (dynamic d in bowls){
      count --;
      resultString += d.join('&');
      if( count != 0) {
        resultString +="@";
      }
    }

    return resultString;
  }

  Over(this.over_no,this.bowlerName,this.batters,{this.runs=0,bowls,this.wasMaiden=false}){
    if(bowls != null){
      this.bowls = bowls;
    }else{
      this.bowls = [];
    }
  }


}