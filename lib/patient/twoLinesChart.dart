import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class TimeSeriesSymbolAnnotationChart extends StatelessWidget {
  final  List<Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;

  TimeSeriesSymbolAnnotationChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      customSeriesRenderers: [
        new charts.SymbolAnnotationRendererConfig(
            customRendererId: 'customSymbolAnnotation')
      ],    
    );
  }
}
class TimeSeriesSales {
  final DateTime timeCurrent;
  final DateTime timePrevious;
  final DateTime timeTarget;
  final int sales;

  TimeSeriesSales(
      {this.timeCurrent, this.timePrevious, this.timeTarget, this.sales});
}