class Employee {
  final int id;
  final String name;
  String designation;
  String department;
  String company;
  final String phone;
  final String email;
  final String dateOfJoining;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.phone,
    required this.email,
    required this.company,
    required this.dateOfJoining,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      email: json["user"]['email'],
      name: "${json['first_name']} ${json['last_name']}",
      company: json["company"].toString(),
      department: json['department'].toString(),
      phone: json['mobile'].toString(),
      designation: json['designation'].toString(),
      dateOfJoining: json['date_of_joining'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final nameParts = name.split(' ');
    return {
      'id': id,
      'first_name': nameParts.first,
      'last_name': nameParts.length > 1 ? nameParts.last : "",
      'designation': designation,
      'department': department,
      'phone': phone,
      'user': {'email': email},
      'company': company,
      'date_of_joining': dateOfJoining,
    };
  }
}
