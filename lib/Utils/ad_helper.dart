import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4109178583091990/2946239338';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}