import '../models/news_model.dart';
import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../services/guest_session_service.dart';

class AppRepository {
  AppRepository._(this._apiClient, this._guestSessionService);

  static AppRepository? _instance;
  final ApiClient _apiClient;
  final GuestSessionService _guestSessionService;

  static void initialize() {
    final ApiClient apiClient = ApiClient(baseUrl: AppConfig.apiV1BaseUrl);
    _instance = AppRepository._(apiClient, GuestSessionService(apiClient));
  }

  static AppRepository get instance {
    final AppRepository? instance = _instance;
    if (instance == null) {
      throw StateError('AppRepository.initialize() must be called first');
    }
    return instance;
  }

  Future<List<News>> getNews() async {
    final String token = await _guestSessionService.getOrCreateToken();
    final Map<String, dynamic> response = await _apiClient.get(
      '/news',
      bearerToken: token,
      query: <String, String>{'page': '1', 'limit': '20'},
    );

    final List<dynamic> rawData = (response['data'] as List<dynamic>?) ?? <dynamic>[];
    return rawData
        .whereType<Map<String, dynamic>>()
        .map(News.fromJson)
        .toList();
  }

  Future<News> getNewsDetails(String id) async {
    final String token = await _guestSessionService.getOrCreateToken();
    final Map<String, dynamic> response = await _apiClient.get(
      '/news/$id',
      bearerToken: token,
    );
    final Map<String, dynamic> raw = (response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return News.fromJson(raw);
  }

  Future<void> submitMemberRequest({
    required String name,
    required String mobileNumber,
    required String address,
  }) async {
    await _apiClient.post(
      '/member-request',
      body: <String, dynamic>{
        'name': name,
        'mobile_number': mobileNumber,
        'address': address,
      },
    );
  }
}
