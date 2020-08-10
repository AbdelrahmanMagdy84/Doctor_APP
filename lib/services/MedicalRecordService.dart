import 'dart:convert';
import 'APIClient.dart';
import 'package:http/http.dart' as http;

import '../models/MedicalRecord.dart';
import '../models/Responses/MedicalRecordResponse.dart';
import '../models/Responses/MedicalRecordsResponse.dart';

class MedicalRecordService {
  static final String endPoint = "api/v1/medical-records";
  static final MedicalRecordService _instance =
      MedicalRecordService._getInstance();

  factory MedicalRecordService() {
    return _instance;
  }
  MedicalRecordService._getInstance();

  Future<MedicalRecordsResponse> getMedicalRecords(
      String token, String type) async {
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint/?type=$type",
        headers: {"Content-Type": "application/json", "authorization": token});
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return MedicalRecordsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
