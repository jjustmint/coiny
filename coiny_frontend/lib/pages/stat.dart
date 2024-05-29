import 'dart:convert';
import 'package:coiny_frontend/barGraph/bar_Graph.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class stat extends StatefulWidget {
  final token;
  const stat({super.key, required this.token});

  @override
  State<stat> createState() => _statState();
}

class _statState extends State<stat> {
  late List<double> financial = [0, 0, 0];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSave();
    isLoading;
    financial;
  }

  void getSave() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/users/stat?token=${widget.token}';
      final response = await http.get(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('getSave and currentSave');
        setState(() {
          financial = parseMoney(response.body);
          isLoading = false;
        });
        print(financial);
      } else {
        setState(() {
          financial = [];
          isLoading = true;
        });
        print('Failed to load financial data');
        if (financial.isEmpty) {
          print('No financial data found');
        } else {
          print('Financial data found');
        }
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFE2D2),
        body: SingleChildScrollView(
          child: Center(
            child: isLoading
                ? financial.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "There is no stat data without a plan, please fill the plan form first!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : CircularProgressIndicator()
                : Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, right: 220),
                        child: Text(
                          'Stat',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 30),
                        child: SizedBox(
                          height: 240,
                          width: 280,
                          child: MyBarGraph(financial: financial),
                        ),
                      ),
                      const SizedBox(height: 20),
                      StatInfo(
                        Saved: financial[0].toInt(),
                        UsableMoney: financial[1].toInt(),
                        Used: financial[2].toInt(),
                      )
                    ],
                  ),
          ),
        ));
  }
}

class StatInfo extends StatelessWidget {
  int Saved;
  int UsableMoney;
  int Used;
  StatInfo({
    required this.Saved,
    required this.UsableMoney,
    required this.Used,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 207,
      width: 324,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: statdata(name: "Current Save", value: Saved),
          ),
          statdata(name: "Usable Money", value: UsableMoney),
          statdata(name: "Used", value: Used),
          const Divider(
            color: Color(0xFFEDB59E),
            height: 20,
            thickness: 4,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("${Saved + UsableMoney}฿",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class statdata extends StatelessWidget {
  const statdata({super.key, required this.name, required this.value});

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 20)),
          Text("$value฿",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}

List<double> parseMoney(String responseBody) {
  try {
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    if (jsonResponse.containsKey('data')) {
      Map<String, dynamic> data = jsonResponse['data'];
      int currentSave = data['currentSave'] ?? 0;
      int UsableMoney = data['usableMoney'] ?? 0;
      int Used = data['used'] ?? 0;
      print('currentSave: $currentSave UsableMoney: $UsableMoney Used: $Used');
      return [
        currentSave.toDouble(),
        UsableMoney.toDouble(),
        (Used.toDouble() * (-1.00))
      ];
    }
    return [];
  } catch (e) {
    print('Error parsing JSON: $e');
    return [];
  }
}
