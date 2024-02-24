import 'package:flutter/material.dart';

class FallOfWickets extends StatelessWidget {
  final int count;
  final List<List<dynamic>> wicketOrder;

  const FallOfWickets(this.wicketOrder, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key("fow"),
      width: double.maxFinite,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 20,
          color: Colors.transparent,
          child: Column(
            children: [
              count != 0
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        "Fall Of Wickets",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Roboto'),
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      leading: Text(
                        wicketOrder[index][0].name,
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 13),
                      ),
                      trailing: Text(
                        wicketOrder[index][1],
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
