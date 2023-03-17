import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../widgets/default_app_bar.dart';

class TestDropDownSearch extends StatefulWidget {
  const TestDropDownSearch({Key? key}) : super(key: key);

  @override
  State<TestDropDownSearch> createState() => _TestDropDownSearchState();
}

class _TestDropDownSearchState extends State<TestDropDownSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Test', context),
      body: Column(
        children: [
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith('I'),
            ),
            items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Menu mode",
                hintText: "country in menu mode",
              ),
            ),
            onChanged: print,
            selectedItem: "Brazil",
          ),

          DropdownSearch<String>.multiSelection(
            items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith('I'),
            ),
            onChanged: print,
            selectedItems: ["Brazil"],
          ),
          DropdownSearch(
            items: ["Brazil", "France", "Tunisia", "Canada"],
            //dropdownSearchDecoration: InputDecoration(labelText: "Name"),
            onChanged: print,
            selectedItem: "Tunisia",
            validator: (String? item) {
              if (item == null)
                return "Required field";
              else if (item == "Brazil")
                return "Invalid item";
              else
                return null;
            },
          )
        ],
      ),
    );
  }
}
