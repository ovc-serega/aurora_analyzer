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
  PackageDependency({
    required super.name,
    required super.path,
  });
}

/// Данные плагина
class PluginDependency extends CheckedDependency {
  /// Реализация пакета для Авроры
  AuroraPackage? _auroraPackage;
  set auroraPackage(AuroraPackage auroraPackage) =>
      _auroraPackage = auroraPackage;

  /// Имеет ли данные об реализации под Аврору
  bool get hasAuroraImpl => _auroraPackage != null;

  PluginDependency({required super.name, required super.path});

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
  // Список плагинов с сылками от которых имеется зависимость
  List<(String, String)> plugins = [];
  PackageDependOfPlugin({required super.name, required super.path});

// TODO добавить вывод пакетов для анализа далее
  @override
  List<String> toList() {
    return super.toList()..add("-");
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
