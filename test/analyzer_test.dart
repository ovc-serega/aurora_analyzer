import 'package:aurora_analyzer/src/analyzer.dart';
import 'package:test/test.dart';

void main() {
  group('Analyze package', () {
    test('Analyze analyzer package', () async {
      var analyze = await Analyzer().analizePackage('connectivity_plus');
      expect(analyze.name, "connectivity_plus");
      expect(analyze.sdkPackages.length, 2);
      expect(analyze.packages.length, 5);
    });

    test('Analyze flutter_local_notifications package', () async {
      var analyze =
          await Analyzer().analizePackage('flutter_local_notifications');
      expect(analyze.name, "flutter_local_notifications");
      expect(analyze.sdkPackages.length, 1);
      expect(analyze.plugins.length, 2);
      expect(analyze.packages.length, 3);
    });

    test('Recursive check package', () async {
      var analyze = await Analyzer().analizePackage('supabase_flutter');

      expect(analyze.name, "supabase_flutter");
      expect(analyze.sdkPackages.length, 1);
      expect(analyze.plugins.length + analyze.auroraPlugins.length, 4);
      expect(analyze.packages.length, 7);
    });
  });

  group('Analyze file', () {
    test("analyze pubspec", () async {
      var analyze = await Analyzer().analizeFile('./test/assets/test.yaml');

      expect(analyze.name, "test");
      expect(analyze.sdkPackages.length, 1);
      expect(analyze.plugins.length + analyze.auroraPlugins.length, 11);
      expect(analyze.packages.length, 7);
    });

    test('Analize pubspec with packages depend of plugins ', () async {
      var analyze =
          await Analyzer().analizeFile('./test/assets/recursive_test.yaml');

      expect(analyze.name, "recursive_test");
      expect(analyze.sdkPackages.length, 1);
      expect(analyze.packageWithDepends.length, 1);
      expect(analyze.packages.length, 1);
    });
  });
}
