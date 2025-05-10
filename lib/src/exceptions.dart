/// Исключение на случай если не смогли загрузить данные пакета
class DataFetchException implements Exception {
  /// url пакета
  final String url;

  /// код ошибки
  final int code;

  DataFetchException({required this.url, required this.code});

  @override
  String toString() => "DataFetchException: url: $url code: $code";
}

/// Исключение на случай если не смогли загрузить данные пакета
class PackageUrlNotFoundException implements Exception {}

/// Исключение на случай если пакет не получилось разобрать
class PubspecParseException implements Exception {
  /// Ошибочная ссылка
  late final String url;
}
