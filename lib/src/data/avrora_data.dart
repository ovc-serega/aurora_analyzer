import 'package:yaml/yaml.dart';

class AuroraData {
  List<AuroraPackage> packages;

  AuroraData({required this.packages});

  factory AuroraData.fromYaml(String yaml) {
    final yamlMap = loadYaml(yaml) as YamlMap;

    final packages = (yamlMap['aurora_packages'] as YamlList)
        .map((item) => AuroraPackage.fromYaml(item as YamlMap))
        .toList();

    return AuroraData(packages: packages);
  }
}

class AuroraPackage {
  final String name;
  final String original;
  final String url;

  const AuroraPackage(
      {required this.name, required this.original, required this.url});

  factory AuroraPackage.fromYaml(YamlMap yaml) {
    return AuroraPackage(
      name: _getStringFromYaml(yaml, 'name'),
      url: _getStringFromYaml(yaml, 'url'),
      original: _getStringFromYaml(yaml, 'original_package'),
    );
  }

  static String _getStringFromYaml(YamlMap yaml, String key) {
    final value = yaml[key];
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    return value.toString();
  }
}
