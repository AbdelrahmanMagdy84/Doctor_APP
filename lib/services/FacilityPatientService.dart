import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

import 'APIClient.dart';
import '../models/Responses/MedicalFacilitiesResponse.dart';
import '../models/Responses/PatientsResponse.dart';

class FacilityPatientService {
  static final String endPoint = "api/v1/facilities-patients";
  static final FacilityPatientService _instance =
      FacilityPatientService._getInstance();

  factory FacilityPatientService() {
    return _instance;
  }
  FacilityPatientService._getInstance();

  Future<MedicalFacilitiesResponse> getMedicalFacilities(String token) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint/medicalFacility",
        headers: {"Content-Type": "application/json", "authorization": token});
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return MedicalFacilitiesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<PatientsResponse> getPatients(String token) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint/patient",
        headers: {"Content-Type": "application/json", "authorization": token});
    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
      return PatientsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
