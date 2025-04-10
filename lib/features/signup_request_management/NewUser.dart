import 'package:beton_book/core/domain/response.dart';

class NewUser {
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? company;
  String? department;
  String? designation;
  String? branch;
  String? mobile;

  NewUser({
    this.password,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.company,
    this.department,
    this.designation,
    this.branch,
    this.mobile,
  });

  // Factory method to create an instance from a JSON object
  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      password: json['password'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      company: json['company'],
      department: json['department'],
      designation: json['designation'],
      branch: json['branch'],
      mobile: json['mobile'],
    );
  }

  // Method to convert the instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'company': company,
      'department': department,
      'designation': designation,
      'branch': branch,
      'mobile': mobile,
    };
  }

  // Check for empty fields and return appropriate message or true
  FunctionResponse isComplete() {
    List<String> emptyFields = [];

    if (email == null || email!.isEmpty) emptyFields.add('Email');
    if (branch == null || branch!.isEmpty) emptyFields.add('Branch');
    if (company == null || company!.isEmpty) emptyFields.add('Company');
    if (firstName == null || firstName!.isEmpty) emptyFields.add('First Name');
    if (lastName == null || lastName!.isEmpty) emptyFields.add('Last Name');
    if (gender == null || gender!.isEmpty) emptyFields.add('Gender');
    if (department == null || department!.isEmpty) emptyFields.add('Department');
    if (designation == null || designation!.isEmpty) emptyFields.add('Designation');
    if (mobile == null || mobile!.isEmpty) emptyFields.add('Mobile');
    if (password == null || password!.isEmpty) emptyFields.add('Password');

    if (emptyFields.isNotEmpty) {
      final message =  'No field should be empty.\n${emptyFields.join(', ')} are empty.';
      return FunctionResponse(success: false, message: message);
    }

    return FunctionResponse(success: true, message: "succeed");
  }
}