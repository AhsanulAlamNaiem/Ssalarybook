import 'package:beton_book/core/domain/response.dart';
import 'package:beton_book/features/punchInOut/provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../core/constants/global_app_navigator.dart';
import '../../core/network_manager/api_end_points.dart';
import '../../core/network_manager/dio_client.dart';

class CloudData{
  final PunchingProvider _provider = GlobalNavigator.navigatorKey.currentContext!.read<PunchingProvider>();
  final DioClient _dioClient = DioClient();
  String responseMessage = "";


  // punch in >>>>>>>>>>>>>>>>>>>>>>>
  Future<FunctionResponse> punchIn() async{

    if(_provider.position==null){
      responseMessage = "Failed to Get the  location";
      return FunctionResponse(success: false, message: responseMessage);
    }

    final body ={
      "entry_latitude": "${_provider.position!.latitude}",
      "entry_longitude": "${_provider.position!.longitude}",
    };

      final response = await _dioClient.post(ApiEndPoints.punchIn, data: body);
    // final response = await fakeResponse(true);
      if (response.data['success']) {
        responseMessage = response.data["data"]["message"];
        _provider.setDidPunchIn(true);
        return FunctionResponse(success: true, message: responseMessage);
      } else{
        return FunctionResponse.fromMap(response.data);
      }

  }

  Future<FunctionResponse> punchOut() async{
    if(_provider.position==null){
      return FunctionResponse(success: false, message: "No location Found");
    }

    final body = {
      "exit_latitude": "${_provider.position!.latitude}",
      "exit_longitude": "${_provider.position!.longitude}",
    };

      final response = await _dioClient.post(ApiEndPoints.punchOut, data: body);
      // final response = await fakeResponse(true);

      if (response.data['success']) {
        responseMessage = response.data["data"]['message'];
        _provider.setDidPunchIn(false);
        return FunctionResponse(success: true, message: responseMessage);
      } else{
        return FunctionResponse.fromMap(response.data);
      }

  }


  Future<Response> _fakeResponse(bool success) async {
    return Response(
      requestOptions: RequestOptions(path: ''), // Adding a valid RequestOptions object
      data: {
        "success": success,
        "data": {"message": success?"succeed":"failed"}
      },
      statusCode: 200, // Ensure client receives this as a 'successful' response
    );
  }

}
