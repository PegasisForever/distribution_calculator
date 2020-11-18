import 'package:distribution_calculator/c_calculator.dart';
import 'package:distribution_calculator/p_calculator.dart';
import 'package:flutter/material.dart';

class PAndCTab extends StatefulWidget {
  @override
  _PAndCTabState createState() => _PAndCTabState();
}

class _PAndCTabState extends State<PAndCTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        PCalculator(),
        SizedBox(height: 32),
        CCalculator(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
