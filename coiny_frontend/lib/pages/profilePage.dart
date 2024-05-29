import 'dart:convert';
import 'package:coiny_frontend/auth/login.dart';
import 'package:coiny_frontend/components/chooseProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String token;
  final Function() onCallback;
  ProfilePage({
    Key? key,
    required this.token,
    required this.onCallback,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      onCallback: widget.onCallback,
      token: widget.token,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final Function() onCallback;
  var token;

  ProfileScreen({
    required this.token,
    required this.onCallback,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String profile = '';

  @override
  void initState() {
    super.initState();
    getUser();
    getImage();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new name';
    } else {
      return null;
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
          nameController.text = name;
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

  void onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        final apiURL = 'http://10.0.2.2:4000/users/edit/name';
        final response = await http.patch(
          Uri.parse(apiURL),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            "token": widget.token,
            "name": nameController.text,
          }),
        );
        if (response.statusCode == 200) {
          print('Name updated');
          widget.onCallback();
          Navigator.pop(context); // Close the dialog
        }
      } catch (e) {
        print('ERROR: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE2D2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFE2D2),
          elevation: 0,
          flexibleSpace: Container(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.onCallback();
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width:
                        48), // This keeps space for the back button to balance the AppBar
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 90,
                    // You can replace the AssetImage with your profile image
                    backgroundImage: AssetImage((profile == '')
                        ? 'assets/non-profile.jpg'
                        : 'assets/$profile'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Colors.white, // Background color of the pencil icon
                      ),
                      padding:
                          EdgeInsets.all(5), // Padding around the pencil icon
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF95491E)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProfilePictureDialog(
                                  token: widget.token, onCallback: getImage);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled:
                          true, // Set to true to fill the background with white
                      fillColor:
                          Color(0xFFFFF3EC), // Set the fill color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none, // Remove the border
                      ),
                    ),
                    validator: validateName,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 150, // Adjust width as needed
                height: 35,
                child: ElevatedButton(
                  onPressed: onSave,
                  child: Text('Save'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFF5CCB4)), // Change background color
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF95491E)), // Change text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 150,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.token = '';
                    });
                    print('Logged out');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white), // Icon
                      SizedBox(
                          width: 5), // Add some space between icon and text
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFEB6363)), // Background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
