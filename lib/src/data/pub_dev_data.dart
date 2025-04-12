import 'package:json_annotation/json_annotation.dart';
part 'pub_dev_data.g.dart';

@JsonSerializable()
class PubDevData {
  final String name;
  final LatestData latest;
  const PubDevData(this.name, this.latest);

  factory PubDevData.fromJson(Map<String, dynamic> json) =>
      _$PubDevDataFromJson(json);
}

@JsonSerializable()
class LatestData {
  final String version;
  final Map<String, dynamic> pubspec;
  const LatestData(this.version, this.pubspec);

  factory LatestData.fromJson(Map<String, dynamic> json) =>
      _$LatestDataFromJson(json);
}
