import 'dart:async';

import 'package:catex/catex.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UniformTab extends StatefulWidget {
  @override
  _UniformTabState createState() => _UniformTabState();
}

class _UniformTabState extends State<UniformTab>
    with AutomaticKeepAliveClientMixin {
  List<_TableRowData> data;
  String nStr;
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
              Text("number of items  n="),
              SizedBox(
                width: 100,
                child: TextField(
                  onChanged: (str) {
                    nStr = str;
                    _startCalculationTimer();
                  },
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.all(4),
                  ),
                ),
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
                          1: FixedColumnWidth(180),
                          2: FixedColumnWidth(260),
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
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX("x"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                              TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX("P(x) = \\frac{1}{n}"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                              TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: CaTeX("x \\times P(x)"),
                              ),
                            ),
                          ]),
                        ]..addAll(data.map((data) => TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: CaTeX(data.x.toString()),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: CaTeX(data.px),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
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
    if (nInt == null || nInt <= 0) {
      setState(() {
        isValid = false;
      });
      return;
    }
    var n = Decimal.fromInt(nInt);

    data = [];
    for (Decimal x = Decimal.one; x <= n; x += Decimal.one) {
      var pxValue = Decimal.one / n;
      data.add(_TableRowData(
        x: x.toInt(),
        px: "\\frac{1}{$n} = ${pxValue.toStringAsFixed(5)}",
        pxValue: pxValue,
        xpx:
            "$x \\times ${pxValue.toStringAsFixed(5)} = ${(pxValue * x).toStringAsFixed(5)}",
      ));
    }
    setState(() {
      exp =
          "E(X) = \\frac{n+1}{2} = \\frac{$n+1}{2} = ${((n + Decimal.one) / Decimal.fromInt(2)).toStringAsFixed(5)}";
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
