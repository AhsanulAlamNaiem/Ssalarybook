import 'dart:convert';
import 'package:beton_book/core/Local_Data_Manager/cacheKeys.dart';
import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/constants/global_app_navigator.dart';
import 'package:beton_book/core/network_manager/api_end_points.dart';
import 'package:beton_book/core/network_manager/dio_client.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/authentication/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../core/Local_Data_Manager/cacheClient.dart';

class ApiService{
  final storage = FlutterSecureStorage();
  static String message = "";
  static Map<String,dynamic> userMap = {

  };

  DioClient dioClient = DioClient();
  AppProvider globalProvider = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>();
  AuthenticationProvider localProvider = GlobalNavigator.navigatorKey.currentContext!.read<AuthenticationProvider>();

  Future<bool> login({required String email, required String password})async{
    final authHeader = await authenticate(email: email, password: password);
    if(authHeader==null){
      return false;
    } else{
      globalProvider.updateAuthHeader(newAuthHeader: authHeader);
      bool canFetchedUserInfo = await fetchUserInfoFunction();
      if(canFetchedUserInfo){
        User user = User.fromJson(userMap);
        globalProvider.updateAuthHeader(newAuthHeader: authHeader);
        globalProvider.updateUser(newUser: user );
        CacheClient.write(key: CacheKeys.userObject, value: jsonEncode(user.toJson()));
        CacheClient.write(key: CacheKeys.authHeaders, value: jsonEncode(authHeader));
      }
      return canFetchedUserInfo;
    }
}

  Future<Map<String, String>?> authenticate({required String email, required String password}) async {
    final body = {"email": email, "password": password};
    localProvider.setLoadingState(true);
    final response = await dioClient.post(ApiEndPoints.login, data: body);
    localProvider.setLoadingState(false);

    if (response.statusCode == 200) {
      final token = response.data['data']["token"];
      userMap["id"] = response.data['data']['employee_id'];
      final csrfToken = response.headers['set-cookie']![0].split(";")[0];
      final sessionId = response.headers['set-cookie']![1].split(";")[0];
      final authHeaders = {"cookie": "$csrfToken; $sessionId", "Authorization": "Token $token"};
      return authHeaders;
    }
  }

  Future<bool> fetchUserInfoFunction() async {
    localProvider.setLoadingState(true);
    final response = await dioClient.get(ApiEndPoints.employeeDetails);
    localProvider.setLoadingState(false);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = response.data.cast<String,dynamic>();
      userMap.addAll(responseJson);
      return true;
    } else{
      return false;
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

