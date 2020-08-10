import '../Doctor.dart';

class DoctorResponse {
  String message;
  bool success;
  Doctor doctor;
  String token;
  DoctorResponse({this.doctor, this.message, this.success, this.token});

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    return DoctorResponse(
        success: json["success"],
        message: json["message"],
        doctor: json["doctor"] != null ? Doctor.fromJson(json["doctor"]) : null,
        token: json["doctor"]["token"]);
  }
}
