import '../../exports.dart';

class CardBatterStat extends StatelessWidget {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));
  final List<Player> batters;
  final Function  onTap;

  const CardBatterStat(this.batters, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    batters.removeWhere((element) => element.runs == 0 && element.innings == 0);
    return Card(
      elevation: 20,
      color: Colors.transparent,
      child: batters.isNotEmpty
          ? Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(
                batters.length + 1,
                (index) {
                  if (index == 0) {
                    return TableRow(
                        decoration: BoxDecoration(
                          border: _border,
                        ),
                        children:  const <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                            child: Text(
                              'BATTER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'I',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'R',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'H',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'Avg',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'Sk.R',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]);
                  } else {
                    Player batter = batters[index - 1];
                    return TableRow(children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  batter.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            batter.innings.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            batter.runs.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            batter.highest.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            batter.Bataverage.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            batter.strikeRate.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                        onTap: () {onTap(batter);},
                      ),
                    ]);
                  }
                },
              ),
            )
          : const SizedBox(
              width: 0,
              height: 0,
            ),
    );
  }
}
