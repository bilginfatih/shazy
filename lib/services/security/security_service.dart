import '../../core/init/network/network_manager.dart';
import '../../models/security/security_model.dart';

class SecurityService {
  SecurityService._init();
  static SecurityService intance = SecurityService._init();
  final _request = '/security-code';
  Future<void> callerCode(String id) async {
    try {
      var response = await NetworkManager.instance.get('$_request/callerCode/$id');
    } catch (e) {}
  }

  Future<void> securityCodeMatch(SecurityModel model) async {
    try {
      var response = await NetworkManager.instance.post('/security-code', model: model);
      
    } catch (e) {
      
    }
  }
}
