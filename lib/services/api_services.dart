import 'dart:convert';
import 'package:beton_book/services/scretResources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'appResources.dart';

class ApiService{
  final storage = FlutterSecureStorage();
  Future<Map<String, String>?> loginFunction({required String email, required String password}) async {
    final url = Uri.parse(AppApis.login);
    final body = jsonEncode({"email": email, "password": password});

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final cookies = response.headers['set-cookie']!.split(";");
      final cookie = "${cookies[0]}; ${cookies[4].split(",")[1]}";
      final authHeaders = {"cookie": cookie, "Authorization": "Token $token"};
      await storage.write(key: AppSecuredKey.authHeaders, value: jsonEncode(headers));
      return authHeaders;
    }
  }

  Future<User?> fetchUserInfoFunction({required Map<String, String> authHeaders}) async {
    final employeUrl = Uri.parse(AppApis.employeeDetails);
    final response = await http.get(employeUrl, headers: authHeaders);
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body).cast<String,dynamic>();
      User user = User.fromJson(responseJson);
      return user;
    }
  }

  Future fetchUserPermissions({User? user, required Map<String,String> authHeaders}) async {
    final url = Uri.parse(AppApis.checkUserGroup);
    final response = await http.get(url, headers: authHeaders);
    print(response.body);

    if (response.statusCode == 200) {
      print("Getting Machine Permission");
      final responseJson = jsonDecode(response.body);
      print("Machine Permission: ${responseJson}");

      if(user!=null) {
        user.permissionGroups = responseJson["group-name"];;
        user.designation = responseJson["designation"];
        user.department = responseJson["department"];
        user.company = responseJson["company"];
        return user;
      } else{
        return responseJson;
      }
    }
  }
}

