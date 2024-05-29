import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class history extends StatefulWidget {
  const history({Key? key, required this.transactionData});
  final List<Map<String, dynamic>> transactionData;

  @override
  State<history> createState() => _HistoryState();
}

class _HistoryState extends State<history> {
  String _previousDate = '';

  @override
  Widget build(BuildContext context) {
    if (widget.transactionData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "History",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Icon(Icons.history),
                  ],
                ),
              ),
              const Text('No transaction history')
            ]),
      );
    }

    _previousDate = ''; // Reset _previousDate when rebuilding

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Icon(Icons.history),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: const Color(0xFFFFF3EC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: widget.transactionData.map((transaction) {
                String dateString = transaction['created'];
                String formattedDate = _formatDate(dateString);
                String categoryName = transaction['categories']['name'];
                double amount = transaction['amount'] is int
                    ? (transaction['amount'] as int).toDouble()
                    : transaction['amount'];

                bool showDate = formattedDate != _previousDate;
                _previousDate = formattedDate; // Update the previous date

                return Column(
                  children: [
                    if (showDate)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(formattedDate,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text("${amount.toStringAsFixed(2)} B")
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    List<String> dateParts = dateString.split('T')[0].split('-');
    String day = dateParts[2];
    String month;
    switch (dateParts[1]) {
      case '01':
        month = 'Jan';
        break;
      case '02':
        month = 'Feb';
        break;
      case '03':
        month = 'Mar';
        break;
      case '04':
        month = 'Apr';
        break;
      case '05':
        month = 'May';
        break;
      case '06':
        month = 'Jun';
        break;
      case '07':
        month = 'Jul';
        break;
      case '08':
        month = 'Aug';
        break;
      case '09':
        month = 'Sep';
        break;
      case '10':
        month = 'Oct';
        break;
      case '11':
        month = 'Nov';
        break;
      case '12':
        month = 'Dec';
        break;
      default:
        month = '';
    }
    String year = dateParts[0];
    return '$day $month $year';
  }
}
