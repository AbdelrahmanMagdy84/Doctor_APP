import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import 'line_chart.dart';


class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:  Container(
        height: 500,
        width: double.infinity,
        child: SimpleTimeSeriesChart([],)
        
      ),
    );
  }
}