import 'dart:convert';

/// ACRCloud Music Metadata
///
/// https://docs.acrcloud.com/docs/acrcloud/metadata/music/
///
class SongModel {
  /// Response Status
  Status? status;

  /// Response metadata
  Metadata? metadata;

  /// Response  resultType
  int? resultType;

  double? costTime;

  SongModel({this.status, this.metadata, this.resultType, this.costTime});

  SongModel.fromJson(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    resultType = json['result_type'];
    costTime = json['cost_time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status?.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    data['result_type'] = resultType;
    data['cost_time'] = costTime;
    return data;
  }
}

class Status {
  String? msg;
  String? version;
  int? code;

  Status({this.msg, this.version, this.code});

  Status.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    version = json['version'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['version'] = version;
    data['code'] = code;
    return data;
  }
}

class Metadata {
  List<Music>? music;
  String? timestampUtc;

  Metadata({this.music, this.timestampUtc});

  Metadata.fromJson(Map<String, dynamic> json) {
    if (json['music'] != null) {
      music = <Music>[];
      json['music'].forEach((v) {
        music?.add(Music.fromJson(v));
      });
    }
    timestampUtc = json['timestamp_utc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (music != null) {
      data['music'] = music?.map((v) => v.toJson()).toList();
    }
    data['timestamp_utc'] = timestampUtc;
    return data;
  }
}

class Music {
  /// Music label information
  String? label;

  /// External 3rd party IDs and metadata
  ExternalMetadata? externalMetadata;

  /// ACRCloud unique identifier
  String? acrid;

  /// Album fields
  Album? album;

  int? resultFrom;

  /// Artists fields
  List<Artists>? artists;

  /// Track title
  String? title;

  /// Duration of the track in millisecond
  int? durationMs;

  /// Release data of the track, format:YYYY-MM-DD
  String? releaseDate;

  /// Match confidence score.
  /// Range: 70 - 100
  int? score;

  /// The time position of the audio/song being played (millisecond)
  int? playOffsetMs;

  Music(
      {this.label,
      this.externalMetadata,
      this.acrid,
      this.album,
      this.resultFrom,
      this.artists,
      this.title,
      this.durationMs,
      this.releaseDate,
      this.score,
      this.playOffsetMs});

  Music.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    externalMetadata = json['external_metadata'] != null
        ? ExternalMetadata.fromJson(json['external_metadata'])
        : null;
    acrid = json['acrid'];
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    resultFrom = json['result_from'];
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists?.add(Artists.fromJson(v));
      });
    }
    title = json['title'];
    durationMs = json['duration_ms'];
    releaseDate = json['release_date'];
    score = json['score'];
    playOffsetMs = json['play_offset_ms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    if (externalMetadata != null) {
      data['external_metadata'] = externalMetadata?.toJson();
    }
    data['acrid'] = acrid;
    if (album != null) {
      data['album'] = album?.toJson();
    }
    data['result_from'] = resultFrom;
    if (artists != null) {
      data['artists'] = artists?.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['duration_ms'] = durationMs;
    data['release_date'] = releaseDate;
    data['score'] = score;
    data['play_offset_ms'] = playOffsetMs;

    return data;
  }
}

class ExternalMetadata {
  /// Spotify fields
  Spotify? spotify;

  /// Deezer fields
  Deezer? deezer;

  ExternalMetadata({this.spotify, this.deezer});

  ExternalMetadata.fromJson(Map<String, dynamic> json) {
    spotify =
        json['spotify'] != null ? Spotify.fromJson(json['spotify']) : null;
    deezer = json['deezer'] != null ? Deezer.fromJson(json['deezer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (spotify != null) {
      data['spotify'] = spotify?.toJson();
    }
    if (deezer != null) {
      data['deezer'] = deezer?.toJson();
    }
    return data;
  }
}

class Album {
  String? name;

  Album({this.name});

  Album.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Artists {
  String? name;

  Artists({this.name});

  Artists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Spotify {
  SpotifyAlbum? album;
  List<SpotifyArtists>? artists;
  Track? track;

  Spotify({this.album, this.artists, this.track});

  Spotify.fromJson(Map<String, dynamic> json) {
    album = json['album'] != null ? SpotifyAlbum.fromJson(json['album']) : null;
    if (json['artists'] != null) {
      artists = <SpotifyArtists>[];
      json['artists'].forEach((v) {
        artists?.add(SpotifyArtists.fromJson(v));
      });
    }
    track = json['track'] != null ? Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (album != null) {
      data['album'] = album?.toJson();
    }
    if (artists != null) {
      data['artists'] = artists?.map((v) => v.toJson()).toList();
    }
    if (track != null) {
      data['track'] = track?.toJson();
    }
    return data;
  }
}

class SpotifyAlbum {
  /// Name of the album
  dynamic name;

  // ID of the album
  dynamic id;

  SpotifyAlbum({this.name, this.id});

  SpotifyAlbum.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class SpotifyArtists {
  /// Name of the artists
  dynamic name;

  // ID of the artists
  dynamic id;

  SpotifyArtists({this.name, this.id});

  SpotifyArtists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class Deezer {
  DeezerAlbum? deezerAlbum;
  List<DeezerArtists>? deezerArtists;
  Track? track;

  Deezer({this.deezerAlbum, this.deezerArtists, this.track});

  Deezer.fromJson(Map<String, dynamic> json) {
    deezerAlbum = json['deezer_album'] != null
        ? DeezerAlbum.fromJson(json['deezer_album'])
        : null;
    if (json['artists'] != null) {
      deezerArtists = <DeezerArtists>[];
      json['artists'].forEach((v) {
        deezerArtists?.add(DeezerArtists.fromJson(v));
      });
    }
    track = json['track'] != null ? Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deezerAlbum != null) {
      data['album'] = deezerAlbum?.toJson();
    }
    if (deezerArtists != null) {
      data['artists'] = deezerArtists?.map((v) => v.toJson()).toList();
    }
    if (track != null) {
      data['track'] = track?.toJson();
    }
    return data;
  }
}

class DeezerAlbum {
  int? id;

  DeezerAlbum({this.id});

  DeezerAlbum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class DeezerArtists {
  /// Name of the artists
  dynamic name;

  // ID of the artists
  dynamic id;

  DeezerArtists({this.name, this.id});

  DeezerArtists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class Track {
  /// Name of the track
  String? name;

  // ID of the track
  String? id;

  Track({this.name, this.id});

  Track.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
