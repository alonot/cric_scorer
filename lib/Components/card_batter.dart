import '../exports.dart';

class CardBatter extends StatefulWidget {
  final List<Batter> batters;
  final Function(String)? changeName;
  final Function(Batter)? onTap;
  final bool isOnMatchPage;
  final bool showOutStatus;

  const CardBatter(this.batters, this.isOnMatchPage, this.onTap,
      this.showOutStatus, this.changeName,
      {super.key});

  @override
  State<CardBatter> createState() => _CardBatterState();
}

class _CardBatterState extends State<CardBatter> {
  List<TextEditingController> batterCtnl = [
    new TextEditingController(),
    new TextEditingController()
  ];
  List<FocusNode> batterFocus = [new FocusNode(), new FocusNode()];

  final Border _border =
      const Border(bottom: BorderSide(color: Color(0x41eceff1), width: 1));

  Widget getText(String name){
    return Text(name, style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontSize: 13),);
  }

  Widget getEditableText(int index,String name){
    batterCtnl[index - 1].text = name +
        (index == 1 && widget.isOnMatchPage ? "*" : "");
    return EditableText(
      controller: batterCtnl[index - 1],
      style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontSize: 13),
      focusNode: batterFocus[index - 1],
      cursorColor: Colors.blue,
      backgroundCursorColor: Colors.grey,
      readOnly: !widget.isOnMatchPage,
      onEditingComplete: () {
        batterCtnl[index- 1].text = batterCtnl[index - 1].text.replaceAll("*", "").trim();
        if (batterCtnl[index - 1].text.isEmpty) {

        } else if (widget
            .changeName!(batterCtnl[index - 1].text)) {
          name = batterCtnl[index - 1].text;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(Util.getsnackbar(
              "Batter: ${batterCtnl[index - 1].text} already exists"));
        }
        batterCtnl[index - 1].text = name +
            ((index == 1) ? "*" : "");
        batterFocus[index - 1].unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(widget.batters.length.toString());
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
                        (widget.isOnMatchPage) ? getEditableText(index,batter.name) :
                            getText(batter.name),
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
    // try {
    //
    // }
    // catch (e) {
    //   // ScaffoldMessenger.of(context)
    //       // .showSnackBar(Util.getsnackbar("Something Happpened${e.toString()}"));
    //   return const Placeholder();
    // }
  }
}
