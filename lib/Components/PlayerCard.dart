
import '../exports.dart';

class PlayerCard extends StatefulWidget {
  final String name;
  final List<int> innings;
  final int total_points;
  const PlayerCard(this.name, this.innings,this.total_points,
      {super.key});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListTile(
        leading: Text("${widget.name}",style: const TextStyle(fontFamily: 'Roboto',color: Colors.white,fontSize: 14),),
        trailing: Text(widget.total_points.toString(),style: const TextStyle(fontFamily: 'Roboto',color: Colors.white,fontSize: 17),),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Batting'),
                  Text('1st : ${(widget.innings[0] == SCORE_MIN) ? "DNP" : widget.innings[0] }',style: Util.text_style,),
                  Text('2st : ${(widget.innings[1] == SCORE_MIN) ? "DNP" : widget.innings[1] }',style: Util.text_style,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bowling'),
                  Text('1st : ${widget.innings[2] == SCORE_MIN ? "DNP" : widget.innings[2] }',style: Util.text_style,),
                  Text('2st : ${widget.innings[3] == SCORE_MIN ? "DNP" : widget.innings[3] }',style: Util.text_style,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
