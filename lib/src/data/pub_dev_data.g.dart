// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pub_dev_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PubDevData _$PubDevDataFromJson(Map<String, dynamic> json) => PubDevData(
      json['name'] as String,
      LatestData.fromJson(json['latest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PubDevDataToJson(PubDevData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latest': instance.latest,
    };

LatestData _$LatestDataFromJson(Map<String, dynamic> json) => LatestData(
      json['version'] as String,
      json['pubspec'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LatestDataToJson(LatestData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pubspec': instance.pubspec,
    };
