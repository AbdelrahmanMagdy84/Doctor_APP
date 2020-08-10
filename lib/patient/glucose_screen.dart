import 'package:doctor_app/items/glucose_item.dart';
import 'package:doctor_app/models/BloodGlucose.dart';
import 'package:doctor_app/models/Responses/BloodGlucoseResponseList.dart';
import 'package:doctor_app/models/Patient.dart';

import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

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
          .getBloodGlucoseMeasure(patient.pid,_doctorToken)
          .then((BloodGlucoseResponseList responseList) {
        if (responseList.success) {
          glucoseList = responseList.bloodGlucose;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blood Glucose",
          style: Theme.of(context).textTheme.title,
        ),
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
                    child: Text("Empty Press + to add"),
                  );
                } else {
                  glucoseList = glucoseList.reversed.toList();
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return GlucoseItem(glucoseList[index]);
                    },
                    itemCount: glucoseList.length,
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
/*------------------------------- */
/*add function */
// void getGlucoseList() {
//   // DialogManager.showLoadingDialog(context);
//   APIClient()
//       .getBloodGlucoseService()
//       .getBloodGlucoseMeasure(_patientToken)
//       .then((BloodGlucoseResponseList responseList) {
//     if (responseList.success) {
//       //  DialogManager.stopLoadingDialog(context);
//       glucoseList = responseList.bloodGlucose;
//       print("---------------------------");
//       print(responseList.bloodGlucose.length);
//       print("---------------------------");
//     }
//   }).catchError((Object e) {
//     print("---------------------------x");
//     DialogManager.stopLoadingDialog(context);
//     DialogManager.showErrorDialog(context, "Couldn't get measures");
//     print(e.toString());
//   });
// }
