import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/radio_station.dart';
import '../utils/constants.dart';

class RadioBrowserService {
  final String _baseUrl = AppConstants.radioBrowserBaseUrl;
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10);

  /// Search stations by query string.
  Future<List<RadioStation>> searchStations({
    String query = '',
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/stations/search').replace(queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order': 'clickcount',
        'reverse': 'true',
        'hidebroken': 'true',
        if (query.isNotEmpty) 'name': query,
      });
      return await _fetchStations(uri);
    } catch (e) {
      return [];
    }
  }

  /// Get top stations by click count.
  Future<List<RadioStation>> getTopStations({
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/stations/search').replace(queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order': 'clickcount',
        'reverse': 'true',
        'hidebroken': 'true',
      });
      return await _fetchStations(uri);
    } catch (e) {
      return [];
    }
  }

  /// Get stations by country code.
  Future<List<RadioStation>> getStationsByCountry({
    required String countryCode,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/stations/search').replace(queryParameters: {
        'countrycode': countryCode,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order': 'clickcount',
        'reverse': 'true',
        'hidebroken': 'true',
      });
      return await _fetchStations(uri);
    } catch (e) {
      return [];
    }
  }

  /// Get stations by tag.
  Future<List<RadioStation>> getStationsByTag({
    required String tag,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/stations/search').replace(queryParameters: {
        'tag': tag,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order': 'clickcount',
        'reverse': 'true',
        'hidebroken': 'true',
      });
      return await _fetchStations(uri);
    } catch (e) {
      return [];
    }
  }

  /// Send a click (vote) for a station to Radio-Browser.info.
  Future<void> clickStation(String stationuuid) async {
    try {
      final uri = Uri.parse('$_baseUrl/url/$stationuuid');
      final request = await _client.getUrl(uri);
      final response = await request.close();
      // drain the response body
      await response.drain<void>();
    } catch (e) {
      // silently ignore click errors
    }
  }

  /// Get server info / stats.
  Future<Map<String, dynamic>?> getServerInfo() async {
    try {
      final uri = Uri.parse('$_baseUrl/server/info');
      final request = await _client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        return jsonDecode(body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Internal: fetch stations list from a URI.
  Future<List<RadioStation>> _fetchStations(Uri uri) async {
    final request = await _client.getUrl(uri);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch stations: ${response.statusCode}');
    }

    final body = await response.transform(utf8.decoder).join();
    final List<dynamic> jsonList = jsonDecode(body);

    return jsonList
        .map((json) => RadioStation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
