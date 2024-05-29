import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coiny_frontend/components/addGoal.dart';
import 'package:coiny_frontend/components/goalEditon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Mygoal {
  final String name;
  final int goal;
  final int currentAmount;
  final int goalId;
  Mygoal(
      {required this.name,
      required this.goal,
      required this.currentAmount,
      required this.goalId});
}

class GoalPage extends StatefulWidget {
  final token;
  GoalPage({Key? key, required this.token}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  int? saved = 0;
  List<Mygoal> goals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getGoal();
    getSave();
    isLoading;
    saved;
  }

  void getGoal() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/goals/get?token=${widget.token}';
      final response = await http.get(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('getGoal');
        setState(() {
          goals = parseGoals(response.body);
        });
        print('goals: $goals');
      } else {
        print('Failed to load goal data');
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void getSave() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/plans/get?token=${widget.token}';
      final response = await http.get(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('getSave');
        setState(() {
          saved = parseSaved(response.body);
          isLoading = false;
        });
        print('saved: $saved');
      } else {
        setState(() {
          saved = null;
          isLoading = true;
        });
        print('Failed to load saved data');
        if (saved == null) {
          print('No saved data found');
        } else {
          print('saved data found');
        }
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE2D2),
      body: SingleChildScrollView(
        child: isLoading
            ? saved == null
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "There is no saved data without a plan, please fill the plan form first!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Goal",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Text(
                              'Your save :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF95491E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text('$saved฿',
                                        style: const TextStyle(
                                            color: Color(0xFFFFF3EC),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        child: ListView.builder(
                          itemCount: goals.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: goalTem(
                                name: goals[index].name,
                                goal: goals[index].goal,
                                currentAmount: goals[index].currentAmount,
                                saved: saved!,
                                goalId: goals[index].goalId,
                                token: widget.token,
                                reloadCallback: () {
                                  getGoal();
                                  getSave();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: AddNewGoal(
                        reloadCallback: getGoal,
                        token: widget.token,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class AddNewGoal extends StatefulWidget {
  final Function() reloadCallback;
  final token;
  const AddNewGoal(
      {Key? key, required this.reloadCallback, required this.token})
      : super(key: key);

  @override
  State<AddNewGoal> createState() => _AddNewGoalState();
}

class _AddNewGoalState extends State<AddNewGoal> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return addGoalPopUp(
                  token: widget.token,
                  reloadGoals: () {
                    widget.reloadCallback();
                  });
            },
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF95491E)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
          child: Icon(
            Icons.add,
            color: Color(0xFFFFF3EC),
          ),
        ));
  }
}

// ignore: must_be_immutable, camel_case_types
class goalTem extends StatelessWidget {
  goalTem({
    super.key,
    required this.name,
    required this.goal,
    required this.currentAmount,
    required this.saved,
    required this.goalId,
    required this.token,
    required this.reloadCallback,
  });
  String name;
  int goal;
  int currentAmount;
  int saved;
  int goalId;
  String token;
  final Function() reloadCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return NumberInputDialog(
              goal: goal,
              saved: saved,
              goalId: goalId,
              name: name,
              token: token,
              reloadGoals: reloadCallback,
            );
          },
        );
      },
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF95491E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          color: Color(0xFFFFF3EC), fontSize: 20),
                    ),
                    Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      currentAmount.toString() + "/" + goal.toString(),
                      style: const TextStyle(
                          color: Color(0xFFFFF3EC), fontSize: 16),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 35,
                          child: LinearProgressIndicator(
                            value: (currentAmount / goal)
                                .toDouble(), //value of percentage. 0.55 = 55%
                            backgroundColor: Color(0xFFFFF3EC),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              currentAmount / goal == 1
                                  ? Colors.lightGreen
                                  : Color(0xFFF98A4C),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              '${(currentAmount / goal * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

List<Mygoal> parseGoals(String responseBody) {
  try {
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

    List<dynamic> jsonData = jsonResponse['data'];

    List<Mygoal> parsedGoals = [];

    for (var item in jsonData) {
      if (item is Map<String, dynamic>) {
        String name = item['name'];
        int goal = item['goalAmount'];
        int currentAmount = item['currentAmount'];
        int goalId = item['goalId'];

        Mygoal goalObject = Mygoal(
          name: name ?? '',
          goal: goal ?? 0,
          currentAmount: currentAmount ?? 0,
          goalId: goalId ?? 0,
        );

        parsedGoals.add(goalObject);
      }
    }

    return parsedGoals;
  } catch (e) {
    print('Error parsing JSON: $e');
    return [];
  }
}

int parseSaved(String responseBody) {
  try {
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    if (jsonResponse.containsKey('data')) {
      Map<String, dynamic> data = jsonResponse['data'];
      int currentSave = data['currentSave'] ?? 0;
      print('currentSave: $currentSave');
      return currentSave;
    }
    return 0;
  } catch (e) {
    print('Error parsing JSON: $e');
    return 0;
  }
}
