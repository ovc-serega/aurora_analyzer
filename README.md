# aurora_analizer
Analyzer for flutter applications for Aurora OS

### Main features:
- Analyzing pubspec files
- Analyzing pubspec package for pub.dev
- Checking the availability of plugins for the Aurora OS
- Report generation

## Usage

Select one of the scenarios to use:

### Analize pubspec file

```sh
dart run lib/main.dart -f <path_to_pubspec>
```

### Analize pubspec package

```sh
dart run lib/main.dart -p --path <package_name>
```

### Optional flags
 - `-o` - Generating a report in md format


 ## Example report
 ```
# App: test

## Plugins:
| № | Name                      | Url                                                                             |
|---|---------------------------|---------------------------------------------------------------------------------|
| 1 | native_device_orientation | https://pub.dev/packages/native_device_orientation                              |


## Aurora implemented plugins:
| № | Name               | Url                                         | Aurora name               | Aurora url                                                                                                                  |
|---|--------------------|---------------------------------------------|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| 1 | vibration          | https://pub.dev/packages/vibration          | vibration_aurora          | https://gitlab.com/omprussia/flutter/flutter-community-plugins/vibration_aurora                                             |
| 2 | shared_preferences | https://pub.dev/packages/shared_preferences | shared_preferences_aurora | https://gitlab.com/omprussia/flutter/flutter/-/tree/stable/packages/shared_preferences_aurora                               |
                                  |


## Sdk packages:
| № | Name    | Path        |
|---|---------|-------------|
| 1 | flutter | Flutter sdk |


## Packages:
| № | Name             | Url                                                 |
|---|------------------|-----------------------------------------------------|
| 1 | envied           | https://pub.dev/packages/envied                     |
| 2 | provider         | https://pub.dev/packages/provider                   |

 ```