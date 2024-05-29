import 'package:coiny_frontend/components/profile.dart';
import 'package:coiny_frontend/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'pages/home.dart';
import 'pages/plan1.dart';
import 'pages/plan2.dart';
import 'pages/stat.dart';
import 'pages/goal.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  var token;
  MyApp({Key? key, required this.token}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final urlget = 'http://10.0.2.2:4000/plans/get';
  late int _selectedPlanPage;
  bool _loggedIn = false; // Remove 'late' keyword
  String token = '';
  late bool noplan;
  String? username = '';
  String? profile = '';
  @override
  void initState() {
    super.initState();
    getUser();
    getImage();
    _selectedPlanPage = 1; // Assuming Plan1Page is the default page
    _initializeDataAndLogin();
    token = widget.token;
  }

  Future<void> _initializeDataAndLogin() async {
    try {
      await _checkDataAndNavigate();
      await _checkLoginStatus();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    // Implement your logic to check if the user is logged in
    // For demonstration purposes, I'm assuming the user is not logged in initially
    setState(() {
      _loggedIn = true;
    });
  }

  Future<void> _checkDataAndNavigate() async {
    try {
      final data = await _getData();
      if (data != null) {
        // Data is available, navigate to Plan2Page
        setState(() {
          _selectedPlanPage = 2;
        });
      } else {
        // No data available, navigate to Plan1Page
        setState(() {
          _selectedPlanPage = 1;
          noplan = true;
        });
      }
    } catch (e) {
      // Error occurred, navigate to Plan1Page
      setState(() {
        _selectedPlanPage = 1;
      });
    }
  }

  Future<Map<String, dynamic>?> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('$urlget?token=${widget.token}'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print('Received data: $jsonData');
        return jsonData;
      } else {
        print(widget.token);
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during HTTP request: $e');
    }
  }

  void getUser() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/users/get?token=${widget.token}';
      var res = await http.get(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      if (jsonResponse.containsKey('data')) {
        Map<String, dynamic> data = jsonResponse['data'];
        String name = data['name'];
        setState(() {
          username = name;
        });
        print('name: $name');
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void getImage() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/users/get?token=${widget.token}';
      var res = await http.get(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      if (jsonResponse.containsKey('data')) {
        Map<String, dynamic> data = jsonResponse['data'];
        String profileData = data['image'];
        setState(() {
          profile = profileData;
        });
        print('profile: $profileData');
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  int _selectedPage = 0;

  void navigateToPlan2() {
    setState(() {
      _selectedPlanPage = 2;
    });
  }

  void navigateToPlan1() {
    setState(() {
      _selectedPlanPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // Show LoginPage
      );
    } else {
      final _pageOptions = [
        HomePage(
          token: widget.token,
          name: username,
        ),
        stat(
          token: widget.token,
        ),
        if (_selectedPlanPage == 2)
          Plan2Page(navigateToPlan1, widget.token)
        else
          Plan1Page(navigateToPlan2, widget.token),
        GoalPage(
          token: widget.token,
        ),
      ];
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFE2D2),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  token: widget.token,
                                  onCallback: () => {getImage(), getUser()},
                                )),
                      );
                    },
                    child: ClipOval(
                      child: Image.asset(
                        (profile == '')
                            ? 'assets/non-profile.jpg'
                            : 'assets/$profile',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: _pageOptions[_selectedPage],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedPage,
              backgroundColor: const Color(0xFFEDB59E),
              iconSize: 24, // Adjust icon size
              selectedFontSize: 14, // Adjust selected font size
              unselectedFontSize: 14, // Adjust unselected font size
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF95491E),
              unselectedItemColor: Colors.white,
              onTap: (int index) {
                setState(() {
                  _selectedPage = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.leaderboard), label: 'Stat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books), label: 'Plan'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events), label: 'Goal'),
              ],
            ),
          ),
        ),
      );
    }
  }
}
