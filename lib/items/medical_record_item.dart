import 'package:doctor_app/models/MedicalRecord.dart';
import 'package:doctor_app/screens/show_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalRecordItem extends StatefulWidget {
  final MedicalRecord medicalRecord;
  MedicalRecordItem(this.medicalRecord);
  @override
  _MedicalRecordItemState createState() => _MedicalRecordItemState();
}

class _MedicalRecordItemState extends State<MedicalRecordItem> {
  String text = '';
  String subject = '';

  @override
  Widget build(BuildContext context) {
    final MedicalRecord newMedicalRecord = widget.medicalRecord;

    String facility;
    String doctor;
    String clerk;
    String image;
    print(newMedicalRecord.enteredBy);
    if (newMedicalRecord.enteredBy == "PATIENT") {
      facility = "facility";
      doctor = "doctor";
      clerk = "clerk";
    } else {
      if (newMedicalRecord.medicalFacility != null) {
        facility = newMedicalRecord.medicalFacility.name;
      }
      if (newMedicalRecord.clerk != null) {
        clerk =
            "${newMedicalRecord.clerk.firstName} ${newMedicalRecord.clerk.lastName}";
      }
      if (newMedicalRecord.doctor != null) {
        doctor =
            "${newMedicalRecord.doctor.firstName} ${newMedicalRecord.doctor.lastName}";
      }
    }
    if (newMedicalRecord.type == "Radiograph") {
      image = newMedicalRecord.radiograph.url;
    } else if (newMedicalRecord.type == "Prescription") {
      image = newMedicalRecord.prescription.url;
    } else {
      image = newMedicalRecord.report.url;
    }

    String title = newMedicalRecord.title;
    String note = newMedicalRecord.note;
    DateTime date = newMedicalRecord.date;

    return Container(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: FittedBox(
                      child: Text(
                "Title: $title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))),
              Divider(),
              if (facility != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Text("Facility: $facility"),
                    ),
                    Divider(),
                  ],
                )
              else
                Container(),
              if (doctor != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(child: Text("Doctor: DR.$doctor")),
                    Divider(),
                  ],
                )
              else
                Container(),
              if (clerk != null)
                FittedBox(child: Text("Clerk: $clerk"))
              else
                Container(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(ShowImageScreen.routeName, arguments: {
                      'image': image,
                    }),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.network(
                          image,
                          fit: BoxFit.fitWidth,
                          height: 100,
                          width: 80,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 230,
                    child: Text(
                      "Note: $note",
                      maxLines: 10,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: <Widget>[
                        Text(DateFormat.yMMMd().format(date)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
