import 'dart:convert';

import 'package:acr_cloud_sdk_example/core/models/deezer_song_model.dart';
import 'package:acr_cloud_sdk_example/core/network_layer/failure/failure.dart';
import 'package:acr_cloud_sdk_example/core/network_layer/helper/api_helper.dart';
import 'package:dartz/dartz.dart' show Either, Right, Left;

import '../base_repository.dart';

class SongAPI extends BaseRepository {
  final apiHelper = ApiHelper();

  Future<Either<Failure, DeezerSongModel>> dataFromDeezer(String? id) async {
    return _dataFromDeezer(id);
  }

  Future<Either<Failure, DeezerSongModel>> _dataFromDeezer(String? id) async {
    try {
      var headers = {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8',
      };
      final response = await apiHelper.get(
        url: 'https://api.deezer.com/track/$id',
        headers: headers,
      );

      if (response.contains('title'))
        return Right(DeezerSongModel.fromJson(json.decode(response)));
      else
        return Left(ServerFailure(message: response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
