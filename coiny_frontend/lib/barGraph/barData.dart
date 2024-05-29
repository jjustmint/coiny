// ignore_for_file: non_constant_identifier_names

import 'package:coiny_frontend/barGraph/individualBar.dart';

class BarData {
  final double Saved;
  final double UsableMoney;
  final double Used;

  BarData({
    required this.Saved,
    required this.UsableMoney,
    required this.Used,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      //Saved
      IndividualBar(x: 0, y: Saved),
      //UsableMoney
      IndividualBar(x: 1, y: UsableMoney),
      //Used
      IndividualBar(x: 2, y: Used),
    ];
  }
}
