import 'package:pubspec_parse/pubspec_parse.dart';

extension ToStr on Pubspec {
  String toStr() {
    final buffer = StringBuffer();

    // Доступ к данным
    buffer.writeln('Имя проекта: $name');
    buffer.writeln('Версия: $version');
    buffer.writeln('Описание: $description');

    // Зависимости
    buffer.writeln('\nЗависимости:');
    dependencies.forEach((name, dependency) {
      if (dependency is HostedDependency) {
        buffer.writeln('$name: ${dependency.version}');
      } else if (dependency is GitDependency) {
        buffer.writeln('$name: Git (${dependency.url})');
      } else if (dependency is PathDependency) {
        buffer.writeln('$name: Path (${dependency.path})');
      } else if (dependency is SdkDependency) {
        buffer.writeln('$name: SDK (${dependency.sdk})');
      }
    });

    // Dev-зависимости
    if (devDependencies.isNotEmpty) {
      buffer.writeln('\nDev-зависимости:');
      devDependencies.forEach((name, dependency) {
        if (dependency is HostedDependency) {
          buffer.writeln('$name: ${dependency.version}');
        } else if (dependency is GitDependency) {
          buffer.writeln('$name: Git (${dependency.url})');
        } else if (dependency is PathDependency) {
          buffer.writeln('$name: Path (${dependency.path})');
        } else if (dependency is SdkDependency) {
          buffer.writeln('$name: SDK (${dependency.sdk})');
        }
      });
    }

    return buffer.toString();
  }
}
