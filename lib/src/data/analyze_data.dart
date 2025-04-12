import 'analyze_dependency_data.dart';

enum AnalyzeType { package, plugin, app }

/// Результаты анализа
class AnalyzeData {
  /// Тип анализа
  final AnalyzeType type;

  /// Название
  final String? name;

  late final List<PluginDependency> plugins;
  late final List<PluginDependency> auroraPlugins;
  late final List<PackageDependOfPlugin> packageWithDepends;
  late final List<UnanalizedDependency> nonAnalize;
  late final List<SDKDependency> sdkPackages;
  late final List<PackageDependency> packages;

// TODO добавить статистику для анализа

  AnalyzeData({
    required this.type,
    required this.name,
    required List<CheckedDependency> analizePackages,
  }) {
    plugins = analizePackages
        .whereType<PluginDependency>()
        .where((e) => !e.hasAuroraImpl)
        .toList();

    auroraPlugins = analizePackages
        .whereType<PluginDependency>()
        .where((e) => e.hasAuroraImpl)
        .toList();

    packageWithDepends =
        analizePackages.whereType<PackageDependOfPlugin>().toList();

    nonAnalize = analizePackages.whereType<UnanalizedDependency>().toList();

    sdkPackages = analizePackages.whereType<SDKDependency>().toList();

    packages = analizePackages.whereType<PackageDependency>().toList();
  }
}
