import 'dart:convert';
import 'dart:io';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/punchInOut/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/Local_Data_Manager/cacheKeys.dart';
import '../../core/navigation/global_app_navigator.dart';
import '../../core/network_manager/api_end_points.dart';
import '../../core/network_manager/dio_client.dart';
import '../../core/presentation/widgets/app_utility.dart';

class CloudData{
  final PunchingProvider _provider = GlobalNavigator.navigatorKey.currentContext!.read<PunchingProvider>();
  final AppProvider _globalProvider = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final DioClient _dioClient = DioClient();

  static String responseMessage = "";


  // punch in >>>>>>>>>>>>>>>>>>>>>>>
  Future<bool> punchIn() async{
    _provider.setLoadingStatus(true);

    if(_provider.position==null){
      _provider.setLoadingStatus(false);
      responseMessage = "Failed to Get the  location";
      return false;
    }

    final body ={
      "entry_latitude": "${_provider.position!.latitude}",
      "entry_longitude": "${_provider.position!.longitude}",
    };

    try{
      final response = await _dioClient.post(ApiEndPoints.punchIn, data: body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.data);
        _storage.write(key: AppSecuredKey.didPunchIn, value:  jsonEncode({"attendanceId": "true", "date": DateFormat('yyyy-MM-dd').format(DateTime.now())}));
        responseMessage = data["message"];
        AppUtility.showToast(message: responseMessage);
        _provider.setDidPunchIn(true, attendanceId: 3 );
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          // Server responded error in my request
          final message = '${data['error']?['message'] ?? "Something went wrong"}\n\n${data['error']?['details'] ?? "Try again later"}';
          AppUtility.showToast(message: message);
        } else {
          // Server not responded
          print("response: $statusCode ${e.response?.data}");
          AppUtility.showToast(message: "Server Error,Please try again letter.");
        }
      } else {
        // Network error, timeout, etc.
        AppUtility.showToast(message: "Something went wrong! Check Internet Connection.");
      }
    } catch (e) {
      AppUtility.showToast(message: "System Error.");
    } finally {
    print("punchin ends");
    _provider.setLoadingStatus(false);
    }
    return false;
  }






  Future<void> punchOut() async{
    _provider.setLoadingStatus(true);

    if(_provider.position==null){
      _provider.setLoadingStatus(false);
      return;
    }

    final body = {
      "exit_latitude": "${_provider.position!.latitude}",
      "exit_longitude": "${_provider.position!.longitude}",
    };

    print(body);

    try{
      final response = await _dioClient.post(ApiEndPoints.punchOut, data: body);
      print(response.statusCode  );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        final message = data["message"];
        AppUtility.showToast(message: message);

        await _storage.delete(key: AppSecuredKey.didPunchIn);
        _provider.setDidPunchIn(true);

      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final message = '${data['error']?['message'] ?? "Something went wrong"}\n\n${data['error']?['details'] ?? "Try again later"}';
          AppUtility.showToast(message: message);
        } else {
          print("response: $statusCode ${e.response?.data}");
          AppUtility.showToast(message: "Something went wrong! Check Internet Connection.");
        }
      } else {
        // Network error, timeout, etc.
        AppUtility.showToast(message: "Something went wrong! ${e.message}");
      }
    } catch (e) {
      AppUtility.showToast(message: "Unexpected Error: $e");
    }

    _provider.setLoadingStatus(false);
  }

}
