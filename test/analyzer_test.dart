import 'package:aurora_analyzer/src/analyzer.dart';
import 'package:aurora_analyzer/src/report_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Analyze package', () {
// TODO доработать тесты
    test('Analyze analyzer package', () async {
      try {
        await Analyzer().analizePackage('connectivity_plus');
      } catch (e) {
        print(e);
      }
    });

    test('Analyze flutter_local_notifications package', () async {
      try {
        await Analyzer().analizePackage('flutter_local_notifications');
      } catch (e) {
        print(e);
      }
    });

    test("full test", () async {
      var analizator = Analyzer();
      var res = await analizator.analizePackage('flutter_local_notifications');
      ReportGenarator.generateReport(res);
    });
  });

  group('Analyze file', () {
    test("analyze pucspec", () async {
      var analizator = Analyzer();
      var res = await analizator.analizeFile('./test/assets/test.yaml');
      ReportGenarator.generateReport(res, false);
    });

    test("analyze pucspec to md", () async {
      var analizator = Analyzer();
      var res = await analizator.analizeFile('./test/assets/test.yaml');
      ReportGenarator.generateReport(res);
    });
  });
}
