
import 'package:doctor_app/items/pressure_item.dart';
import 'package:doctor_app/models/BloodPressure.dart';
import 'package:doctor_app/models/Responses/BloodPressureResponseList.dart';
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
  @override
  void initState() {
    super.initState();
    print("getting user token");
    getUserToken();
  }

  String _patientToken;
  void getUserToken() {
    TokenStorage().getUserToken().then((value) async {
      setState(() {
        _patientToken = value;
      });
      userFuture = APIClient()
          .getBloodPressureService()
          .getBloodPressureMeasure(_patientToken)
          .then((BloodPressureResponseList responseList) {
        if (responseList.success) {
          //  DialogManager.stopLoadingDialog(context);
          pressureList = responseList.bloodPressure;
          print(responseList.bloodPressure.length);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blood Pressure",
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
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    return PressureItem(pressureList[index]);
                  },
                  itemCount: pressureList.length,
                );
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
// void getPressureList() {
//   // DialogManager.showLoadingDialog(context);
//   APIClient()
//       .getBloodPressureService()
//       .getBloodPressureMeasure(_patientToken)
//       .then((BloodPressureResponseList responseList) {
//     if (responseList.success) {
//       //  DialogManager.stopLoadingDialog(context);
//       pressureList = responseList.bloodPressure;
//       print(responseList.bloodPressure.length);
//     }
//   }).catchError((Object e) {
//     DialogManager.stopLoadingDialog(context);
//     DialogManager.showErrorDialog(context, "Couldn't get measures");
//     print(e.toString());
//   });
// }
