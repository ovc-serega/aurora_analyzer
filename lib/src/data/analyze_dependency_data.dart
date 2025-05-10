import 'package:pubspec_parse/pubspec_parse.dart';

import 'avrora_data.dart';

/// Базовый класс для проверренной зависимости
sealed class CheckedDependency {
  /// Название
  final String name;

  /// url|адрес
  final String path;

  CheckedDependency({
    required this.name,
    required this.path,
  });

  List<String> toList() {
    return [name, path];
  }
}

/// Данные пакета
class PackageDependency extends CheckedDependency {
  /// pubspec пакета для рекурсивного анализа
  Pubspec pubspec;

  PackageDependency(
      {required super.name, required super.path, required this.pubspec});
}

/// Данные плагина
class PluginDependency extends CheckedDependency {
  /// pubspec пакета для рекурсивного анализа
  Pubspec pubspec;

  /// Реализация пакета для Авроры
  AuroraPackage? _auroraPackage;
  set auroraPackage(AuroraPackage auroraPackage) =>
      _auroraPackage = auroraPackage;

  /// Имеет ли данные об реализации под Аврору
  bool get hasAuroraImpl => _auroraPackage != null;

  PluginDependency({required super.name, required super.path, required this.pubspec});

  @override
  List<String> toList() {
    if (hasAuroraImpl) {
      return super.toList()
        ..addAll([_auroraPackage!.name, _auroraPackage!.url]);
    } else {
      return super.toList();
    }
  }
}

/// Данные пакета с зависимотями от плагинов
class PackageDependOfPlugin extends CheckedDependency {
  // Список плагинов с зависимостями
  List<List<CheckedDependency>> plugins = [];
  PackageDependOfPlugin({
    required super.name,
    required super.path,
    required this.plugins,
  });

  factory PackageDependOfPlugin.fromPackage(
      PackageDependency dependency, List<List<CheckedDependency>> plugins) {
    return PackageDependOfPlugin(
      name: dependency.name,
      path: dependency.path,
      plugins: plugins,
    );
  }

  @override
  List<String> toList() {
    var buffer = StringBuffer();
    for (var pluginPath in plugins) {
      buffer.writeln(pluginPath.map((d) => d.name).join(' <- '));
    }
    return super.toList()..add(buffer.toString());
  }
}

/// Данные пакетов SDK
class SDKDependency extends CheckedDependency {
  SDKDependency({required super.name, required super.path});
}

/// Непроанализированные пакеты
class UnanalizedDependency extends CheckedDependency {
  /// Причина
  String? reason;

  UnanalizedDependency({required super.name, required super.path});

  @override
  List<String> toList() {
    return super.toList()..add(reason ?? "-");
  }
}
