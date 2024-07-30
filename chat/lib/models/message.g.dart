// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      userId: json['userId'] as String,
      text: json['text'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'text': instance.text,
      'timestamp': instance.timestamp,
    };
