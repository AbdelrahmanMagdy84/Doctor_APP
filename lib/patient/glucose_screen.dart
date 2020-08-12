import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:doctor_app/drawer/main_drawer.dart';
import 'package:doctor_app/items/glucose_item.dart';
import 'package:doctor_app/models/BloodGlucose.dart';
import 'package:doctor_app/models/Responses/BloodGlucoseResponseList.dart';
import 'package:doctor_app/models/Patient.dart';

import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

import 'line_chart.dart';

class BloodGlucoseScreen extends StatefulWidget {
  static final String routeName = "glucose route name";
  @override
  _BloodGlucoseScreenState createState() => _BloodGlucoseScreenState();
}

class _BloodGlucoseScreenState extends State<BloodGlucoseScreen> {
  List<BloodGlucose> glucoseList;
  Patient patient;
  @override
  didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    patient = routeArgs['patient'];
    super.didChangeDependencies();
  }

  Future userFuture;
  @override
  void initState() {
    super.initState();
    print("getting user token");
    getUserToken();
  }

  String _doctorToken;
  void getUserToken() {
    TokenStorage().getUserToken().then((value) async {
      setState(() {
        _doctorToken = value;
      });
      userFuture = APIClient()
          .getBloodGlucoseService()
          .getBloodGlucoseMeasure(patient.pid, _doctorToken)
          .then((BloodGlucoseResponseList responseList) {
        if (responseList.success) {
          glucoseList = responseList.bloodGlucose;
        }
      });
    });
  }

  List<charts.Series<TimeSeriesSalesSingleLine, DateTime>> createTimeSeries(
      List<BloodGlucose> x) {
    List<TimeSeriesSalesSingleLine> output =
        new List<TimeSeriesSalesSingleLine>();
    x.forEach((element) {
      TimeSeriesSalesSingleLine temp =
          new TimeSeriesSalesSingleLine(element.date, element.value);
      output.add(temp);
    });
    return [
      new charts.Series<TimeSeriesSalesSingleLine, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSalesSingleLine sales, _) => sales.time,
        measureFn: (TimeSeriesSalesSingleLine sales, _) => sales.sales,
        data: output,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
         drawer: MainDrawer(),
        appBar: AppBar(
          title: Text(
            "Blood Glucose",
            style: Theme.of(context).textTheme.title,
          ),
          bottom: TabBar(tabs: [
            Tab(
              child: Icon(
                Icons.list,
                color: Theme.of(context).accentColor,
              ),
            ),
            Tab(
              child: Icon(
                Icons.show_chart,
                color: Theme.of(context).accentColor,
              ),
            )
          ]),
        ),
        body: Container(
          child: FutureBuilder(
            future: userFuture,
            builder: (ctx, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("none");
                  break;
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Loading ",
                    style: Theme.of(context).textTheme.title,
                  ));
                  break;
                case ConnectionState.done:
                  if (glucoseList == null) {
                    return Center(
                      child: Text("Empty"),
                    );
                  } else {
                    glucoseList = glucoseList.reversed.toList();
                    return TabBarView(
                      children: [
                        ListView.builder(
                          itemBuilder: (ctx, index) {
                            return GlucoseItem(glucoseList[index]);
                          },
                          itemCount: glucoseList.length,
                        ),
                        Scaffold(
                          body: Container(
                            height: MediaQuery.of(context).size.height * .5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: double.infinity,
                                  child: SimpleTimeSeriesChart(
                                      createTimeSeries(glucoseList))),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
