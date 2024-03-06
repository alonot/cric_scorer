import '../../exports.dart';

class CardBalls extends StatefulWidget {
  const CardBalls({super.key});

  @override
  State<CardBalls> createState() => _CardBallsState();
}

class _CardBallsState extends State<CardBalls> {
  List<dynamic> bowls = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    var viewModel = MatchViewModel();
    TheMatch? match = viewModel.getCurrentMatch();
    if (match != null) {
      if (match.Overs[match.currentTeam].isNotEmpty) {
        setState(() {
          bowls = match.Overs[match.currentTeam].last.bowls;
          count = bowls.length;
          // debugPrint("$count, $bowls");
        });
      }
    }

    return Card(
        elevation: 20,
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Center(
            key: const Key("oo"),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5),
              child: ListView.builder(
                itemCount: count,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: bowls[index][0].length == 1 ? Colors.lightGreen.shade500 : Colors.red),
                            child: Center(
                              child: Text(bowls[index][0][0]),
                            ),
                          ),
                          bowls[index][1].isNotEmpty
                              ? Expanded(
                                  child: Text(
                                    bowls[index][1],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                )
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ));
  }
}
