import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtubesearch/data/model/detail/model_detail.dart';
import 'package:youtubesearch/data/model/detail/youtube_video_response.dart';
import 'package:youtubesearch/data/model/search/model_search.dart';
import 'package:youtubesearch/network/api_key.dart';

const int MAX_SEARCH_RESULT = 5; 

class YoutubeDataSource {
  final http.Client client;

  final String _searchBaseUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet' + 
  '&maxResults=$MAX_SEARCH_RESULT&type=video&key=$API_KEY';
  
  final String _videoBaseUrl =
      'https://www.googleapis.com/youtube/v3/videos?part=snippet&key=$API_KEY';

  YoutubeDataSource(this.client);

  Future<YoutubeSearchResult> searchVideos({
    String query,
    String pageToken = '',
  }) async {
      final urlRaw = _searchBaseUrl + 
      '&q=$query' + (pageToken.isNotEmpty ? '&pageToken=$pageToken' : '');

      final urlEncoded = Uri.encodeFull(urlRaw);
      final response = await client.get(urlEncoded);

      if (response.statusCode == 200) {
        return YoutubeSearchResult.fromJson(response.body);
      } else {
        throw YoutubeSearchError(json.decode(response.body)['error']['message']);
      } 
  }

  Future<YoutubeVideoResponse> fetchVideoInfo({String id}) async {
      final url = _videoBaseUrl + '&id=$id';
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return YoutubeVideoResponse.fromJson(response.body);
      } else {
        throw YoutubeVideoError(json.decode(json.decode(response.body)['error']['message']));
      }
  }
}