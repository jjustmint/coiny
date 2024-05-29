import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/addDialogCategory.dart';

class addCategory extends StatelessWidget {
  final token;
  const addCategory({super.key, required this.token, required this.reloadData});
  final Function reloadData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AddCategoryDialog(
                    token: token,
                    reloadData: reloadData,
                  ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEDB59E),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
