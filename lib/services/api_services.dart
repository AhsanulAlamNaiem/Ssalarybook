import 'dart:convert';
import 'package:beton_book/services/scretResources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'appResources.dart';

class ApiService{
  final storage = FlutterSecureStorage();
  static Map<String, String> authHeaders = {};
  static String message = "";
  static int employeeIid = 0;

  Future<bool> tryLogIn({required String email, required String password}) async {
    final url = Uri.parse(AppApis.login);
    final body = jsonEncode({"email": email, "password": password});

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);
    print("TryLogin: ${response.statusCode} ${response.body}");
    message = jsonDecode(response.body)["message"];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']["token"];
      final cookies = response.headers['set-cookie']!.split(";");
      final cookie = "${cookies[0]}; ${cookies[4].split(",")[1]}";
      authHeaders = {"cookie": cookie, "Authorization": "Token $token"};
      employeeIid = data['data']['employee_id'];
      print(employeeIid);
      await storage.write(key: AppSecuredKey.authHeaders, value: jsonEncode(headers));
      return true;
    } else{
      return false;
    }
  }

  Future<User?> fetchUserInfoFunction() async {
    final employeeUrl = Uri.parse("${AppApis.employeeDetails}$employeeIid/");
    print(employeeUrl);
    final response = await http.get(employeeUrl, headers: authHeaders);
    print("Info Resp ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body).cast<String,dynamic>();
      User user = User.fromJson(responseJson);
      print("user");
      print(user.name);
      final companyUrl = "${AppApis.company}${user.company}/";
      print(companyUrl);
      final companyResponse = await http.get(Uri.parse(companyUrl));
      print("Company response ${companyResponse.statusCode} ${companyResponse.body}");

      if (companyResponse.statusCode == 200) {
        final companyResponseJson = jsonDecode(companyResponse.body);
        final branches = companyResponseJson['branches'] as List<dynamic>;
        print(branches);
        final List<Location>companyLocations = branches.map((branch) => Location.fromJson(branch)).toList().cast<Location>();
        user.locations = companyLocations;
      return user;
    }}
  }

  Future fetchUserPermissions({User? user}) async {
    final url = Uri.parse(AppApis.checkUserGroup);
    final response = await http.get(url, headers: authHeaders);
    print(response.body);

    if (response.statusCode == 200) {
      print("Getting Machine Permission");
      final responseJson = jsonDecode(response.body);
      print("Machine Permission: ${responseJson}");

      if(user!=null) {
        user.permissionGroups = responseJson["group-name"];
        user.designation = responseJson["designation"];
        user.department = responseJson["department"];
        user.company = responseJson["company"];
        return user;
      } else{
        return responseJson;
      }
    }
  }

  Future<List?> fetchCompaniesData() async {
      final companyUrl = Uri.parse(AppApis.company);
      final companyResponse = await http.get(companyUrl);
      print("Company Response: ${companyResponse.body}");
      if (companyResponse.statusCode == 200) {
        final companyResponseJson = jsonDecode(companyResponse.body);
        return companyResponseJson;
      }}
}

