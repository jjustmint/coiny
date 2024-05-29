import 'package:coiny_frontend/components/addMoney.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Plan2Page extends StatefulWidget {
  final Function navigateToPlan1;
  final token;

  const Plan2Page(this.navigateToPlan1, this.token, {Key? key})
      : super(key: key);
  @override
  State<Plan2Page> createState() => _Plan2PageState();
}

class _Plan2PageState extends State<Plan2Page> {
  final urlget = 'http://10.0.2.2:4000/plans/get';
  final urlreset = 'http://10.0.2.2:4000/plans/reset';
  double monthly = 0;
  double save = 0;

  Future<Map<String, dynamic>> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('$urlget?token=${widget.token}'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print('Received data: $jsonData');
        return jsonData;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during HTTP request: $e');
    }
  }

  Future<void> _resetData() async {
    try {
      final response =
          await http.delete(Uri.parse('$urlreset?token=${widget.token}'));
      if (response.statusCode == 200) {
        print('Reset successful');
        widget.navigateToPlan1();
      } else {
        throw Exception('Failed to reset data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE2D2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: FutureBuilder<Map<String, dynamic>>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // While waiting for data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Access monthly and save values directly from the snapshot data
                int monthly = snapshot.data!['data']['monthly'];
                int save = snapshot.data!['data']['save'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Planning",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Monthly",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Text(
                                monthly.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Saved",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Text(
                                save.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _resetData();
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFEDB59E),
                        ),
                      ),
                    ),
                    const Text(
                      "Add Bonus Money",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return addMoney(
                                      token: widget
                                          .token); // Show AnotherPopup when NumberInputButton is clicked
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFF5CCB4), // Background color
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Color(0xFF95491E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
