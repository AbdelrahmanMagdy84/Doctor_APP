import 'package:doctor_app/drawer/main_drawer.dart';
import 'package:doctor_app/models/Responses/PatientsResponse.dart';
import 'package:doctor_app/models/Patient.dart';
import 'package:doctor_app/patient/patient_profile_screen.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';

class PatientsScreen extends StatefulWidget {
  static final routeName = 'patient route name';

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String screenTitle;
  final usernameController = TextEditingController();

    List<Patient> patientList;
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
          .getFacilityPatientService()
          .getPatients(_doctorToken)
          .then((PatientsResponse responseList) {
        if (responseList.success) {
          //  DialogManager.stopLoadingDialog(context);
          patientList = responseList.patients;
          patientList=patientList.reversed.toList();
          print(responseList.patients.length);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients"),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: Container(
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
                  return patientList == null
                      ? Center(child: Text("no patients"))
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return item(
                                "${patientList[index].firstName} ${patientList[index].lastName}",
                                patientList[index].username,
                                patientList[index],
                                context);
                          },
                          itemCount: patientList.length,
                        );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget item(
    String name, String username, Patient patient, BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            PatientProfileScreen.routeName,
            arguments: {"patient": patient},
          );
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height * 0.22,
            child: Container(
              child: Card(
                elevation: 4,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth * 0.8,
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Name: $name',
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Username: $username ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    },
  );
}
