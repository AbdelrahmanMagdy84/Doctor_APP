import 'package:doctor_app/drawer/main_drawer.dart';
import 'package:doctor_app/items/pressure_item.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:doctor_app/models/BloodPressure.dart';
import 'package:doctor_app/models/Responses/BloodPressureResponseList.dart';
import 'package:doctor_app/models/Patient.dart';
import 'package:doctor_app/patient/twoLinesChart.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

class BloodPressureScreen extends StatefulWidget {
  static final String routeName = "pressure route name";
  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  List<BloodPressure> pressureList;
  Future userFuture;
  Patient patient;
  @override
  didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    patient = routeArgs['patient'];
    super.didChangeDependencies();
  }

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
          .getBloodPressureService()
          .getBloodPressureMeasure(patient.pid, _doctorToken)
          .then((BloodPressureResponseList responseList) {
        if (responseList.success) {
          //  DialogManager.stopLoadingDialog(context);
          pressureList = responseList.bloodPressure;
          print(responseList.bloodPressure.length);
        }
      });
    });
  }

  List<charts.Series<TimeSeriesSales, DateTime>> createTimeSeries(
      List<BloodPressure> x) {
    List<TimeSeriesSales> outputUpper = new List<TimeSeriesSales>();
    List<TimeSeriesSales> outputLower = new List<TimeSeriesSales>();
    x.forEach((element) {
      TimeSeriesSales upper =
          TimeSeriesSales(timeCurrent: element.date, sales: element.upper);
      TimeSeriesSales lower =
          TimeSeriesSales(timeCurrent: element.date, sales: element.lower);
      outputUpper.add(upper);
      outputLower.add(lower);
    });
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: outputUpper,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.timeCurrent,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: outputLower,
      ),

      // Optional radius for the annotation shape. If not specified, this will
      // default to the same radius as the points.
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
            "Blood Pressure",
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
                  if (pressureList == null) {
                    return Center(
                      child: Text("Empty"),
                    );
                  } else {
                    pressureList = pressureList.reversed.toList();
                    return TabBarView(
                      children: [
                        ListView.builder(
                          itemBuilder: (ctx, index) {
                            return PressureItem(pressureList[index]);
                          },
                          itemCount: pressureList.length,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 500,
                              width: 400,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Upper",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        Text("Lower",
                                            style: TextStyle(color: Colors.red))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                                                      child: Scaffold(
                                      body: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: double.infinity,
                                              child:
                                                  TimeSeriesSymbolAnnotationChart(
                                                createTimeSeries(pressureList),
                                                animate: true,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
