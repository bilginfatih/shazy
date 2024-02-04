import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../core/init/network/network_manager.dart';
import '../../models/searchDistance/search_distance_model.dart';

class SearchDistanceService {
  SearchDistanceService._init();

  static SearchDistanceService instance = SearchDistanceService._init();

  Future<void> searchDistance(SearchDistanceModel model) async {
    try {
      String userId = await SessionManager().get('id');
      var matchDriving = NetworkManager.instance.get('/search/distance/$userId/${model.fromLat}/${model.fromLang}/${model.toLat}/${model.toLang}');
      matchDriving.then((result) {
        // Buraya, matchDriving tamamlandığında buraya düşer
        print('onetest completed with result: $result');
      }).catchError((error) {
        // Eğer bir hata oluştuysa buraya düşer
        print('onetest failed with error: $error');
      }).whenComplete(() {
        // Bu kısım, matchDriving tamamlandığında (başarılı ya da başarısız) yapılacak işlemleri içerir.
        print('onetest completed or failed, regardless of the result');
      });
    } catch (e) {
      rethrow;
    }
  }
}
