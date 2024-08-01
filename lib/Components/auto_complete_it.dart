import 'package:cric_scorer/exports.dart';
import 'package:flutter/material.dart';

class AutoCompleteIt extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) setValue;

  const AutoCompleteIt(this.suggestions, this.setValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsViewBuilder: (context, funct, options) {
        return Drawer(
          backgroundColor: Colors.transparent,
           child: Container(
             height: 100,
             child: Column(
                  children : List.generate(options.length,(index) {
                    return ListTile(
                      tileColor: Colors.black54,
                      shape: const RoundedRectangleBorder(
                       side:  BorderSide(color: Colors.black)
                      ),
                      onTap: () {
                        funct(options.elementAtOrNull(index) ?? "");
                      },
                      leading: Text(options.elementAt(index),style: const TextStyle(color: Colors.white,fontSize: 14),),
                    );
                  })
              ),
           ));
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        setValue(textEditingValue.text);
        if (textEditingValue.text.isEmpty) {
          return suggestions;
        } else {
          return suggestions.where((String option) {
            return option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        }
      },
    );
  }
}
