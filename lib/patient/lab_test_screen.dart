import 'package:flutter/material.dart';

class LabTestScreen extends StatefulWidget {
  static final routeName = 'labTest route name';
  @override
  _LabTestScreenState createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lab Test")),
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
