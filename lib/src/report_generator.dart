import 'dart:io';

import 'package:aurora_analyzer/src/data/analyze_data.dart';
import 'package:cli_table/cli_table.dart';

class ReportGenarator {
  static void _reportToMd(AnalyzeData data) {
    final buffer = StringBuffer();

    buffer.writeln("# ${_generateHeader(data.type, data.name)}");

    List<List<String>> rowList = [];
    if (data.plugins.isNotEmpty) {
      for (var i = 0; i < data.plugins.length; i++) {
        rowList.add([(i + 1).toString(), ...data.plugins[i].toList()]);
      }
      buffer
        ..writeln("\n## Plugins:")
        ..writeln(_printMdTable(["№", "Name", "Url"], rowList));
    }

    if (data.auroraPlugins.isNotEmpty) {
      rowList = [];
      for (var i = 0; i < data.auroraPlugins.length; i++) {
        rowList.add([(i + 1).toString(), ...data.auroraPlugins[i].toList()]);
      }
      buffer
        ..writeln("\n## Aurora implemented plugins:")
        ..writeln(_printMdTable(
            ["№", "Name", "Url", "Aurora name", "Aurora url"], rowList));
    }

    if (data.packageWithDepends.isNotEmpty) {
      rowList = [];
      for (var i = 0; i < data.packageWithDepends.length; i++) {
        rowList
            .add([(i + 1).toString(), ...data.packageWithDepends[i].toList()]);
      }
      buffer
        ..writeln("\n## Packages with dependsies:")
        ..writeln(_printMdTable(["№", "Name", "Url", "Reason"], rowList));
    }

    if (data.nonAnalize.isNotEmpty) {
      rowList = [];
      for (var i = 0; i < data.nonAnalize.length; i++) {
        rowList.add([(i + 1).toString(), ...data.nonAnalize[i].toList()]);
      }
      buffer
        ..writeln("\n## Unanalyzed packages:")
        ..writeln(_printMdTable(
            ["№", "Name", "Url", "Plugin dependensies"], rowList));
    }

    if (data.sdkPackages.isNotEmpty) {
      rowList = [];
      for (var i = 0; i < data.sdkPackages.length; i++) {
        rowList.add([(i + 1).toString(), ...data.sdkPackages[i].toList()]);
      }
      buffer
        ..writeln("\n## Sdk packages:")
        ..writeln(_printMdTable(["№", "Name", "Path"], rowList));
    }

    rowList = [];
    for (var i = 0; i < data.packages.length; i++) {
      rowList.add([(i + 1).toString(), ...data.packages[i].toList()]);
    }
    buffer
      ..writeln("\n## Packages:")
      ..writeln(_printMdTable(["№", "Name", "Url"], rowList));

    final md = File('${data.name}_report.md');
    if (!md.existsSync()) {
      md.createSync();
    }
    md.writeAsStringSync(buffer.toString());

    print("The results of the analysis are saved to a file: ${md.path}");
  }

  static void _reportToConsole(AnalyzeData data) {
    final buffer = StringBuffer();
    buffer.writeln("\n${_generateHeader(data.type, data.name)}");

    if (data.plugins.isNotEmpty) {
      final pluginTable = Table(
        header: [
          {'content': 'Plugins', 'colSpan': 3, 'hAlign': HorizontalAlign.left},
        ],
        style: TableStyle(header: ['green']),
      )..add(["№", "Name", "Url"]);
      for (var i = 0; i < data.plugins.length; i++) {
        pluginTable.add([i + 1, ...data.plugins[i].toList()]);
      }
      buffer.writeln(pluginTable.toString());
    }

    if (data.auroraPlugins.isNotEmpty) {
      final auroraPluginsTable = Table(
        header: [
          {
            'content': 'Aurora implemented plugins',
            'colSpan': 5,
            'hAlign': HorizontalAlign.left
          },
        ],
        style: TableStyle(header: ['green']),
      )..add(["№", "Name", "Url", "Aurora name", "Aurora url"]);
      for (var i = 0; i < data.auroraPlugins.length; i++) {
        auroraPluginsTable.add([i + 1, ...data.auroraPlugins[i].toList()]);
      }
      buffer.writeln(auroraPluginsTable.toString());
    }

    if (data.packageWithDepends.isNotEmpty) {
      final packageWithDependsTable = Table(
        header: [
          {
            'content': 'Packages with dependsies',
            'colSpan': 4,
            'hAlign': HorizontalAlign.left
          },
        ],
        style: TableStyle(header: ['green']),
      )..add(["№", "Name", "Url", "Reason"]);
      for (var i = 0; i < data.packageWithDepends.length; i++) {
        packageWithDependsTable
            .add([i + 1, ...data.packageWithDepends[i].toList()]);
      }
      buffer.writeln(packageWithDependsTable.toString());
    }

    if (data.nonAnalize.isNotEmpty) {
      final nonAnalizeTable = Table(
        header: [
          {
            'content': 'Unanalyzed packages',
            'colSpan': 4,
            'hAlign': HorizontalAlign.left
          },
        ],
        style: TableStyle(header: ['green']),
      )..add(["№", "Name", "Url", "Plugin dependensies"]);
      for (var i = 0; i < data.nonAnalize.length; i++) {
        nonAnalizeTable.add([i + 1, ...data.nonAnalize[i].toList()]);
      }
      buffer.writeln(nonAnalizeTable.toString());
    }

    if (data.sdkPackages.isNotEmpty) {
      final sdkPackagesTable = Table(
        header: [
          {
            'content': 'Sdk packages',
            'colSpan': 3,
            'hAlign': HorizontalAlign.left
          },
        ],
        style: TableStyle(header: ['green']),
      )..add(["№", "Name", "Path"]);
      for (var i = 0; i < data.sdkPackages.length; i++) {
        sdkPackagesTable.add([i + 1, ...data.sdkPackages[i].toList()]);
      }
      buffer.writeln(sdkPackagesTable.toString());
    }

    final packagesTable = Table(
      header: [
        {'content': 'Packages', 'colSpan': 3, 'hAlign': HorizontalAlign.left},
      ],
      style: TableStyle(header: ['green']),
    )..add(["№", "Name", "Url"]);
    for (var i = 0; i < data.packages.length; i++) {
      packagesTable.add([i + 1, ...data.packages[i].toList()]);
    }
    buffer.writeln(packagesTable.toString());

    print(buffer.toString());
  }

  // Гененрируем отчёт по работе
  static generateReport(AnalyzeData data, [isMdReport = true]) {
    if (isMdReport) {
      _reportToMd(data);
    } else {
      _reportToConsole(data);
    }
  }

  static StringBuffer _printMdTable(
      List<String> headers, List<List<String>> data) {
    var buffer = StringBuffer();

    // Находим максимальные длины для каждого столбца
    List<int> columnWidths = List.filled(headers.length, 0);
    for (var row in [
      [...headers],
      ...data
    ]) {
      for (var i = 0; i < row.length; i++) {
        if (row[i].length > columnWidths[i]) {
          columnWidths[i] = row[i].length;
        }
      }
    }

    // Выводим заголовки
    var line = "";
    for (var i = 0; i < headers.length; i++) {
      line += " ${headers[i].padRight(columnWidths[i] + 1)}|";
    }
    buffer.writeln("|$line");

    // Выводим разделители
    line = "";
    for (var i = 0; i < headers.length; i++) {
      line += "${_generateSep(columnWidths[i] + 2)}|";
    }
    buffer.writeln("|$line");

    // Выводим таблицу
    for (var row in data) {
      line = "";
      for (var i = 0; i < row.length; i++) {
        line += " ${row[i].padRight(columnWidths[i] + 1)}|";
      }
      buffer.writeln("|$line");
    }

    return buffer;
  }

  static String _generateSep(int length, {String char = '-'}) {
    return List.filled(length, char).join();
  }

  /// Генерируем заголовок
  static String _generateHeader(AnalyzeType type, String? name) {
    String header = switch (type) {
      AnalyzeType.app => "App: $name",
      AnalyzeType.package => "Package: $name",
      AnalyzeType.plugin => "Plugin: $name",
    };

    return header;
  }
}
