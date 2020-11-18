import 'dart:async';

import 'package:catex/catex.dart';
import 'package:decimal/decimal.dart';
import 'package:distribution_calculator/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HypergeometricTab extends StatefulWidget {
  @override
  _HypergeometricTabState createState() => _HypergeometricTabState();
}

class _HypergeometricTabState extends State<HypergeometricTab>
    with AutomaticKeepAliveClientMixin {
  List<_TableRowData> data;
  String nStr = "";
  String rStr = "";
  String aStr = "";
  String exp;
  bool isValid = false;
  Timer timer;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(fontSize: 20),
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text("size of the population  n="),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          onChanged: (str) {
                            nStr = str;
                            _startCalculationTimer();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("number of successful items available  a="),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          onChanged: (str) {
                            aStr = str;
                            _startCalculationTimer();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("number of trials  r="),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          onChanged: (str) {
                            rStr = str;
                            _startCalculationTimer();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 100),
              if (!isValid)
                Text(
                  "Invalid input",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          SizedBox(height: 32),
          if (data != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("expectation  "),
                          CaTeX(exp),
                        ],
                      ),
                      SizedBox(height: 32),
                      Table(
                        columnWidths: {
                          0: FixedColumnWidth(50),
                          1: FixedColumnWidth(400),
                          2: FixedColumnWidth(270),
                        },
                        border: TableBorder(
                          horizontalInside: BorderSide(color: Colors.black38),
                          bottom: BorderSide(color: Colors.black38),
                        ),
                        children: [
                          TableRow(children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX("x"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX(
                                    "P(x) = \\frac{_{a}C_{x} \\cdot _{n-a}C_{r-x}}{_{n}C_{r}}"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX("x \\cdot P(x)"),
                              ),
                            ),
                          ]),
                        ]..addAll(data.map((data) => TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: CaTeX(data.x.toString()),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: CaTeX(data.px),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: CaTeX(data.xpx),
                                  ),
                                ),
                              ],
                            ))),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: SizedBox(width: 32),
                ),
                Flexible(
                  child: SizedBox(
                    height: 500,
                    child: SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        header: '',
                        format: "P(X=point.x) = point.y",
                        canShowMarker: false,
                      ),
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: "x"),
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: "P(X=x)"),
                        labelFormat: '{value}',
                        maximum: 1,
                      ),
                      series: <ColumnSeries<_TableRowData, int>>[
                        ColumnSeries<_TableRowData, int>(
                          animationDuration: 300,
                          dataSource: data,
                          xValueMapper: (data, _) => data.x,
                          yValueMapper: (data, _) => data.pxValue.toDouble(),
                          enableTooltip: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _startCalculationTimer() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }

    timer = Timer(Duration(milliseconds: 500), _calculate);
  }

  void _calculate() {
    var nInt = int.tryParse(nStr);
    var rInt = int.tryParse(rStr);
    var aInt = int.tryParse(aStr);
    if (nInt == null ||
        nInt <= 0 ||
        rInt == null ||
        rInt > nInt ||
        aInt == null ||
        aInt > nInt) {
      setState(() {
        isValid = false;
      });
      return;
    }
    var n = Decimal.fromInt(nInt);
    var r = Decimal.fromInt(rInt);
    var a = Decimal.fromInt(aInt);

    data = [];
    for (Decimal x = Decimal.zero; x <= r; x += Decimal.one) {
      var top = combine(a, x) * combine(n - a, r - x);
      var bottom = combine(n, r);
      var pxValue = top / bottom;
      data.add(_TableRowData(
        x: x.toInt(),
        px: "\\frac{_{$a}C_{$x} \\cdot _{$n-$a}C_{$r-$x}}{_{$n}C_{$r}} = \\frac{$top}{$bottom} = ${pxValue.toStringAsFixed(5)}",
        pxValue: pxValue,
        xpx:
            "$x \\cdot ${pxValue.toStringAsFixed(5)} = ${(pxValue * x).toStringAsFixed(5)}",
      ));
    }
    setState(() {
      exp =
          "E(X) = \\frac{r \\cdot a}{n} = \\frac{$r \\cdot $a}{$n} = ${(r * a / n).toStringAsFixed(5)}";
      isValid = true;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _TableRowData {
  final int x;
  final String px;
  final Decimal pxValue;
  final String xpx;

  _TableRowData({
    this.x,
    this.px,
    this.pxValue,
    this.xpx,
  });
}
