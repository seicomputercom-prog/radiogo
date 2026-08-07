import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/radio_station.dart';
import '../utils/constants.dart';
import 'log_service.dart';

class RadioBrowserService {
  int _currentServerIndex = 0;

  String get _baseUrl =>
      AppConstants.radioBrowserServers[_currentServerIndex];

  HttpClient get _client {
    return HttpClient()
      ..connectionTimeout =
          Duration(seconds: AppConstants.apiTimeoutSeconds);
  }

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
      final uri = Uri.parse('$_baseUrl/url/$stationuuid');
      final client = _client;
      final request = await client.getUrl(uri);
      await request.close();
      client.close();
    } catch (e) {
      LogService.I.w('API', 'clickStation failed for $stationuuid', error: e.toString());
    }
  }

  Future<Map<String, dynamic>?> getServerInfo() async {
    for (int i = 0; i < AppConstants.radioBrowserServers.length; i++) {
      try {
        final base = AppConstants.radioBrowserServers[i];
        final uri = Uri.parse('$base/server/info');
        final client = _client;
        final request = await client.getUrl(uri);
        final response = await request.close();
        client.close();
        if (response.statusCode == 200) {
          final body = await response.transform(utf8.decoder).join();
          return jsonDecode(body) as Map<String, dynamic>;
        }
      } catch (e) {
        LogService.I.w('API', 'Server ${AppConstants.radioBrowserServers[i]} info failed', error: e.toString());
        continue;
      }
    }
    return null;
  }

  Future<List<RadioStation>> _fetchWithFallback(
    String path, Map<String, String> params,
  ) async {
    final totalServers = AppConstants.radioBrowserServers.length;
    for (int attempt = 0; attempt < AppConstants.apiRetryCount + 1; attempt++) {
      for (int s = 0; s < totalServers; s++) {
        final idx = (_currentServerIndex + s) % totalServers;
        final base = AppConstants.radioBrowserServers[idx];
        try {
          final uri = Uri.parse('$base$path').replace(queryParameters: params);
          final client = _client;
          final request = await client.getUrl(uri);
          final response = await request.close();
          client.close();

          if (response.statusCode == 200) {
            final body = await response.transform(utf8.decoder).join();
            final List<dynamic> jsonList = jsonDecode(body);
            _currentServerIndex = idx;
            LogService.I.i('API', 'Success: $base$path (${jsonList.length} stations, attempt $attempt)');
            return jsonList
                .map((json) => RadioStation.fromJson(json as Map<String, dynamic>))
                .toList();
          } else {
            LogService.I.w('API', 'HTTP ${response.statusCode} from $base$path');
          }
        } catch (e) {
          LogService.I.w('API', 'Failed: $base$path (attempt $attempt.${s + 1})', error: e.toString());
          continue;
        }
      }
    }
    LogService.I.e('API', 'All servers failed for $path after ${AppConstants.apiRetryCount + 1} retries');
    return [];
  }

  void dispose() {}
}
