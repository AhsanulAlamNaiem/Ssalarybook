import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class CacheClient {
  static late final FlutterSecureStorage _storage;

  cacheClient() {
    _storage = FlutterSecureStorage();
  }

  static Future  write({String key="", String value=""}) async {
    await _storage.write(key: key, value: value);
    print("✅Key: $key");
    print("✅value: $key");
  }
  static Future<String?> read({required String key}) async {
     final value =  await _storage.read(key: key);
     if(value==null){
       print("✅Key: $key");
       print("✅value: $value");
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
