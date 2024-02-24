import 'package:flutter/material.dart';

class AutoCompleteIt extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) setValue;

  const AutoCompleteIt(this.suggestions, this.setValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        setValue(textEditingValue.text);
        if (textEditingValue.text == '') {
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
