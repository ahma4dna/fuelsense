import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info.dart';

class NetworkInfoImp implements NetworkInfo {


  @override
  Future<bool> get isConnected async {
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    return isConnected;
  }
}
