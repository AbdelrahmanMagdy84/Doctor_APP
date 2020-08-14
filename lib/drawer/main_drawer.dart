
import 'package:doctor_app/models/Doctor.dart';
import 'package:doctor_app/models/Responses/DoctorResponse.dart';

import 'package:doctor_app/screens/home_screen.dart';
import 'package:doctor_app/services/APIClient.dart';
import 'package:doctor_app/utils/TokenStorage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {


  Doctor doctor;
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
          .getDoctorService()
          .getDoctor(_doctorToken)
          .then((DoctorResponse response) {
        if (response.success) {
          //  DialogManager.stopLoadingDialog(context);
          doctor = response.doctor;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: mediaQuery.height * 0.07),
          child: Column(
            children: <Widget>[
              
              Container(
                child: FutureBuilder(
                  future: userFuture,
                  builder: (ctx, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("none");
                        break;
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: mediaQuery.height * 0.25,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  //margin: EdgeInsets.only(top:20),
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: 15, left: 15),
                                      child: Text('')),
                                ),
                                Divider(),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text('')),
                                Divider(),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child:  Text('')),
                                Divider(),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 15, bottom: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text('')),
                              ],
                            ),
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: mediaQuery.height * 0.25,
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
                                      margin:
                                          EdgeInsets.only(top: 15, left: 15),
                                      child: buildMyText(context, "Name",
                                          "DR.${doctor.firstName} ${doctor.lastName}")),
                                ),
                                Divider(),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: buildMyText(
                                        context, "Username", doctor.username)),
                                Divider(),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: buildMyText(context, "Birth Date",
                                        "${DateFormat.yMd().format(doctor.birthDate)}")),
                                Divider(),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 15, bottom: 15),
                                    alignment: Alignment.centerLeft,
                                    child: buildMyText(context, "specialization",
                                        doctor.specialization)),
                              ],
                            ),
                          ),
                        );
                        break;
                    }
                  },
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.only(top:20),
                child: buildListTile(context, 'Home', () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (r) => false);
                }),
              ),
            
              


              Container(
                padding: EdgeInsets.only(top:50),
               // color: Theme.of(context).accentColor,
                child: buildListTile(context, 'Logout', () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext ctx, String title, Function tabHandler) {
    return ListTile(
      title: Card(
        elevation: 1,
        child: Center(
          heightFactor: 2,
          child: Text(
            title,
            style: TextStyle(
                fontFamily: 'RobotoCondenced',
                fontSize: 18,
                color: Theme.of(ctx).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: tabHandler,
    );
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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: <Widget>[
              Text("$value",
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}
