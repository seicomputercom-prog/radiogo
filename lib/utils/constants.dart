class AppConstants {
  static const String appName = 'RadioGo';
  static const String appSubtitle = 'by infobit.cloud';
  static const String copyright =
      'Copyright \u00a9 by Salvatore Ingu\u00ec - Since 1989 - WWW.INFOBIT.CLOUD -';
  static const String copyrightShort =
      'Copyright \u00a9 by Salvatore Ingu\u00ec - Since 1989 -';
  static const String website = 'WWW.INFOBIT.CLOUD';
  static const String websiteUrl = 'https://www.infobit.cloud';

  static const List<String> radioBrowserServers = [
    'https://de1.api.radio-browser.info',
    'https://nl1.api.radio-browser.info',
    'https://at1.api.radio-browser.info',
    'https://ch1.api.radio-browser.info',
    'https://all.api.radio-browser.info',
  ];

  static const String cacheBoxName = 'cache';
  static const String favoritesBoxName = 'favorites';
  static const String recentBoxName = 'recent';
  static const String settingsBoxName = 'settings';
  static const String settingsLocaleKey = 'locale';
  static const String settingsThemeKey = 'theme';
  static const int cacheTtlHours = 24;
  static const int maxRecentStations = 20;
  static const int apiTimeoutSeconds = 8;
  static const int apiRetryCount = 1;
  static const String defaultStationName = 'Radio Arcobaleno';
  static const String defaultStationUrl =
      'https://streamingv2.shoutcast.com/radio-arcobaleno';
  static const String defaultStationCountry = 'Italy';
  static const String defaultStationGenre = 'Variety';
  static const String defaultStationFavicon = '';
}
