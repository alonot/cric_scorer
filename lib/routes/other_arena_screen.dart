import '../exports.dart';

class OtherArena extends StatefulWidget {
  const OtherArena({super.key});

  static String id = "OtherArena";

  @override
  State<OtherArena> createState() => _OtherArenaState();
}

class _OtherArenaState extends State<OtherArena> {
  var viewModel = MatchViewModel();
  bool isLoading = false;
  TextEditingController arenaIdController = TextEditingController();
  Map<String, List<dynamic>> emails = {};

  @override
  void initState() {
    super.initState();
    getEmails();
  }

  void getEmails() async {
    emails = await viewModel.getAttachedAccouts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int count = 1;
    return Container(
        decoration: const BoxDecoration(
          border: null,
          image: DecorationImage(
              image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x89000000),
          body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: arenaIdController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              label: Text(
                            "Add an arena",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              int result = await viewModel.requestPlayArena(int.parse(arenaIdController.text));
                              if (result == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Not Found')));
                              } else if (result == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Request Sent')));
                              }
                            },
                            child: const Text("Submit")),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Connected Accounts ',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 600,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: emails
                                .map<Widget, bool>((key, value) => MapEntry(
                                ListTile(
                                  title: Text(
                                    "${count++}. $key",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(25)),
                                            color: value[1]
                                                ? const Color(0x424242a1)
                                                : Colors.transparent,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: IconButton(
                                            onPressed: value[1]
                                                ? null
                                                : () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              viewModel.verifyUser(value[0])
                                              .then((result) {
                                                if (result == 0){
                                                  viewModel.unVerifyUser(value[0]);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('This User does not exists'));

                                                }else if (result == -1){
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('Not logged In'));
                                                }else if (result == 1){
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('Verified'));
                                                }
                                                setState(() {
                                                  getEmails();
                                                  isLoading = false;
                                                });
                                              });
                                            },
                                            disabledColor:
                                            Colors.green.shade50,
                                            icon: Icon(
                                              Icons.check,
                                              color: !value[1]
                                                  ? Colors.green
                                                  : Colors.white
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(25)),
                                            color: !value[1]
                                                ? const Color(0x424242a1)
                                                : Colors.transparent,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: IconButton(
                                            onPressed: !value[1]
                                                ? null
                                                : () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              viewModel.unVerifyUser(value[0])
                                                  .then((result) {
                                                if (result == 0){
                                                  viewModel.unVerifyUser(value[0]);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('This User does not exists'));

                                                }else if (result == -1){
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('Not logged In'));
                                                }else if (result == 1){
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(Util.getsnackbar('Verified'));
                                                }
                                                setState(() {
                                                  getEmails();
                                                  isLoading = false;
                                                });
                                              });
                                            },
                                            disabledColor:
                                            Colors.red.shade50,
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              color: value[1]
                                                  ? Colors.red
                                                  : Colors.white
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                    true))
                                .keys
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ));
  }
}
