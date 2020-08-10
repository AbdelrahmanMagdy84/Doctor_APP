import 'package:doctor_app/patient/patients_screen.dart';
import 'package:doctor_app/screens/facility_screen.dart';
import 'package:doctor_app/patient/patient_profile_screen.dart';
import '../drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          children: <Widget>[
            TopContainer(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 10 / 4,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                  mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
                  children: <Widget>[
                    builditem(context, "Facilities", 1),
                    builditem(context, "Patients", 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builditem(BuildContext context, String title, int id) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return InkWell(
          onTap: () => selectCategory(context, id),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: Center(
              child: Expanded(
                child: Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.6),
                  Theme.of(context).primaryColor
                ], //here you can change the color
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
    );
  }
}

void selectCategory(BuildContext ctx, int id) {
  switch (id) {
    case 1:
      Navigator.of(ctx).pushNamed(FacilityScreen.routeName);
      break;
    case 2:
      Navigator.of(ctx).pushNamed(PatientsScreen.routeName);
      break;
  }
}

class TopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(50, 27),
            bottomRight: Radius.elliptical(50, 27),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey[400],
              offset: Offset(0, 3.5),
            )
          ],
          color: Theme.of(context).primaryColor),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 50,
            ),
            child: Text(
              "AMUN MR",
              style: TextStyle(
                fontFamily: "Angel",
                fontSize: 64,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
