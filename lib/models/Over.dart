

import 'package:cric_scorer/utils/util.dart';

class Over{
  int over_no;
  bool wasMaiden;
  String bowlerName;
  List<String> batters;
  late List<dynamic> bowls;
  int runs;

  Over(this.over_no,this.bowlerName,this.batters,{this.runs=0,bowls = null,this.wasMaiden=false}){
    if(bowls != null){
      this.bowls = bowls;
    }else{
      this.bowls = [];
    }
  }


}