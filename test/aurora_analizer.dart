import 'package:aurora_analyzer/src/analyzer.dart';
import 'package:aurora_analyzer/src/report_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Analyze package', () {
    test('Analyze analyzer package', () async {
      var analyze = await Analyzer().analizePackage('connectivity_plus');
      ReportGenarator.generateReport(analyze, false);
    });

    test('Analyze flutter_local_notifications package', () async {
      var analyze =
          await Analyzer().analizePackage('flutter_local_notifications');
      ReportGenarator.generateReport(analyze, false);
    });


    test('Recursive check package', () async {
      var analizator = Analyzer();
      var analyze = await analizator.analizePackage('supabase_flutter');
      ReportGenarator.generateReport(analyze, false);
    });
  });

  group('Analyze file', () {
    test("analyze pucspec", () async {
      var analyze = await Analyzer().analizeFile('./test/assets/test.yaml');
      ReportGenarator.generateReport(analyze, false);
    });

    test("analyze pucspec to md", () async {
      var analizator = Analyzer();
      var analyze = await analizator.analizeFile('./test/assets/test.yaml');
      ReportGenarator.generateReport(analyze);
    });

    test('Recursive check file', () async {
      var analizator = Analyzer();
      var analyze =
          await analizator.analizeFile('./test/assets/recursive_test.yaml');
      ReportGenarator.generateReport(analyze, false);
    });
  });
}
