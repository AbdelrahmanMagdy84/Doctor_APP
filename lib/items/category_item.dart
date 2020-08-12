import 'package:doctor_app/models/Patient.dart';
import 'package:doctor_app/patient/allergies_screen.dart';
import 'package:doctor_app/patient/blood_pressure_screen.dart';
import 'package:doctor_app/patient/condtions_screen.dart';
import 'package:doctor_app/patient/glucose_screen.dart';
import 'package:doctor_app/patient/lab_test_screen.dart';
import 'package:doctor_app/patient/medications_screen.dart';
import 'package:doctor_app/patient/prescription_screen.dart';
import 'package:doctor_app/patient/radiograph_screen.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String id;
  final Patient patient;
  CategoryItem(this.id, this.title, this.patient);

  @override
  Widget build(BuildContext context) {
    
     return InkWell(
          onTap: () => selectCategory(context),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            alignment:Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                     alignment:Alignment.center,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
              ],
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
  }

  void selectCategory(BuildContext ctx) {
    switch (id) {
      case '1':
        Navigator.of(ctx).pushNamed(BloodGlucoseScreen.routeName, arguments: {"patient": patient});
        break;
      case '2':
        Navigator.of(ctx).pushNamed(BloodPressureScreen.routeName, arguments: {"patient": patient});
        break;
      case '3':
        Navigator.of(ctx).pushNamed(PrescriptionScreen.routeName, arguments: {"patient": patient});
        break;
      case '4':
        Navigator.of(ctx).pushNamed(RadiographScreen.routeName, arguments: {"patient": patient});
        break;
      case '5':
        Navigator.of(ctx).pushNamed(LabTestScreen.routeName, arguments: {"patient": patient});
        break;
      case '6':
        Navigator.of(ctx).pushNamed(AllergiesScreen.routeName,
            arguments: {"allergies": patient.allergies});
        break;
      case '7':
        Navigator.of(ctx).pushNamed(ConditionsScreen.routeName,
            arguments: {"conditions": patient.conditions});
        break;
      case '8':
        Navigator.of(ctx).pushNamed(MedicationsScreen.routeName,
            arguments: {"medications": patient.medications});
        break;
    }
  }
}
