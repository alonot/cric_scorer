
class Over{
  late String bowlerName;
  late List<String> batters;
  late List<List<String>> bowls;
  late int runs;


  Over.fromString(String s){
    List<String> arrayOfData = s.split('#');
    print(arrayOfData.toString());
    bowlerName = (arrayOfData[0]);
    runs = int.parse(arrayOfData[2]);

    // getting batters
    batters= [];
    List<String> arrayOfBatters = arrayOfData[1].split('&');
    for(String s in arrayOfBatters){
      batters.add(s);
    }

    // getting bowls
    bowls = [];
    List<String> arrayOfBowls = arrayOfData[3].split('@');
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

    resultString = "$bowlerName#${batters.join('&')}#$runs#";

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

  Over(this.bowlerName,this.batters,{this.runs=0,bowls}){
    if(bowls != null){
      this.bowls = bowls;
    }else{
      this.bowls = [];
    }
  }


}