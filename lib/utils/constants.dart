class AppConstants {
  static const String appName = 'RadioGo';
  static const String appSubtitle = 'by infobit.cloud';
  static const String copyright = '(c) 2025 infobit.cloud';
  static const String website = 'www.infobit.cloud';
  static const String websiteUrl = 'https://www.infobit.cloud';

  static const List<String> radioBrowserServers = [
    'https://de1.api.radio-browser.info/json',
    'https://nl1.api.radio-browser.info/json',
    'https://at1.api.radio-browser.info/json',
    'https://ch1.api.radio-browser.info/json',
  ];

  static const String cacheBoxName = 'cache';
  static const String favoritesBoxName = 'favorites';
  static const String recentBoxName = 'recent';
  static const String settingsBoxName = 'settings';
  static const String settingsLocaleKey = 'locale';
  static const String settingsThemeKey = 'theme';
  static const int cacheTtlHours = 24;
  static const int maxRecentStations = 20;
  static const int apiTimeoutSeconds = 15;
  static const int apiRetryCount = 2;
  static const String defaultStationName = 'Radio Arcobaleno';
  static const String defaultStationUrl =
      'https://streamingv2.shoutcast.com/radio-arcobaleno';
  static const String defaultStationCountry = 'Italy';
  static const String defaultStationGenre = 'Variety';
  static const String defaultStationFavicon = '';
}
