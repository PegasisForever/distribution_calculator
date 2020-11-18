import 'package:distribution_calculator/binomial_tab.dart';
import 'package:distribution_calculator/hypergeometric_tab.dart';
import 'package:distribution_calculator/p_and_c_tab.dart';
import 'package:distribution_calculator/uniform_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distribution Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Material(
            color: Colors.teal,
            elevation: 4,
            child: SafeArea(
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "P and C"),
                  Tab(text: "Uniform"),
                  Tab(text: "Binomial"),
                  Tab(text: "Hypergeometric"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PAndCTab(),
            UniformTab(),
            BinomialTab(),
            HypergeometricTab(),
          ],
        ),
      ),
    );
  }
}
