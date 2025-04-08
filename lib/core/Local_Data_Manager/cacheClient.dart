import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class CacheClient {
  static  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future  write({String key="", String value=""}) async {
    await _storage.write(key: key, value: value);
    print("✅Written Value");
    print("✅Key: $key");
    print("✅value: $value");
  }
  static Future<String?> read({required String key}) async {
     final value =  await _storage.read(key: key);
     if(value==null){
       print("✅️Retrieved Value");
       print("️️✅️Key: $key");
       print("✅️value: $value");
     }else{
       print("⚠️️Key: $key");
       print("⚠️value: $value");
     }

     return value;
  }

  static Future delete({required String key}) async {
    await _storage.delete(key: key);
    print("⛔Key: $key");
  }

  static Future deleteAll() async {
    await _storage.deleteAll();
    print("⛔All Cached Data is Removed");
  }
}
