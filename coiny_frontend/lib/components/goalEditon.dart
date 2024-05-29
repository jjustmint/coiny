import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NumberInputDialog extends StatefulWidget {
  final int goal;
  final int saved;
  final String name;
  final int goalId;
  final String token;
  final Function reloadGoals;

  NumberInputDialog({
    super.key,
    required this.goal,
    required this.saved,
    required this.name,
    required this.goalId,
    required this.reloadGoals,
    required this.token,
  });

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    } else if (int.parse(value) > widget.saved) {
      return 'You cannot add more than you have';
    } else if (int.parse(value) <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }

  void addMoney() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final apiURL = 'http://10.0.2.2:4000/goals/add';
        if (_controller.text.isNotEmpty) {
          final response = await http.patch(Uri.parse(apiURL),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                "token": widget.token,
                "goalId": widget.goalId,
                "amount": int.parse(_controller.text),
              }));
          if (response.statusCode == 200) {
            print('Added money to goal');
            widget.reloadGoals();
            Navigator.pop(context);
          } else {
            setState(() {
              errorMessage = 'You cannot add more than your goal amount';
            });
          }
        }
      } catch (e) {
        print('ERROR: $e');
        print(_controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFEDB59E),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(widget.name),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AnotherPopup(
                        token: widget.token,
                        goalId: widget.goalId,
                        name: widget.name,
                        reloadGoals: widget.reloadGoals,
                        goal: widget.goal,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your saved : ${widget.saved}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'How much money do you want to put in goal?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              height: 65,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ex. 200',
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
                validator: validateAmount,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: errorMessage != null
                  ? Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[900]),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5CCB4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: addMoney,
              child: Text(
                'Save',
                style: TextStyle(color: const Color(0xFF95491E)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnotherPopup extends StatefulWidget {
  final String token;
  final int goalId;
  final String name;
  final int goal;
  final Function reloadGoals;

  const AnotherPopup({
    super.key,
    required this.token,
    required this.goalId,
    required this.reloadGoals,
    required this.name,
    required this.goal,
  });

  @override
  _AnotherPopupState createState() => _AnotherPopupState();
}

class _AnotherPopupState extends State<AnotherPopup> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: widget.name);
    _controller2 = TextEditingController(text: widget.goal.toString());
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? validateGoalAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a goal amount';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    } else if (int.parse(value) <= 0) {
      return 'Please enter a positive number';
    } else if (int.parse(value) > 1000000000) {
      return 'Please enter a number less than 1,000,000,000';
    }
    return null;
  }

  void editGoal() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final apiURL = 'http://10.0.2.2:4000/goals/edit';
        if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
          final response = await http.patch(Uri.parse(apiURL),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                "token": widget.token,
                "goalId": widget.goalId,
                "name": _controller1.text,
                "goalAmount": int.parse(_controller2.text),
              }));
          if (response.statusCode == 200) {
            print('Edit goal');
            widget.reloadGoals();
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print('ERROR: $e');
        print(_controller1.text);
        print(_controller2.text);
      }
    }
  }

  void deleteGoal() async {
    try {
      final apiURL =
          'http://10.0.2.2:4000/goals/delete?token=${widget.token}&goalId=${widget.goalId}';
      final response = await http.delete(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('delete goal');
        widget.reloadGoals();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print('ERROR: $e');
      print(_controller1.text);
      print(_controller2.text);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEDB59E),
          title: Text("Are you sure that you want to delete?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5CCB4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: const Color(0xFF95491E)),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF95491E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: deleteGoal,
                  child: Text(
                    'Yes',
                    style: TextStyle(color: const Color(0xFFF5CCB4)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                'Edit your goal',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 65,
              child: TextFormField(
                controller: _controller1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Ex. Dream house',
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
                validator: validateName,
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
                controller: _controller2,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5CCB4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _showConfirmationDialog,
              child: Text(
                'Delete',
                style: TextStyle(color: const Color(0xFF95491E)),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF95491E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: editGoal,
              child: Text(
                'Save',
                style: TextStyle(color: const Color(0xFFF5CCB4)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
