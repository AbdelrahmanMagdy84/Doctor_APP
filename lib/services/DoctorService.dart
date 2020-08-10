import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:io';

import 'APIClient.dart';
import '../models/Doctor.dart';
import '../models/Responses/DoctorResponse.dart';

class DoctorService {
  static final String endPoint = "api/v1/doctors";
  static final DoctorService _instance = DoctorService._getInstance();

  factory DoctorService() {
    return _instance;
  }
  DoctorService._getInstance();

  Future<DoctorResponse> login(String input, String password) async {
    Map<String, String> body;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    if (emailValid) {
      body = {"email": input, "password": password};
    } else {
      body = {"username": input, "password": password};
    }
    print("${APIClient.baseUrl}/$endPoint/auth");
    final http.Response response = await http.post(
        "${APIClient.baseUrl}/$endPoint/auth",
        body: jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<DoctorResponse> signup(Doctor doctor) async {
    final http.Response response = await http.post(
        "${APIClient.baseUrl}/$endPoint",
        body: jsonEncode(doctor.toJson()),
        headers: {HttpHeaders.contentTypeHeader: "application/json"});
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to signup");
    }
  }

  Future<DoctorResponse> updateDoctor(Doctor patient, String token) async {
    final http.Response response = await http.patch(
        "${APIClient.baseUrl}/$endPoint",
        body: jsonEncode(patient.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "authorization": token
        });
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update");
    }
  }

  Future<DoctorResponse> getDoctorById(String id, String token) async {
    final newURI = Uri.http("${APIClient.baseUrl}", "$endPoint", {"_id": id});
    final http.Response response = await http.get(newURI,
        headers: {"Content-Type": "application/json", "authorization": token});
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<DoctorResponse> getDoctorByUsername(
      String username, String token) async {
    print(token);
    final http.Response response = await http.get(
        "${APIClient.baseUrl}/$endPoint/?username=$username",
        headers: {"Content-Type": "application/json", "authorization": token});
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<DoctorResponse> getDoctor(String token) async {
    final http.Response response = await http
        .get("${APIClient.baseUrl}/$endPoint", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "authorization": token
    });
    if (response.statusCode == 200) {
      return DoctorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
