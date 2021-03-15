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
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    resultType = json['result_type'];
    costTime = json['cost_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status?.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata?.toJson();
    }
    data['result_type'] = this.resultType;
    data['cost_time'] = this.costTime;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['version'] = this.version;
    data['code'] = this.code;
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
        music?.add(new Music.fromJson(v));
      });
    }
    timestampUtc = json['timestamp_utc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.music != null) {
      data['music'] = this.music?.map((v) => v.toJson()).toList();
    }
    data['timestamp_utc'] = this.timestampUtc;
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
        ? new ExternalMetadata.fromJson(json['external_metadata'])
        : null;
    acrid = json['acrid'];
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    resultFrom = json['result_from'];
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists?.add(new Artists.fromJson(v));
      });
    }
    title = json['title'];
    durationMs = json['duration_ms'];
    releaseDate = json['release_date'];
    score = json['score'];
    playOffsetMs = json['play_offset_ms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.externalMetadata != null) {
      data['external_metadata'] = this.externalMetadata?.toJson();
    }
    data['acrid'] = this.acrid;
    if (this.album != null) {
      data['album'] = this.album?.toJson();
    }
    data['result_from'] = this.resultFrom;
    if (this.artists != null) {
      data['artists'] = this.artists?.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['duration_ms'] = this.durationMs;
    data['release_date'] = this.releaseDate;
    data['score'] = this.score;
    data['play_offset_ms'] = this.playOffsetMs;

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
        json['spotify'] != null ? new Spotify.fromJson(json['spotify']) : null;
    deezer =
        json['deezer'] != null ? new Deezer.fromJson(json['deezer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.spotify != null) {
      data['spotify'] = this.spotify?.toJson();
    }
    if (this.deezer != null) {
      data['deezer'] = this.deezer?.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Spotify {
  SpotifyAlbum? album;
  List<SpotifyArtists>? artists;
  Track? track;

  Spotify({this.album, this.artists, this.track});

  Spotify.fromJson(Map<String, dynamic> json) {
    album =
        json['album'] != null ? new SpotifyAlbum.fromJson(json['album']) : null;
    if (json['artists'] != null) {
      artists = <SpotifyArtists>[];
      json['artists'].forEach((v) {
        artists?.add(new SpotifyArtists.fromJson(v));
      });
    }
    track = json['track'] != null ? new Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.album != null) {
      data['album'] = this.album?.toJson();
    }
    if (this.artists != null) {
      data['artists'] = this.artists?.map((v) => v.toJson()).toList();
    }
    if (this.track != null) {
      data['track'] = this.track?.toJson();
    }
    return data;
  }
}

class SpotifyAlbum {
  /// Name of the album
  var name;

  // ID of the album
  var id;

  SpotifyAlbum({this.name, this.id});

  SpotifyAlbum.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class SpotifyArtists {
  /// Name of the artists
  var name;

  // ID of the artists
  var id;

  SpotifyArtists({this.name, this.id});

  SpotifyArtists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
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
        ? new DeezerAlbum.fromJson(json['deezer_album'])
        : null;
    if (json['artists'] != null) {
      deezerArtists = <DeezerArtists>[];
      json['artists'].forEach((v) {
        deezerArtists?.add(new DeezerArtists.fromJson(v));
      });
    }
    track = json['track'] != null ? new Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deezerAlbum != null) {
      data['album'] = this.deezerAlbum?.toJson();
    }
    if (this.deezerArtists != null) {
      data['artists'] = this.deezerArtists?.map((v) => v.toJson()).toList();
    }
    if (this.track != null) {
      data['track'] = this.track?.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class DeezerArtists {
  /// Name of the artists
  var name;

  // ID of the artists
  var id;

  DeezerArtists({this.name, this.id});

  DeezerArtists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
