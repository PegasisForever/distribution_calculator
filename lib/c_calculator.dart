import 'package:catex/catex.dart';
import 'package:distribution_calculator/utils.dart';
import 'package:flutter/material.dart';

class CCalculator extends StatefulWidget {
  @override
  _CCalculatorState createState() => _CCalculatorState();
}

class _CCalculatorState extends State<CCalculator> {
  String latex = "";
  String result = "";
  String nStr = "";
  String rStr = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 30,
          child: TextField(
            onChanged: (str) {
              nStr = str;
              _calculate();
            },
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(4),
            ),
          ),
        ),
        Text(
          "C",
          style: TextStyle(fontSize: 40),
        ),
        SizedBox(
          width: 30,
          child: TextField(
            onChanged: (str) {
              rStr = str;
              _calculate();
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(4),
            ),
          ),
        ),
        Text(
          " = ",
          style: TextStyle(fontSize: 40),
        ),
        if (latex != "")
          IgnorePointer(
            child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 19),
              child: CaTeX(latex),
            ),
          ),
        if (result != "")
          Text(
            " = $result",
            style: TextStyle(fontSize: 40),
          ),
      ],
    );
  }

  void _calculate() {
    var nNum = int.tryParse(nStr);
    var rNum = int.tryParse(rStr);
    if (nNum == null || nNum < 0 || rNum == null || rNum < 0 || rNum > nNum) {
      setState(() {
        latex = "";
        result = "";
      });
      return;
    }

    var nBig = BigInt.from(nNum);
    var rBig = BigInt.from(rNum);
    var p = factorio(nBig) ~/factorio(rBig) ~/ factorio(nBig - rBig);
    setState(() {
      latex = "\\frac{$nBig!}{$rBig!($nBig-$rBig)!}";
      result = p.toString();
    });
  }
}
