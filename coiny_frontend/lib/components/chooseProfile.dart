import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePictureDialog extends StatefulWidget {
  final token;
  final Function() onCallback;
  ProfilePictureDialog(
      {Key? key, required this.token, required this.onCallback})
      : super(key: key);
  @override
  _ProfilePictureDialogState createState() => _ProfilePictureDialogState();
}

class _ProfilePictureDialogState extends State<ProfilePictureDialog> {
  int selectedIndex = -1; // Initially no picture selected
  String ProfileSelect = '';

  final List<String> profilePictures = [
    'bear.jpg',
    'cat.jpg',
    'chick.jpg',
    'dog.jpg',
    'squirrel.jpg',
    'lion.jpg',
  ];

  @override
  void initState() {
    super.initState();
    getUser();
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
        String image = data['image'];
        setState(() {
          ProfileSelect = image;
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void onSave() async {
    try {
      final apiURL = 'http://10.0.2.2:4000/users/edit/profile';
      final response = await http.patch(
        Uri.parse(apiURL),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "token": widget.token,
          "image": ProfileSelect,
        }),
      );
      if (response.statusCode == 200) {
        print('profile updated');
        widget.onCallback();
        Navigator.pop(context); // Close the dialog
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFFEDB59E),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Choose your profile picture",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1, // Ensure each grid item is a square
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: profilePictures.length,
            itemBuilder: (BuildContext context, int index) {
              // Load profile picture from assets
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index; // Update selected index
                    ProfileSelect = profilePictures[index];
                    print(ProfileSelect);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedIndex == index
                          ? Color(0xFF95491E)
                          : Colors.transparent,
                      width: 4.0,
                    ),
                    borderRadius:
                        BorderRadius.circular(70), // Half of avatar radius
                  ),
                  child: CircleAvatar(
                    radius: 35, // 70 / 2
                    backgroundImage:
                        AssetImage('assets/${profilePictures[index]}'),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog on cancel
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFF5CCB4)), // background color
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF95491E)), // text color
                ),
                child: Text("Cancel"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedIndex != -1) {
                    print("Selected profile picture index: $selectedIndex");
                  } else {
                    print("No profile picture selected");
                  }
                  onSave();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF95491E)), // background color
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFF5CCB4)), // text color
                ),
                child: Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
