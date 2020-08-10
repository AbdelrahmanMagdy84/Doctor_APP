import 'dart:convert';
import 'APIClient.dart';
import 'package:http/http.dart' as http;
import '../models/Responses/BloodPressureResponseList.dart';

class BloodPressureService {
  static final String endPoint = "api/v1/blood-pressure";
  static final BloodPressureService _instance =
      BloodPressureService._getInstance();

  factory BloodPressureService() {
    return _instance;
  }

  BloodPressureService._getInstance();

  Future<BloodPressureResponseList> getBloodPressureMeasure(
      String patientId, String token) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint/?patientId=$patientId",
        headers: {"Content-Type": "application/json", "authorization": token});
    if (response.statusCode == 200) {
      return BloodPressureResponseList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
