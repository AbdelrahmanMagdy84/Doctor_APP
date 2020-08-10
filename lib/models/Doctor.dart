class Doctor {
  String id;
  String firstName;
  String lastName;
  String password;
  String email;
  String username;
  String bio;
 
  String mobile;
  DateTime birthDate;
  String gender;
  String specialization;

  Doctor(
      {this.id,
      this.firstName,
      this.lastName,
      this.password,
      this.email,
      this.username,
      
      this.bio,
      this.mobile,
      this.birthDate,
      this.gender,
      this.specialization});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        username: json["username"],
        
        mobile: json["mobile"],
        bio: json["bio"],
        birthDate: DateTime.parse(json["birthDate"]),
        gender: json["gender"],
        specialization: json["specialization"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "password": this.password,
      "email": this.email,
      "username": this.username,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "mobile": this.mobile,
      "gender": this.gender,
      "birthDate": this.birthDate.toIso8601String(),
      "specialization": this.specialization,

      "bio": this.bio
    };
  }
}
