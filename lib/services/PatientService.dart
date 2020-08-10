import 'dart:convert';
import 'dart:io';
import 'APIClient.dart';
import '../models/Responses/PatientResponse.dart';
import 'package:http/http.dart' as http;

class PatientService {
  static final String endPoint = "api/v1/patients";
  static final PatientService _instance = PatientService._getInstance();

  factory PatientService() {
    return _instance;
  }

  PatientService._getInstance();

  Future<PatientResponse> getPatient(String token) async {
    final http.Response response = await http
        .get("${APIClient.baseUrl}/$endPoint", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "authorization": token
    });
    if (response.statusCode == 200) {
      return PatientResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
