import 'package:cric_scorer/models/bowler_stat.dart';
import 'package:flutter/material.dart';

class CardBowlerStat extends StatelessWidget {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));
  final List<BowlerStat> bowlers;

  const CardBowlerStat(this.bowlers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: Colors.transparent,
      child: bowlers.isNotEmpty
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
                bowlers.length + 1,
                (index) {
                  if (index == 0) {
                    return TableRow(
                        decoration: BoxDecoration(
                          border: _border,
                        ),
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                            child: Text(
                              'BOWLER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'M',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'W',
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
                              'Eco',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]);
                  } else {
                    BowlerStat bowler = bowlers[index - 1];
                    return TableRow(children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                          child: Text(
                            bowler.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                          ),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            bowler.matches.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            bowler.wickets.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            bowler.average.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            bowler.economy.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {},
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
