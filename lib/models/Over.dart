
class Over{
  int over_no;
  bool wasMaiden;
  String bowlerName;
  List<String> batters;
  late List<List<String>> bowls;
  int runs;


  @override
  String toString() {
    String resultString = "";

    resultString = "$over_no#$wasMaiden#$bowlerName#${batters.join('&')}#$runs";

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

  Over(this.over_no,this.bowlerName,this.batters,{this.runs=0,bowls = null,this.wasMaiden=false}){
    if(bowls != null){
      this.bowls = bowls;
    }else{
      this.bowls = [];
    }
  }


}