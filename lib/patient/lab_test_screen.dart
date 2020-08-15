import 'package:doctor_app/drawer/main_drawer.dart';
import 'package:doctor_app/items/medical_record_item.dart';
import 'package:doctor_app/models/MedicalRecord.dart';
import 'package:doctor_app/models/Responses/MedicalRecordsResponse.dart';
import 'package:doctor_app/models/Patient.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/static_data/three_dots.dart';
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
  List<MedicalRecord> orginList;
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
          .getMedicalRecordService()
          .getMedicalRecords(_doctorToken, patient.pid, "report")
          .then((MedicalRecordsResponse responseList) {
        if (responseList.success) {
          orginList = responseList.medicalRecord;
          medicalRecords = List.from(orginList.reversed.toList());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Lab Test"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: clickHandle,
            itemBuilder: (BuildContext context) {
              return list.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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
                if (medicalRecords == null) {
                  return Center(
                    child: Text("Empty Press + to add"),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return MedicalRecordItem(medicalRecords[index]);
                    },
                    itemCount: medicalRecords.length,
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }

  void clickHandle(value) {
    List<MedicalRecord> copyList = List.from(orginList);
    if (value == "Recent") {
      setState(() {
        medicalRecords = copyList.reversed.toList();
      });
    } else if (value == "History") {
      setState(() {
        medicalRecords = copyList.toList();
        medicalRecords.sort((a, b) => a.date.compareTo(b.date));
      });
    } else if (value == "entered by patient") {
      print("---------------------------------");
      setState(() {
        medicalRecords = copyList
            .where((element) => element.enteredBy == "PATIENT")
            .toList();
        print(medicalRecords.length);
      });
    } else if (value == "entered by clerk") {
      setState(() {
        medicalRecords = copyList.reversed.toList();
        medicalRecords = copyList
            .where((element) => element.enteredBy != "PATIENT")
            .toList();
        print(medicalRecords.length);
      });
    }
  }
}
