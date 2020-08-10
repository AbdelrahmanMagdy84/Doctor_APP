import 'package:doctor_app/items/medical_record_item.dart';
import 'package:doctor_app/models/MedicalRecord.dart';
import 'package:doctor_app/models/Responses/MedicalRecordsResponse.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

class LabTestScreen extends StatefulWidget {
  static final routeName = 'labTest route name';
  @override
  _LabTestScreenState createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {
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
          .getMedicalRecords(_patientToken, "labTest")
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
      appBar: AppBar(title: Text("Lab Test")),
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
                  medicalRecords=medicalRecords.reversed.toList();
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    return MedicalRecordItem(medicalRecords[index]);
                  },
                  itemCount: medicalRecords.length,
                );}
                break;
            }
          },
        ),
      ),
     
    );
  }
}
