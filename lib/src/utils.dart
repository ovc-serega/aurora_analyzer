import 'package:json2yaml/json2yaml.dart';

class Utils {
  static String convertJsonToYaml(Map<String, dynamic> json) {
   
   // дублируем одинарную кавычку, что бы преобразование не сломалось
    if (json.containsKey('description')) {
      json['description'] =
          json['description'].toString().replaceAll("'", "''");
    }
    return json2yaml(json, yamlStyle: YamlStyle.pubspecYaml);
  }

  static getPubDevPackageUrl(String name) => "  https://pub.dev/packages/$name";

  static String replaceMainWithMaster(String url) {
    return url.replaceAll('/main/', '/master/');
  }
}
