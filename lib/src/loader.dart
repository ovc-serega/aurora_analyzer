import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'data/avrora_data.dart';
import 'data/pub_dev_data.dart';
import 'exceptions.dart';
import 'utils.dart';

class Loader {
  static const String _pubDev = "https://pub.dev/api/packages/";
  static const String _auroraData =
      "https://raw.githubusercontent.com/ovc-serega/aurora_analyzer/refs/heads/packages/packages.yaml";

  /// Загружаем файл по ссылке

  static Future<String> _fetchData(String url) async {
    var uri = Uri.parse(url);

    // Выполнение GET-запроса
    var response = await http.get(uri);

    // Проверка статуса ответа
    if (response.statusCode != 200) {
      // Если не успешно
      throw DataFetchException(
        code: response.statusCode,
        url: url,
      );
    }

    // Если запрос успешен, парсим JSON

    return response.body;
  }

  /// Получаем pubspec с репозитория pub get
  static Future<Pubspec> getPubspecFromPubdev(String name) async {
    var result = await _fetchData("$_pubDev$name");

    var data = PubDevData.fromJson(jsonDecode(result));
    var yaml = Utils.convertJsonToYaml(data.latest.pubspec);

    return Pubspec.parse(yaml);
  }

  /// Получить pubspec по ссылкам из репозитория
  static Future<Pubspec> getPubspecFromGitRepository(List<String> urls) async {
    String? result;
    for (var url in urls) {
      try {
        result = await _fetchData(url);
        // если смогли получить данные прерывваем цикл
        break;
      } on DataFetchException catch (_) {
        // Если ошибка загрузки, то продолжаем поиск
        continue;
      }
    }

    if (result == null) {
      throw PackageUrlNotFoundException();
    }

    try {
      var pubspec = Pubspec.parse(result);

      return pubspec;
    } catch (e) {
      throw PubspecParseException();
    }
  }

  /// Загружаем список аналогов пакетов для Авроры
  static Future<AuroraData?> getAuroraPackages() async {
    try {
      var result = await _fetchData(_auroraData);

      return AuroraData.fromYaml(result);
    } on DataFetchException catch (_) {
      print(
          "Error occurred when uploading data about plug-ins for the Aurora OS");
      return null;
    }
  }
}
