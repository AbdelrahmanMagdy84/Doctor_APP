
import 'package:flutter/material.dart';

class RadiographScreen extends StatefulWidget {
  static final routeName = 'radiograph route name';
  @override
  _RadiographScreenState createState() => _RadiographScreenState();
}

class _RadiographScreenState extends State<RadiographScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radiograph")),
      body: Container(
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
