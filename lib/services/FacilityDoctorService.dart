import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

import 'APIClient.dart';
import '../models/Responses/MedicalFacilitiesResponse.dart';

class FacilityDoctorService {
  static final String endPoint = "api/v1/facilities-doctors";
  static final FacilityDoctorService _instance =
      FacilityDoctorService._getInstance();

  factory FacilityDoctorService() {
    return _instance;
  }
  FacilityDoctorService._getInstance();

  Future<MedicalFacilitiesResponse> getMedicalFacilities(String token) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint",
        headers: {"Content-Type": "application/json", "authorization": token});
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return MedicalFacilitiesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
