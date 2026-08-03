import 'dart:convert';

class RadioStation {
  final String stationuuid;
  final String name;
  final String url;
  final String urlResolved;
  final String homepage;
  final String favicon;
  final String tags;
  final String country;
  final String countryCode;
  final String state;
  final String language;
  final int votes;
  final int bitrate;
  final String codec;
  final String lastchangetime;
  final bool lastcheckok;
  final String clicktimestamp;
  final int clickcount;
  final int clicktrend;

  RadioStation({
    this.stationuuid = '',
    this.name = '',
    this.url = '',
    this.urlResolved = '',
    this.homepage = '',
    this.favicon = '',
    this.tags = '',
    this.country = '',
    this.countryCode = '',
    this.state = '',
    this.language = '',
    this.votes = 0,
    this.bitrate = 0,
    this.codec = '',
    this.lastchangetime = '',
    this.lastcheckok = true,
    this.clicktimestamp = '',
    this.clickcount = 0,
    this.clicktrend = 0,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      stationuuid: json['stationuuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      urlResolved: json['url_resolved']?.toString() ?? '',
      homepage: json['homepage']?.toString() ?? '',
      favicon: json['favicon']?.toString() ?? '',
      tags: json['tags']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      countryCode: json['countrycode']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      votes: json['votes'] is int ? json['votes'] as int : 0,
      bitrate: json['bitrate'] is int ? json['bitrate'] as int : 0,
      codec: json['codec']?.toString() ?? '',
      lastchangetime: json['lastchangetime']?.toString() ?? '',
      lastcheckok: json['lastcheckok']?.toString().toLowerCase() == 'true' ||
          json['lastcheckok'] == true,
      clicktimestamp: json['clicktimestamp']?.toString() ?? '',
      clickcount:
          json['clickcount'] is int ? json['clickcount'] as int : 0,
      clicktrend: json['clicktrend'] is int ? json['clicktrend'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationuuid': stationuuid,
      'name': name,
      'url': url,
      'url_resolved': urlResolved,
      'homepage': homepage,
      'favicon': favicon,
      'tags': tags,
      'country': country,
      'countrycode': countryCode,
      'state': state,
      'language': language,
      'votes': votes,
      'bitrate': bitrate,
      'codec': codec,
      'lastchangetime': lastchangetime,
      'lastcheckok': lastcheckok.toString(),
      'clicktimestamp': clicktimestamp,
      'clickcount': clickcount,
      'clicktrend': clicktrend,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'stationuuid': stationuuid,
      'name': name,
      'url': url,
      'url_resolved': urlResolved,
      'homepage': homepage,
      'favicon': favicon,
      'tags': tags,
      'country': country,
      'countrycode': countryCode,
      'state': state,
      'language': language,
      'votes': votes,
      'bitrate': bitrate,
      'codec': codec,
      'lastchangetime': lastchangetime,
      'lastcheckok': lastcheckok,
      'clicktimestamp': clicktimestamp,
      'clickcount': clickcount,
      'clicktrend': clicktrend,
    };
  }

  factory RadioStation.fromMap(Map<String, dynamic> map) {
    return RadioStation(
      stationuuid: map['stationuuid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      urlResolved: map['url_resolved']?.toString() ?? '',
      homepage: map['homepage']?.toString() ?? '',
      favicon: map['favicon']?.toString() ?? '',
      tags: map['tags']?.toString() ?? '',
      country: map['country']?.toString() ?? '',
      countryCode: map['countrycode']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      language: map['language']?.toString() ?? '',
      votes: map['votes'] is int ? map['votes'] as int : 0,
      bitrate: map['bitrate'] is int ? map['bitrate'] as int : 0,
      codec: map['codec']?.toString() ?? '',
      lastchangetime: map['lastchangetime']?.toString() ?? '',
      lastcheckok: map['lastcheckok'] is bool
          ? map['lastcheckok'] as bool
          : map['lastcheckok']?.toString().toLowerCase() == 'true',
      clicktimestamp: map['clicktimestamp']?.toString() ?? '',
      clickcount: map['clickcount'] is int ? map['clickcount'] as int : 0,
      clicktrend: map['clicktrend'] is int ? map['clicktrend'] as int : 0,
    );
  }

  String get streamUrl => urlResolved.isNotEmpty ? urlResolved : url;

  String get displayTags {
    if (tags.isEmpty) return '';
    final tagList = tags.split(',').where((t) => t.trim().isNotEmpty).toList();
    if (tagList.isEmpty) return '';
    return tagList.take(3).join(', ');
  }

  String get displayBitrate => bitrate > 0 ? '${bitrate}kbps' : '';

  String get displayCountry => country.isNotEmpty ? country : '';

  String get displayLanguage => language.isNotEmpty ? language : '';

  RadioStation copyWith({
    String? stationuuid,
    String? name,
    String? url,
    String? urlResolved,
    String? homepage,
    String? favicon,
    String? tags,
    String? country,
    String? countryCode,
    String? state,
    String? language,
    int? votes,
    int? bitrate,
    String? codec,
    String? lastchangetime,
    bool? lastcheckok,
    String? clicktimestamp,
    int? clickcount,
    int? clicktrend,
  }) {
    return RadioStation(
      stationuuid: stationuuid ?? this.stationuuid,
      name: name ?? this.name,
      url: url ?? this.url,
      urlResolved: urlResolved ?? this.urlResolved,
      homepage: homepage ?? this.homepage,
      favicon: favicon ?? this.favicon,
      tags: tags ?? this.tags,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      state: state ?? this.state,
      language: language ?? this.language,
      votes: votes ?? this.votes,
      bitrate: bitrate ?? this.bitrate,
      codec: codec ?? this.codec,
      lastchangetime: lastchangetime ?? this.lastchangetime,
      lastcheckok: lastcheckok ?? this.lastcheckok,
      clicktimestamp: clicktimestamp ?? this.clicktimestamp,
      clickcount: clickcount ?? this.clickcount,
      clicktrend: clicktrend ?? this.clicktrend,
    );
  }

  @override
  String toString() => 'RadioStation(name: $name, country: $country)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioStation && other.stationuuid == stationuuid;
  }

  @override
  int get hashCode => stationuuid.hashCode;
}
