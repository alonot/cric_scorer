import '../exports.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final MatchViewModel viewModel = MatchViewModel();
  TextEditingController editingController = TextEditingController();
  List<Player> batters = [];
  List<Player> bowlers = [];
  int isSelected = 0;
  String toDisplay = "1st innings";
  bool isLoading = false;
  List<int> associatedIds = [-1];
  int selectedId = 0;
  int batterBowler = 0;

  @override
  void initState() {
    associatedIds.insertAll(0, playArenaIds);
    if (associatedIds.isEmpty){
      selectedId = -1;
    }else{
      selectedId = associatedIds[0];
    }
    getPlayers();
    super.initState();
  }

  void getPlayers() async {
    isLoading = true;
    if (selectedId == -1) {
      batters = await viewModel.getAllPlayers();
      bowlers = batters;
    }else{
      if (onlinePlayers.containsKey(selectedId)){
        batters = onlinePlayers[selectedId]!;
      }else{
      // get them online
      batters = await viewModel.getOnlinePlayers(selectedId);
        onlinePlayers[selectedId] = batters;
      }
      bowlers = batters;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> showBatter(Player batter) async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.black12,
        content: Container(
          height: 150,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Text(batter.name,style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)),
              Expanded(child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Text('Thirties',style: Util.text_style,),
                      Text(batter.thirtys.toString(),style: Util.text_style, textAlign: TextAlign.end,)
                    ]
                  ),
                  TableRow(
                    children: [
                      Text('Fifties',style: Util.text_style,),
                      Text(batter.fifties.toString(),style: Util.text_style, textAlign: TextAlign.end)
                    ]
                  ),
                  TableRow(
                    children: [
                      Text('Hundreds',style: Util.text_style,),
                      Text(batter.hundreds.toString(),style: Util.text_style, textAlign: TextAlign.end)
                    ]
                  ),
                  TableRow(
                    children: [
                      Text('Balls',style: Util.text_style,),
                      Text(batter.balls.toString(),style: Util.text_style, textAlign: TextAlign.end)
                    ]
                  ),
                ],
              )),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color(0x89000000),
        leading: Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<int>(
            // isExpanded: true,
            icon: const Icon(Icons.sort_rounded),
            elevation: 20,
            value: selectedId,
            underline: Container(),
            items: associatedIds
                .map((id) => DropdownMenuItem(
              value: id,
              child: Text(" ${(id == -1)? "Local" : id}    ",style: TextStyle(color: Colors.red),),
            ))
                .toList(),
            onChanged: (value) {
              // if(!playArenaIds[value]!){
              //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not verified')));
              // }
              setState(() {
                selectedId = value!;
              });
              getPlayers();
            },
          ),
        ),
      ),
      backgroundColor: const Color(0x89000000),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox(width: 0, height: 0),
          !isLoading
              ? Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView(
              children: [
                const ListTile(
                  title: Text(
                    "Stats",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: editingController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: () {
                             if (editingController.text.trim().isNotEmpty){
                               try{
                                 associatedIds.add(int.parse(editingController.text.trim()));
                                 selectedId = associatedIds.last;
                                 getPlayers();
                               }on FormatException{

                               }
                             }
                          }, child: Text('Find')),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey)),
                      onTap: () {
                        setState(() {
                          batterBowler = 0;
                        });
                      },
                      tileColor: batterBowler == 1
                          ? Colors.transparent
                          : Colors.grey,
                      title: const Text(
                        "Batters",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    batterBowler == 0
                        ? CardBatterStat(batters,showBatter)
                        : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey)),
                      onTap: () {
                        setState(() {
                          batterBowler = 1;
                        });
                      },
                      tileColor: batterBowler == 0
                          ? Colors.transparent
                          : Colors.grey,
                      title: const Text(
                        "Bowlers",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    batterBowler == 1
                        ? CardBowlerStat(bowlers)
                        : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
                  ],
                ),
              ],
            ),
          )
              : const SizedBox(
            width: 0,
            height: 0,
          ),
        ],
      ),
    ) ;
  }
}
