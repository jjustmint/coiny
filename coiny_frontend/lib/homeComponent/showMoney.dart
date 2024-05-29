import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class showMoney extends StatefulWidget {
  const showMoney(
      {super.key, required this.usableMoney, required this.dailyExpense});
  final double usableMoney;
  final double dailyExpense;

  @override
  State<showMoney> createState() => _showMoneyState();
}

class _showMoneyState extends State<showMoney> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32.0, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Your profile content here
          Row(
            children: [
              Text(
                "Usable Money :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                " ${widget.usableMoney.toStringAsFixed(2)} ฿",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Daily Expenses :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                " ${widget.dailyExpense.toStringAsFixed(2)} ฿",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
