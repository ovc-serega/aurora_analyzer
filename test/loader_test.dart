import 'package:aurora_analyzer/src/data/avrora_data.dart';
import 'package:aurora_analyzer/src/exceptions.dart';
import 'package:aurora_analyzer/src/loader.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group("Test getPubspecFromPubdev", () {
    test('Load package data successful', () async {
      var pubspec = await Loader.getPubspecFromPubdev("analyzer");
      expect(pubspec.name, "analyzer");
      expect(pubspec.repository.toString(),
          "https://github.com/dart-lang/sdk/tree/main/pkg/analyzer");
    });

    test('Load package data error', () async {
      expect(() async => await Loader.getPubspecFromPubdev("analyzer1"),
          throwsA(isA<DataFetchException>()));
    });

    test('Load package data successful 2', () async {
      var pubspec = await Loader.getPubspecFromPubdev("native_device_orientation");
      expect(pubspec.name, "native_device_orientation");
      expect(pubspec.description, isNotEmpty);
    });

    
  });

  group("Test getPubspecFromGitRepository", () {
    test("Load analizer pubspec by git", () async {
      var pubspec = await Loader.getPubspecFromGitRepository([
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/analyzer/pubspec.yaml"
      ]);

      expect(pubspec.name, "analyzer");
      expect(pubspec.repository.toString(),
          "https://github.com/dart-lang/sdk/tree/main/pkg/analyzer");
    });

    test("Load analizer pubspec by git error", () async {
      var func = Loader.getPubspecFromGitRepository([
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/analyzer1/pubspec.yaml"
      ]);

      expect(
          () async => await func, throwsA(isA<PackageUrlNotFoundException>()));
    });

    test("Load analizer pubspec by git multi", () async {
      var urls = [
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/master/pkg/analyzer/pubspec.yaml",
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/analyzer/pubspec.yaml",
      ];

      var pubspec = await Loader.getPubspecFromGitRepository(urls);

      expect(pubspec.name, "analyzer");
      expect(pubspec.repository.toString(),
          "https://github.com/dart-lang/sdk/tree/main/pkg/analyzer");
    });

    test("Load analizer pubspec by git multi error", () async {
      var urls = [
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/master/pkg/analyzer1/pubspec.yaml",
        "https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/analyzer1/pubspec.yaml",
      ];

      var func = Loader.getPubspecFromGitRepository(urls);

      expect(
          () async => await func, throwsA(isA<PackageUrlNotFoundException>()));
    });

    test("Load not pubspec file", () async {
      var func = Loader.getPubspecFromGitRepository([
        "https://raw.githubusercontent.com/fluttercommunity/plus_plugins/refs/heads/main/packages/connectivity_plus/connectivity_plus/LICENSE"
      ]);

      expect(() async => await func, throwsA(isA<PubspecParseException>()));
    });
  });

  group("Aurora packages", () {
    final name = "test";
    final url = "test_url";
    final original = "test_aurora";
    final testMap = {
      'name': name,
      'url': url,
      'original_package': original,
    };

    test("Test parse AuroraPackageData", () {
      var yMap = YamlMap.wrap(testMap);

      var data = AuroraPackage.fromYaml(yMap);

      expect(data.name, name);
      expect(data.url, url);
      expect(data.original, original);
    });

    test("Test parse AuroraData", () {
      var yDataMap = YamlMap.wrap(testMap);

      var yMap = YamlMap.wrap({
        'aurora_packages': YamlList.wrap([yDataMap, yDataMap])
      });

      var data = AuroraData.fromYaml(yMap.toString());

      expect(data.packages, isNotEmpty);
      expect(data.packages.length, 2);
      var package = data.packages[0];

      expect(package.name, name);
      expect(package.url, url);
      expect(package.original, original);
    });

    test("Load aurora package", () async {
      var result = await Loader.getAuroraPackages();

      expect(result, isNotNull);
      expect(result!.packages, isNotEmpty);
    });
  });
}
