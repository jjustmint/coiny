import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Plan1Page extends StatefulWidget {
  final Function navigateToPlan2;
  final token;

  const Plan1Page(this.navigateToPlan2, this.token, {Key? key})
      : super(key: key);

  @override
  _Plan1PageState createState() => _Plan1PageState();
}

class _Plan1PageState extends State<Plan1Page> {
  final url = 'http://10.0.2.2:4000/plans/create';
  TextEditingController monthlyController = TextEditingController();
  TextEditingController savedController = TextEditingController();
  String result = '';
  int userId = 2;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    monthlyController.dispose();
    savedController.dispose();
    super.dispose();
  }

  Future<void> _postData() async {
    try {
      final double monthly = double.parse(monthlyController.text);
      final double save = double.parse(savedController.text);
      final double currentSave = double.parse(savedController.text);
      final response = await http
          .post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'token': widget.token,
          'monthly': monthly,
          'save': save,
          'currentSave': currentSave,
        }),
      )
          .catchError((e) {
        print('Error occurred during POST request: $e');
        throw Exception('Failed to post data: $e');
      });

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('create plan success(200)');
        widget.navigateToPlan2();
        final responseData = jsonDecode(response.body);
        setState(() {
          result =
              'userId: ${responseData['userId']}\nmonthly: ${responseData['monthly']}\nsave: ${responseData['save']}\ncurrentSave: ${responseData['currentSave']}';
        });
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE2D2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Planning",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Monthly",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: monthlyController,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFF3EC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Saved",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: savedController,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFF3EC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        int monthly = int.tryParse(monthlyController.text) ?? 0;
                        int saved = int.tryParse(savedController.text) ?? 0;
                        print('Monthly: $monthly');
                        print('Saved: $saved');
                        try {
                          await _postData();
                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5CCB4),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Color(0xFF95491E)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
