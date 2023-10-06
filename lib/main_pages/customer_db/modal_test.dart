import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCustomerModal extends StatefulWidget {
  @override
  _AddCustomerModalState createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<AddCustomerModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerDateController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  bool contractYn = false;
  String? selectedCustomerType;

  // Customer types list
  final List<String> customerTypes = ["OD", "AD", "CP", "CD", "JD", "H", "X", "Y", "Z"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Customer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            CheckboxListTile(
              title: Text("Contract YN"),
              value: contractYn,
              onChanged: (bool? value) {
                setState(() {
                  contractYn = value!;
                });
              },
            ),
            Wrap(
              children: customerTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: selectedCustomerType == type,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selectedCustomerType == type) {
                        selectedCustomerType = null;
                      } else {
                        selectedCustomerType = type;
                      }
                    });
                  },
                );
              }).toList(),
            ),
            TextField(
              controller: registerDateController,
              decoration: InputDecoration(labelText: "Register Date"),
            ),
            TextField(
              controller: birthController,
              decoration: InputDecoration(labelText: "Birth Date"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: "State"),
            ),
            TextField(
              controller: memoController,
              maxLines: 2,
              decoration: InputDecoration(labelText: "Memo"),
            ),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                // Here, you can add the logic to handle form submission
                // and send data to your server using http package.
                // ...
              },
            )
          ],
        ),
      ),
    );
  }
}
