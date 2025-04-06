import 'dart:convert';
import 'package:beton_book/core/navigation/global_app_navigator.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../constants/secretResources.dart';
import '../domain/user.dart';

class CachedDataService {
  static final FlutterSecureStorage storage = FlutterSecureStorage();
  static final BuildContext context = GlobalNavigator.navigatorKey.currentContext!;

  Future<void> fetchAllDataToProvider() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _getAuthHeaders(context);
    _getUser(context);
    });
  }

  _getAuthHeaders(BuildContext context) async {
    final cachedAuthHeader = await storage.read(
        key: AppSecuredKey.authHeaders);
    final tokenjson = jsonDecode(cachedAuthHeader!);
    final authHeaders = {"cookie": tokenjson['cookie'].toString(),
      "Authorization": tokenjson['Authorization'].toString()
    };
    context.read<AppProvider>().updateAuthHeader(newAuthHeader: authHeaders);
  }

  _getUser(BuildContext context) async {
    final strUser = await storage.read(key: AppSecuredKey.userObject);
    if (strUser != null) {
      User user = User.fromJson(jsonDecode(strUser));
      context.read<AppProvider>().updateUser(newUser: user);
    }
  }

  static Future<bool> isLoggedIn() async{
    try {
      final strUser = await storage.read(key: AppSecuredKey.userObject);
      final cachedAuthHeader = await storage.read(
          key: AppSecuredKey.authHeaders);
      return (strUser == null || cachedAuthHeader == null) ? false : true;
    } catch(_){
      return false;
    }
  }

  _foreLogOut() async {
    final bool isCachedDeleted = await isLoggedIn();
    storage.deleteAll();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_)=>LogInPage()),
            (Route<dynamic> route) => false);
  }

}

// {cookie: csrftoken=MTslpVPeiyGwYVNb5MUJKoUEsmbJ0Gr2; sessionid=adfw79lqg21ssv75j578j6aw8r7gg8cs, Authorization: Token aea48c3164773e1510541e24f57e4fa745a6b0e9}