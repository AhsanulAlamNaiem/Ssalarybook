import 'dart:convert';
import 'package:beton_book/core/Local_Data_Manager/cacheKeys.dart';
import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/constants/global_app_navigator.dart';
import 'package:beton_book/core/network_manager/api_end_points.dart';
import 'package:beton_book/core/network_manager/dio_client.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/authentication/provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../core/Local_Data_Manager/cacheClient.dart';
import '../../core/domain/response.dart';

class ApiService{
  final storage = FlutterSecureStorage();
  static String message = "";
  static Map<String,dynamic> userMap = {

  };

  DioClient dioClient = DioClient();
  AppProvider globalProvider = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>();
  AuthenticationProvider localProvider = GlobalNavigator.navigatorKey.currentContext!.read<AuthenticationProvider>();

  Future<FunctionResponse> login({required String email, required String password})async{
    final authenticationResponse = await authenticate(email: email, password: password);
    if(!authenticationResponse.success){
      return  authenticationResponse;
    } else{
      final userInfoResponse = await fetchUserInfoFunction();
      if(userInfoResponse.success){
        User user = User.fromJson(userMap);
        globalProvider.updateUser(newUser: user );
        CacheClient.write(key: CacheKeys.userObject, value: jsonEncode(user.toJson()));
      }
      return userInfoResponse;
    }
  }

  Future<FunctionResponse> authenticate({required String email, required String password}) async {
    final body = {"email": email, "password": password};
    localProvider.setLoadingState(true);

      final response = await dioClient.post(ApiEndPoints.login, data: body);
    if (response.data['success']) {
        final token = response.data['data']['data']["token"];
        userMap["id"] = response.data['data']['data']['employee_id'];
        final csrfToken = response.headers['set-cookie']![0].split(";")[0];
        final sessionId = response.headers['set-cookie']![1].split(";")[0];
        final authHeaders = {
          "cookie": "$csrfToken; $sessionId",
          "Authorization": "Token $token"
        };
        globalProvider.updateAuthHeader(newAuthHeader: authHeaders);
        CacheClient.write(key: CacheKeys.authHeaders, value: jsonEncode(authHeaders));
      return FunctionResponse(success: true, message: "Authenticated Successfully");
    } else{
      return FunctionResponse.fromMap(response.data);
    }
  }

  Future<FunctionResponse> fetchUserInfoFunction() async {
    localProvider.setLoadingState(true);
      final response = await dioClient.get(ApiEndPoints.employeeDetails);
    if (response.data['success']) {
        Map<String, dynamic> responseJson = response.data['data'].cast<String,
            dynamic>();
        userMap.addAll(responseJson);
        localProvider.setLoadingState(false);
      return FunctionResponse(success: true, message: message);
    } else{
      return FunctionResponse.fromMap(response.data);
    }
  }

}



