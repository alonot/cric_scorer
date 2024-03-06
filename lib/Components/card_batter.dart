import '../exports.dart';

class CardBatter extends StatefulWidget {
  final List<Batter> batters;

  final Function(Batter)? onTap;
  final bool isOnMatchPage;
  final bool showOutStatus;

  const CardBatter(
      this.batters, this.isOnMatchPage, this.onTap, this.showOutStatus,
      {super.key});

  @override
  State<CardBatter> createState() => _CardBatterState();
}

class _CardBatterState extends State<CardBatter> {
  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.batters.length.toString());
    try {
      return Card(
        elevation: 20,
        color: Colors.transparent,
        child: widget.batters.isNotEmpty
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
                  widget.batters.length + 1,
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
                                'BATSMAN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 13),
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
                                'B',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                '4s',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                '6s',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'RN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ]);
                    } else {
                      Batter batter = widget.batters[index - 1];
                      return TableRow(children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batter.name +
                                      (index == 1 && widget.isOnMatchPage
                                          ? "*"
                                          : ""),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 13),
                                ),
                                widget.showOutStatus
                                    ? Text(
                                        batter.outBy,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontSize: 11),
                                      )
                                    : const SizedBox(
                                        width: 0,
                                        height: 0,
                                      ),
                              ],
                            ),
                          ),
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              batter.runs.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              batter.balls.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              batter.fours.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              batter.sixes.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
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
                          onTap: () {
                            if (widget.onTap != null) {
                              widget.onTap!(batter);
                            }
                          },
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
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(Util.getsnackbar("Something Happpened${e.toString()}"));
      return const Placeholder();
    }
  }
}
