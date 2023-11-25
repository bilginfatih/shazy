import '../../core/init/network/network_manager.dart';

class SecurityService {
  SecurityService._init();
  static SecurityService intance = SecurityService._init();
  final _request = '/security-code';
  Future<void> callerCode(String id) async {
    try {
      var response = await NetworkManager.instance.get('$_request/callerCode/$id');
    } catch (e) {}
  }
}
