import 'package:flutter/material.dart';

class GetBatter extends StatefulWidget {
  const GetBatter({super.key});

  @override
  State<GetBatter> createState() => _GetBatterState();
}

class _GetBatterState extends State<GetBatter> {
  TextEditingController battercntrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        border: null,
        image: DecorationImage(
        image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
    ),
    child: Padding(
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          children: [Card(
          elevation: 20,
          color: Colors.transparent,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: battercntrl,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        labelText: 'New Batter',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(text: 'Socre : '),
                          TextSpan(
                              text: '197-5', style: TextStyle(color: Colors.red)),
                          TextSpan(
                              text: ' 18.2 OVERS',
                              style: TextStyle(color: Colors.blueGrey))
                        ])),
                  )
                ],
              ),
            ),
          ),
        )
          ,Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                debugPrint("Lets Play!!");
              },
              child: Text(
                "Let's Play!!",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Color(0x42A4E190))),
            ),
          ),
        ),
          ],
        )


      )
    ));
  }
}
