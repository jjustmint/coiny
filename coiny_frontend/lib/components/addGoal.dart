import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class addGoalPopUp extends StatefulWidget {
  const addGoalPopUp(
      {super.key, required this.reloadGoals, required this.token});
  final String token;
  final Function reloadGoals;

  @override
  State<addGoalPopUp> createState() => _AddGoalPopUpState();
}

class _AddGoalPopUpState extends State<addGoalPopUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController goalAmountController = TextEditingController();

  String? validateGoalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your goal name';
    } else if (value.length > 40) {
      return 'Your name is too long';
    } else {
      return null;
    }
  }

  String? validateGoalAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your goal amount';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    } else if (int.parse(value) <= 0) {
      return 'Please enter a positive number';
    } else if (int.parse(value) > 1000000000) {
      return 'Please enter a number less than 1,000,000,000';
    } else {
      return null;
    }
  }

  void createGoal() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final apiURL = 'http://10.0.2.2:4000/goals/create';
        final response = await http.post(Uri.parse(apiURL),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              "token": widget.token,
              "name": goalNameController.text,
              "goalAmount": int.parse(goalAmountController.text),
            }));
        if (response.statusCode == 200) {
          print('Goal created');
          widget.reloadGoals();
          Navigator.pop(context);
        } else {
          print('Failed to create goal: ${response.body}');
        }
      } catch (e) {
        print('ERROR: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFEDB59E),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Enter your goal',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 65,
              child: TextFormField(
                controller: goalNameController,
                decoration: InputDecoration(
                  labelText: 'Ex. Buy a new car',
                  labelStyle: TextStyle(color: Color(0xFFEDB59E)),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Color(0xFFFFF3EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                ),
                validator: validateGoalName,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Set goal',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 65,
              child: TextFormField(
                controller: goalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ex. 1200000',
                  labelStyle: TextStyle(color: Color(0xFFEDB59E)),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Color(0xFFFFF3EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                ),
                validator: validateGoalAmount,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5CCB4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: createGoal,
            child: Text(
              'Save',
              style: TextStyle(color: const Color(0xFF95491E)),
            ),
          ),
        ),
      ],
    );
  }
}
