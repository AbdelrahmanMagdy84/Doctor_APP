import 'package:doctor_app/models/MedicalRecord.dart';
import 'package:doctor_app/screens/show_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String enteredBy;
    String fileName;
    if (newMedicalRecord.enteredBy == "PATIENT") {
      enteredBy = "Patient";
    } else if (newMedicalRecord.enteredBy == "CLERK") {
      enteredBy = "Clerk";
      facility = newMedicalRecord.medicalFacility.name;
      doctor =
          "${newMedicalRecord.doctor.firstName} ${newMedicalRecord.doctor.lastName}";
      clerk =
          "${newMedicalRecord.clerk.firstName} ${newMedicalRecord.clerk.lastName}";
    }
    if (newMedicalRecord.type == "Radiograph") {
      image = newMedicalRecord.radiograph.url;
      fileName = newMedicalRecord.radiograph.fileName;
    } else if (newMedicalRecord.type == "Prescription") {
      image = newMedicalRecord.prescription.url;
      fileName = newMedicalRecord.prescription.fileName;
    } else {
      image = newMedicalRecord.report.url;
      fileName = newMedicalRecord.report.fileName;
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
                    onTap: () {
                      if (getFileType(fileName) != 'image') {
                        _launchURL(image);
                      } else {
                        Navigator.of(context).pushNamed(
                            ShowImageScreen.routeName,
                            arguments: {'image': image});
                      }
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: getFileType(fileName) != 'image'
                            ? Image.asset(
                                'assets/images/file.png',
                                fit: BoxFit.fitWidth,
                                height: 100,
                                width: 80,
                              )
                            : Image.network(
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

  String getFileType(String input) {
    String mimeStr = lookupMimeType(input);
    var fileType = mimeStr.split('/');
    return fileType[0];
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
