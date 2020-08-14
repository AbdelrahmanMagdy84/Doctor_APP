import 'package:doctor_app/items/category_item.dart';
import 'package:doctor_app/models/Responses/PatientResponse.dart';
import 'package:doctor_app/models/Patient.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/static_data/medical_categories_data.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  static const routeName = 'patient_profile';
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Patient patient;
  Future userFuture;
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
          .getPatientService()
          .getPatient(patient.pid,_doctorToken)
          .then((PatientResponse response) {
        if (response.success) {
          //  DialogManager.stopLoadingDialog(context);
          patient = response.patient;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Profile"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                Icons.camera_alt,
              ),
              onPressed: () {
                //   Navigator.of(context).pushNamed(ScannerScreen.routeName);
              })
        ],
      ),
      drawer: MainDrawer(),
      drawerScrimColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(child: buildPatientProfile(patient)),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 30, left: 20, right: 20),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 1,
                              crossAxisSpacing:
                                  MediaQuery.of(context).size.width * 0.05,
                              mainAxisSpacing:
                                  MediaQuery.of(context).size.height * 0.05,
                              children: <Widget>[
                                ...categories
                                    .map(
                                      (cat) => CategoryItem(
                                          cat.id, cat.title, patient),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildPatientProfile(Patient patientForProfile) {
     Future<void> _launched;
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            color: Colors.white54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  //margin: EdgeInsets.only(top:20),
                  child: Container(
                      margin: EdgeInsets.only(top: 15, left: 15),
                      child: buildMyText(context, "Name",
                          "${patient.firstName} ${patient.lastName}")),
                ),
                Divider(),
                Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: buildMyText(context, "Username", patient.username)),
                Divider(),
                Container(
                    margin: EdgeInsets.only(
                      left: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: buildMyText(context, "Email", patient.email)),
                Divider(),
                Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: buildMyText(context, "Birth Date",
                        "${DateFormat.yMd().format(patient.birthDate)}")),
                Divider(),
                Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child:
                        buildMyText(context, "Blood Type", patient.bloodType)),
                Divider(),
                Container(
                    margin: EdgeInsets.only(left: 15, bottom: 15),
                    alignment: Alignment.centerLeft,
                    child: buildMyText(context, "Gender", patient.gender)),
                Divider(
                  thickness: 1,
                ),
                Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.email,
                      color: Colors.redAccent,
                    ),
                      onPressed: () => setState(() {
                      _launched = _createEmail(patient.email);
                    }),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onPressed: () => setState(() {
                      _launched = _makePhoneCall('tel:${patient.mobile}');
                    }),
                  ),
                ),
                FutureBuilder<void>(future: _launched, builder: _launchStatus),
              ],
            )
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }
  Future<void> _createEmail(String email) async {
    if (await canLaunch("mailto:$email?subject=Amun MR")) {
      await launch("mailto:$email?subject=Amun MR");
    } else {
      throw 'Could not Email';
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildMyText(BuildContext ctx, String title, String value) {
    return Container(
        child: Row(
      children: <Widget>[
        Text("$title: ",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Theme.of(ctx).accentColor)),
        Text(value == null ? "" : "$value",
            style: TextStyle(
              fontSize: 16,
            )),
      ],
    ));
  }
}
