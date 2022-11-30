import 'dart:io';

class AdHelper{
  static String get bannerAdUnitId{
    if(Platform.isAndroid){
      return "ca-app-pub-4109178583091990/6357354391";
    }
    else{
      throw new UnsupportedError("Unsupported platform");
    }
  }
}