import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/radio_station.dart';
import '../utils/constants.dart';
import 'log_service.dart';

class RadioBrowserService {
  int _currentServerIndex = 0;

  String get _baseUrl =>
      AppConstants.radioBrowserServers[_currentServerIndex];

  /// Common headers for API requests. Radio-Browser requires a User-Agent.
  Map<String, String> get _headers => {
    'User-Agent': 'RadioGo/1.0 (infobit.cloud)',
    'Accept': 'application/json',
  };

  Future<List<RadioStation>> searchStations({
    String query = '',
    int limit = 30,
    int offset = 0,
  }) async {
    LogService.I.d('API', 'searchStations: query="$query" limit=$limit offset=$offset');
    final params = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
      'order': 'clickcount',
      'reverse': 'true',
      'hidebroken': 'true',
    };
    if (query.isNotEmpty) params['name'] = query;
    return _fetchWithFallback('/stations/search', params);
  }

  Future<List<RadioStation>> getTopStations({
    int limit = 30,
    int offset = 0,
  }) async {
    LogService.I.d('API', 'getTopStations: limit=$limit offset=$offset');
    return _fetchWithFallback('/stations/search', {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'order': 'clickcount',
      'reverse': 'true',
      'hidebroken': 'true',
    });
  }

  Future<List<RadioStation>> getStationsByCountry({
    required String countryCode,
    int limit = 30,
    int offset = 0,
  }) async {
    LogService.I.d('API', 'getStationsByCountry: $countryCode limit=$limit');
    return _fetchWithFallback('/stations/search', {
      'countrycode': countryCode,
      'limit': limit.toString(),
      'offset': offset.toString(),
      'order': 'clickcount',
      'reverse': 'true',
      'hidebroken': 'true',
    });
  }

  Future<List<RadioStation>> getStationsByTag({
    required String tag,
    int limit = 30,
    int offset = 0,
  }) async {
    LogService.I.d('API', 'getStationsByTag: $tag limit=$limit');
    return _fetchWithFallback('/stations/search', {
      'tag': tag,
      'limit': limit.toString(),
      'offset': offset.toString(),
      'order': 'clickcount',
      'reverse': 'true',
      'hidebroken': 'true',
    });
  }

  Future<void> clickStation(String stationuuid) async {
    try {
      final uri = Uri.parse('$_baseUrl/json/url/$stationuuid');
      await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));
    } catch (e) {
      LogService.I.w('API', 'clickStation failed for $stationuuid', error: e.toString());
    }
  }

  Future<Map<String, dynamic>?> getServerInfo() async {
    for (int i = 0; i < AppConstants.radioBrowserServers.length; i++) {
      try {
        final base = AppConstants.radioBrowserServers[i];
        final uri = Uri.parse('$base/json/server/info');
        final response = await http
            .get(uri, headers: _headers)
            .timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final body = response.body;
          return jsonDecode(body) as Map<String, dynamic>;
        }
      } catch (e) {
        LogService.I.w('API',
            'Server ${AppConstants.radioBrowserServers[i]} info failed',
            error: e.toString());
        continue;
      }
    }
    return null;
  }

  Future<List<RadioStation>> _fetchWithFallback(
    String path, Map<String, String> params,
  ) async {
    final totalServers = AppConstants.radioBrowserServers.length;
    final timeout = Duration(seconds: AppConstants.apiTimeoutSeconds);

    // Ensure path starts with /json/ for JSON responses
    final jsonPath = path.startsWith('/json/') ? path : '/json$path';

    for (int attempt = 0; attempt < AppConstants.apiRetryCount + 1; attempt++) {
      for (int s = 0; s < totalServers; s++) {
        final idx = (_currentServerIndex + s) % totalServers;
        final base = AppConstants.radioBrowserServers[idx];
        try {
          final uri =
              Uri.parse('$base$jsonPath').replace(queryParameters: params);
          LogService.I.d('API', 'GET $uri');
          final response =
              await http.get(uri, headers: _headers).timeout(timeout);

          if (response.statusCode == 200) {
            final body = response.body;
            final List<dynamic> jsonList = jsonDecode(body);
            _currentServerIndex = idx;
            LogService.I.i('API',
                'Success: $base$path (${jsonList.length} stations, attempt $attempt)');
            return jsonList
                .map((json) =>
                    RadioStation.fromJson(json as Map<String, dynamic>))
                .toList();
          } else {
            LogService.I.w(
                'API', 'HTTP ${response.statusCode} from $base$path');
          }
        } on TimeoutException {
          LogService.I.w('API',
              'Timeout: $base$path (attempt $attempt.${s + 1}, ${timeout.inSeconds}s)');
          continue;
        } catch (e) {
          LogService.I.w('API',
              'Failed: $base$path (attempt $attempt.${s + 1})',
              error: e.toString());
          continue;
        }
      }
    }
    LogService.I.e('API',
        'All servers failed for $path after ${AppConstants.apiRetryCount + 1} retries');
    return [];
  }

  void dispose() {}
}
