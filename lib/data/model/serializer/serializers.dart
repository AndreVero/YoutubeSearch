library serializers;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:youtubesearch/data/model/common/model_common.dart';
import 'package:youtubesearch/data/model/detail/model_detail.dart';
import 'package:youtubesearch/data/model/search/model_search.dart';

part 'serializers.g.dart';

@SerializersFor(const [
YoutubeSearchResult,
SearchItem,
Id,
SearchSnippet,
Thumbnails,
Thumbnail,
YoutubeVideoResponse,
VideoItem,
VideoSnippet
])
final Serializers serializers 
= (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();