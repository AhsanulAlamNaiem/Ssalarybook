import 'package:beton_book/core/domain/response.dart';
import 'package:beton_book/core/network_manager/api_end_points.dart';
import 'package:beton_book/core/network_manager/dio_client.dart';
import 'package:beton_book/features/signup_request_management/NewUser.dart';
import 'package:beton_book/features/signup_request_management/provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/global_app_navigator.dart';
import '../../core/presentation/app_provider.dart';

class CloudOperations{
  static final DioClient _dioClient = DioClient();
  static final AppProvider _globalProvider = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>();
  static final SignUpProvider _localProvider = GlobalNavigator.navigatorKey.currentContext!.read<SignUpProvider>();

static  Future<void> sendSignUpRequest( NewUser newUser) async {
  _localProvider.setLoadingState(true);
    print(newUser.toJson());
  _localProvider.setLoadingState(false);
    return;
  }

  static Future<FunctionResponse> fetchCompaniesData() async {
    _localProvider.setLoadingState(true);
    final companyResponse = await _dioClient.get(ApiEndPoints.company);
    _localProvider.setLoadingState(false);
    _localProvider.updateCompanies(companyResponse.data['data']);
    return (companyResponse.data['success'])?
       FunctionResponse(
          success:companyResponse.data['success'],
          message: "Succeed",
          data: companyResponse.data['data'])
      :FunctionResponse.fromMap(companyResponse.data);
    }
}
