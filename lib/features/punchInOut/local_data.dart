import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/features/punchInOut/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/global_app_navigator.dart';

class LocalData{
  final PunchingProvider _provider = GlobalNavigator.navigatorKey.currentContext!.read<PunchingProvider>();
  final AppProvider _globalProvider = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>();

Future<void> getCurrentLocation() async {

  print("started working");
    _provider.setGettingLocationStatus(true);
    _provider.setClickableStatus(false);
    Position? position;
    LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied) {
      _provider.setLocationMessage("Permission Denied");
  }

  try{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _provider.setPosition(position);
  } catch(e){
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("Service $serviceEnabled");
    if(!serviceEnabled){
      _provider.setLocationMessage("Location is Disabled");
      _provider.setGettingLocationStatus(false);
    }
    return;
  }

  if(position!=null){
      final locationMessage =
      'Latitude: ${position!.latitude},\nLongitude: ${position!.longitude}';
      _provider.setClickableStatus(true);
      _provider.setLocationMessage(locationMessage);
      _provider.setGettingLocationStatus(false);
  }
    _provider.setGettingLocationStatus(false);
}
}
