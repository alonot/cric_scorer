import 'package:cric_scorer/match_view_model.dart';
import 'package:cric_scorer/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Map<String, bool> emails = {};

  @override
  void initState() {
    super.initState();
    getEmails();
  }

  void getEmails() async {
    emails = await viewModel.getAttachedAccounts();
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
                              bool result = await viewModel.findnUploadUser(
                                  currentUser,
                                  int.parse(arenaIdController.text));
                              if (!result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Not Found/Duplicate')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Done')));
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
                                    Dismissible(
                                      key: Key(count.toString() + key),
                                      onDismissed: (direction) {
                                        if (direction ==
                                            DismissDirection.startToEnd) {

                                          viewModel.deleteEmailForThisId(
                                              key, viewModel.getbaseId);
                                        }
                                      },
                                      child: ListTile(
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
                                                  color: value
                                                      ? const Color(0x424242a1)
                                                      : Colors.transparent,
                                                ),
                                                width: 40,
                                                height: 40,
                                                child: IconButton(
                                                  onPressed: value
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          viewModel
                                                              .verifyEmail(key)
                                                              .then((value) {
                                                            if (value) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Verified')));
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Failed to Verified')));
                                                            }
                                                            setState(() {
                                                              getEmails();
                                                            });
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                          });
                                                          // send request to make verify = true
                                                        },
                                                  disabledColor:
                                                      Colors.green.shade50,
                                                  icon: Icon(
                                                    Icons.check,
                                                    color: !value
                                                        ? Colors.green
                                                        : Colors.white.withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(25)),
                                                  color: !value
                                                      ? const Color(0x424242a1)
                                                      : Colors.transparent,
                                                ),
                                                width: 40,
                                                height: 40,
                                                child: IconButton(
                                                  onPressed: !value
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          viewModel.unverifyEmail(key)
                                                              .then((value) {
                                                            if (value) {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          content:Text('Un-verified')));
                                                            } else {
                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:Text('Operation Failed')));
                                                            }
                                                            setState(() {
                                                              getEmails();
                                                            });
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                          });
                                                          // send request to make verify = false
                                                        },
                                                  disabledColor:
                                                      Colors.red.shade50,
                                                  icon: Icon(
                                                    Icons.cancel_outlined,
                                                    color: value? Colors.red :
                                                    Colors.white.withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
