import 'package:args/args.dart';
import 'src/analyzer.dart';
import 'src/report_generator.dart';
import 'src/data/analyze_data.dart';

void main(List<String> arguments) async {
  print("The package analyzer for the Aurora OS has been launched!");

  final parser = ArgParser()
    ..addOption(
      "file",
      abbr: 'f',
      help: 'Select the pubspec file for analysis',
    )
    ..addOption(
      'package',
      abbr: 'p',
      help: "Select a package with pubdev for analysis",
    )
    ..addFlag(
      'output',
      abbr: 'o',
      help: 'Output to md file',
      defaultsTo: false,
    );

  try {
    final parseArgs = parser.parse(arguments);
    final String? fileName = parseArgs['file'];
    final String? package = parseArgs['package'];

    var analizator = Analyzer();
    AnalyzeData? result;
    if (fileName != null) {
      print("The file will be analyzed: $fileName");

      result = await analizator.analizeFile(fileName);
    } else if (package != null) {
      print("The package will be analyzed: $package");

      result = await analizator.analizePackage(package);
    } else {
      throw ArgumentError('Empty package and pubspec argument');
    }
    print("The analysis is completed");

    ReportGenarator.generateReport(result, parseArgs.wasParsed('output'));
  } on ArgumentError catch (e) {
    print(e.message);
  } on FormatException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}
