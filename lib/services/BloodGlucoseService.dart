import 'dart:convert';
import 'APIClient.dart';
import 'package:http/http.dart' as http;

import '../models/Responses/BloodGlucoseResponseList.dart';

class BloodGlucoseService {
  static final String endPoint = "api/v1/blood-glucose";
  static final BloodGlucoseService _instance =
      BloodGlucoseService._getInstance();

  factory BloodGlucoseService() {
    return _instance;
  }
  BloodGlucoseService._getInstance();

  Future<BloodGlucoseResponseList> getBloodGlucoseMeasure(String token) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint",
        headers: {"Content-Type": "application/json", "authorization": token});
    if (response.statusCode == 200) {
      return BloodGlucoseResponseList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
