import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../core/init/network/network_manager.dart';
import '../../models/searchDistance/search_distance_model.dart'; // Örnek bir model dosyası, kendi modelinizi eklemelisiniz.

class SearchDistanceService {
  SearchDistanceService._init();

  static SearchDistanceService instance = SearchDistanceService._init();

  Future<void> searchDistance(SearchDistanceModel model) async {
    try {
      String userId = await SessionManager().get('id');
      NetworkManager.instance.get('/search/distance/$userId/${model.fromLat}/${model.fromLang}/${model.toLat}/${model.toLang}');
    } catch (e) {
      rethrow;
    }
  }
}
