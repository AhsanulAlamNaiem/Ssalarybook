import 'dart:convert';
import 'dart:io';
import 'package:beton_book/core/domain/response.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/punchInOut/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/Local_Data_Manager/cacheKeys.dart';
import '../../core/constants/global_app_navigator.dart';
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
        responseMessage = data["message"];
        AppUtility.showToast(FunctionResponse(success: true, message: responseMessage));
        _provider.setDidPunchIn(true);
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          // Server responded error in my request
          responseMessage = '${data['error']?['message'] ?? "Something went wrong"}\n\n${data['error']?['details'] ?? "Try again later"}';
        } else {
          // Server not responded
          print("response: $statusCode ${e.response?.data}");
          responseMessage= "Server Error,Please try again letter.";
        }
      } else {
        // Network error, timeout, etc.
        responseMessage= "Something went wrong! Check Internet Connection.";
      }
    } catch (e) {
      responseMessage= "System Error.";
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
        responseMessage = data["message"];
        AppUtility.showToast(AppUtility.showToast(FunctionResponse(success: true, message: responseMessage)));

        await _storage.delete(key: CacheKeys.didPunchIn);
        _provider.setDidPunchIn(true);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          final message = '${data['error']?['message'] ?? "Something went wrong"}\n\n${data['error']?['details'] ?? "Try again later"}';
        } else {
          print("response: $statusCode ${e.response?.data}");
        responseMessage= "Server Error,Please try again letter.";
        }
      } else {
        // Network error, timeout, etc.
          responseMessage= "Something went wrong! Check Internet Connection.";
      }
    } catch (e) {
      responseMessage= "System Error.";
    }

    _provider.setLoadingStatus(false);
  }

}
