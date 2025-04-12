import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

import 'data/analyze_data.dart';
import 'data/analyze_dependency_data.dart';
import 'data/avrora_data.dart';
import 'exceptions.dart';
import 'loader.dart';
import 'utils.dart';

class Analyzer {
  // Название анализируемого пакета или приложения
  String? _name;

  /// Проанализированные пакеты
  List<CheckedDependency> analizePackages = [];

  /// Общий кеш проанализированных пакетов
  final Map<String, CheckedDependency> _cacheCheckedPackages = {};

  /// Анализируем файл
  Future<AnalyzeData> analizeFile(String path) async {
    final extension = path.split('.').last.toLowerCase();
    if (extension != "yaml") {
      throw FormatException("File type is not yaml");
    }

    File file = File(path);
    if (!file.existsSync()) {
      throw Exception("File not found");
    }

    var fileStr = await file.readAsString();

    // разобрали pubspec
    final pubspec = Pubspec.parse(fileStr);

    await _analizePubspec(pubspec);

    return AnalyzeData(
        type: AnalyzeType.app, name: _name, analizePackages: analizePackages);
  }

  /// Анализируем пакет
  Future<AnalyzeData> analizePackage(String packageName) async {
    final pubspec = await Loader.getPubspecFromPubdev(packageName);

    await _analizePubspec(pubspec);

    var type = AnalyzeType.package;
    if (pubspec.flutter != null && pubspec.flutter!.containsKey("plugin")) {
      type = AnalyzeType.plugin;
    }

    return AnalyzeData(
        type: type, name: _name, analizePackages: analizePackages);
  }

  /// Анализируем полученный pubspec
  Future<void> _analizePubspec(Pubspec pubspec) async {
    _name = pubspec.name;

    for (final entry in pubspec.dependencies.entries) {
      final name = entry.key;
      final dependency = entry.value;
      await _checkPackage(name, dependency);
    }

// Проверяем является ли плагином

// Проверяем наличие пакетов Аврора
    await _checkToAuroraPluginImplementations();
  }

  // Проверяем пакет, является ли плагином
  Future _checkPackage(String name, dependency) async {
    var checkedDep = await switch (dependency) {
      HostedDependency() => _checkHostedDependecy(dependency, name),
      GitDependency() => _checkGitDependecy(dependency, name),
      PathDependency() => _checkPathDependency(dependency, name),
      SdkDependency() => _checkSdkDependency(dependency, name),
      _ => throw UnsupportedError('Unsupported dependency type'),
    };

    analizePackages.add(checkedDep);
    _cacheCheckedPackages.putIfAbsent(name, () => checkedDep);
  }

  Future<CheckedDependency> _checkHostedDependecy(
      HostedDependency dependency, String name) async {
    final pubspec = await Loader.getPubspecFromPubdev(name);
    var path = Utils.getPubDevPackageUrl(name);

    if (pubspec.flutter != null) {
      if (pubspec.flutter!.containsKey("plugin")) {
        // плагин
        return PluginDependency(
          name: name,
          path: (path as String).trimLeft(),
        );
      }
    }

    return PackageDependency(
      name: name,
      path: (path as String).trimLeft(),
    );
  }

  String _removeGitExtension(String url) {
    return url.endsWith('.git') ? url.substring(0, url.length - 4) : url;
  }

  Future<CheckedDependency> _checkGitDependecy(
      GitDependency dependency, String name) async {
    List<String> urls = [];

    //TODO реализовать все варианты указания git пакета с веткой и тегов и ref

    var originUrl = dependency.url.toString();
    if (dependency.url.authority == "gitlab.com") {
      if (dependency.path == null && dependency.ref == null) {
        urls.add("$originUrl/-/raw/master/pubspec.yaml");
        urls.add("$originUrl/-/raw/main/pubspec.yaml");
      } else {
        // подрезаем кончик с ".git"
        originUrl = _removeGitExtension(originUrl);
        urls.add("$originUrl/-/raw/master/${dependency.path}/pubspec.yaml");
        urls.add("$originUrl/-/raw/main/${dependency.path}/pubspec.yaml");
      }
    } else if (dependency.url.authority == "github.com") {
      var path = _removeGitExtension(dependency.url.path);

      urls.add(
          "https://raw.githubusercontent.com$path/refs/heads/master/pubspec.yaml");
      urls.add(
          "https://raw.githubusercontent.com$path/refs/heads/main/pubspec.yaml");
    }

    try {
      var pubspec = await Loader.getPubspecFromGitRepository(urls);

      if (pubspec.flutter != null) {
        if (pubspec.flutter!.containsKey("plugin")) {
          // плагин
          return PluginDependency(name: name, path: dependency.url.toString());
        }
      }

      // иначе простой пакет
      return PackageDependency(name: name, path: dependency.url.toString());
    } on PubspecParseException catch (e) {
      // Не смогли разобрать pubspec

      return UnanalizedDependency(
        name: name,
        path: e.url,
      )..reason = "Error on parse pubspec";
    } on PackageUrlNotFoundException catch (_) {
      // По путям нет pubspec

      return UnanalizedDependency(
        name: name,
        path: dependency.url.toString(),
      )..reason = "Pubspec no found in paths: $urls";
    }
  }

  Future<CheckedDependency> _checkPathDependency(
      PathDependency dependency, String name) async {
    return UnanalizedDependency(
      name: name,
      path: dependency.path,
    )..reason = "Path depependesy not analized";
  }

  /// Проверяем зависимость SDK
  Future<CheckedDependency> _checkSdkDependency(
      SdkDependency dependency, String name) async {
    // не проверяем sdk dependency
    return SDKDependency(name: name, path: "Flutter sdk");
  }

  /// Проверяем на наличие зависимостей Aurora
  Future _checkToAuroraPluginImplementations() async {
    // Загрузить yaml с зависимостями
    var auroraData = await Loader.getAuroraPackages();
    if (auroraData == null) {
      return;
    }

    var auroraPackages = <String, AuroraPackage>{};
    for (var p in auroraData.packages) {
      auroraPackages.putIfAbsent(p.original, () => p);
    }

    // Проверяем плагины
    for (var pl in analizePackages.whereType<PluginDependency>()) {
      // если есть реализация
      if (auroraPackages.containsKey(pl.name)) {
        // сохраняем что есть реализация
        pl.auroraPackage = auroraPackages[pl.name]!;

        // обновляем кэш
        _cacheCheckedPackages[pl.name] = pl;
      }
    }
  }
}
