import 'package:doctor_app/models/Patient.dart';

import '../Patient.dart';

class PatientsResponse {
  bool success;
  List<Patient> patients;

  PatientsResponse({
    this.patients,
    this.success,
  });

  factory PatientsResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsed = json["facilitiesPatients"] != null
        ? json["facilitiesPatients"]
        : new List<dynamic>();
    List<dynamic> parsedPatients = [];

    for (final object in parsed) {
      parsedPatients.add(object["patient"]);
    }
    List<Patient> patients =
        parsedPatients.map((i) => Patient.fromJson(i)).toList();

    return PatientsResponse(success: json["success"], patients: patients);
  }
}
