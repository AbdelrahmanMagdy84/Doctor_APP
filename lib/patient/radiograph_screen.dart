
import 'package:doctor_app/items/medical_record_item.dart';
import 'package:doctor_app/models/MedicalRecord.dart';
import 'package:doctor_app/models/Responses/MedicalRecordsResponse.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

class RadiographScreen extends StatefulWidget {
  static final routeName = 'radiograph route name';
  @override
  _RadiographScreenState createState() => _RadiographScreenState();
}

class _RadiographScreenState extends State<RadiographScreen> {
  Future userFuture;
  List<MedicalRecord> medicalRecords;
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
          .getMedicalRecordService()
          .getMedicalRecords(_patientToken, "Radiograph")
          .then((MedicalRecordsResponse responseList) {
        if (responseList.success) {
          print(responseList.medicalRecord);
          medicalRecords = responseList.medicalRecord;
        }
      });
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radiograph")),
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
                  if (medicalRecords == null) {
                  return Center(
                    child: Text("Empty Press + to add"),
                  );
                } else {
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    medicalRecords=medicalRecords.reversed.toList();
                    return MedicalRecordItem(medicalRecords[index]);
                  },
                  itemCount: medicalRecords.length,
                );}
                break;
            }
          },
        ),
        // child: ListView.builder(
        //   itemBuilder: (ctx, index) {
        //     return MedicalRecordItem();
        //   },
        //   itemCount: 1,
        // ),
      ),
     
    );
  }
}
