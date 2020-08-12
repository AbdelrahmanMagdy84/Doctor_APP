/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  static final routeName = "line chart";
  final List<charts.Series<TimeSeriesSalesSingleLine, DateTime>> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new charts.TimeSeriesChart(
        seriesList,
        animate: true,
      ),
    );
  }  
}
/// Sample time series data type.
class TimeSeriesSalesSingleLine {
  final DateTime time;
  final int sales;
  TimeSeriesSalesSingleLine(this.time, this.sales);
}
