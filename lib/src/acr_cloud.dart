import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/song_model.dart';

/// Recognition mode
///
/// https://docs.acrcloud.com/docs/acrcloud/audio-fingerprinting-sdks/android-sdk/

enum ACRCloudRecMode {
  /// query remote db
  remote,

  /// query local db
  local,

  /// query both remote db and local db
  both,

  ///query remote db and saving recording fingerprint when offline.
  advance_remote,

  /// default mode
  default_mode
}

/// ACRCloudClient is the main class of this SDK. It provides functions of configuration management,
/// automatic audio recording and recognition, manual audio file recognition and so on.
///
class AcrCloudSdk {
  static const MethodChannel _channel =
      const MethodChannel('plugins.chizi.tech/acr_cloud_sdk');

  static const EventChannel _resultChannel =
      const EventChannel('plugins.chizi.tech/acr_cloud_sdk.result');

  static const EventChannel _timeChannel =
      const EventChannel('plugins.chizi.tech/acr_cloud_sdk.time');

  /// Fires whenever a song's time is recognized
  /// returns data as ```double```
  ///
  Stream<double> get timeStream =>
      _timeChannel.receiveBroadcastStream(0).cast<double>();

  /// Fires whenever a song is recognized
  /// returns data as ```String```
  ///
  Stream<String> get resultStream =>
      _resultChannel.receiveBroadcastStream(1).cast<String>();

  /// Fires whenever a song is recognized
  /// returns data as ```SongModel``` object
  ///
  Stream<SongModel> get songModelStream =>
      resultStream.map((e) => SongModel.fromJson(e));

  /// You should initilize the AcrCloudSdk instance with this function.
  ///
  /// The `host` argument's meaning depends on recMode, if recMode is `ACRCloudRecMode.local`
  /// it means local fingerprinting database directory else it means the host of server
  ///
  /// `LocationData`. The `interval` and `distanceFilter` are controlling how
  ///
  /// `accessKey` is the Access key of your ACRCloud project
  ///
  /// `accessSecret` is the Access secret of your ACRCloud project
  ///
  /// Http request timeout, default is [5000ms] and can be set using `requestTimeout`.
  ///
  /// This `setLog` argument is to toggle display of log in terminal
  ///
  /// `recMode` argument is the Recognition mode
  Future<bool> init({
    required String host,
    required String accessKey,
    required String accessSecret,
    String? hostAuto,
    String? accessKeyAuto,
    String? accessSecretAuto,
    int recorderConfigRate = 8000,
    Duration? requestTimeout,
    int recorderConfigChannels = 1,
    bool isVolumeCallback = true,
    bool setLog = true,
    ACRCloudRecMode recMode = ACRCloudRecMode.default_mode,
  }) async {
    try {
      var status = await Permission.microphone.status;
      if ((status.isDenied || status.isPermanentlyDenied) &&
          Platform.isAndroid) {
        // We didn't ask for permission yet.
        await [
          Permission.microphone,
          Permission.location,
          Permission.locationAlways,
          Permission.locationWhenInUse,
          Permission.phone,
          Permission.storage,
        ].request();
        return await init(
            host: host,
            accessKey: accessKey,
            accessSecret: accessSecret,
            hostAuto: hostAuto,
            accessKeyAuto: accessKeyAuto,
            accessSecretAuto: accessSecretAuto,
            recorderConfigRate: recorderConfigRate,
            recorderConfigChannels: recorderConfigChannels,
            requestTimeout: requestTimeout,
            isVolumeCallback: isVolumeCallback,
            setLog: setLog,
            recMode: recMode);
      } else {
        return await _channel.invokeMethod(
          'init',
          {
            "host": host,
            "accessKey": accessKey,
            "accessSecret": accessSecret,
            "hostAuto": hostAuto ?? host,
            "accessKeyAuto": accessKeyAuto ?? accessKey,
            "accessSecretAuto": accessSecretAuto ?? accessSecret,
            "recorderConfigRate": recorderConfigRate,
            "recorderConfigChannels": recorderConfigChannels,
            "isVolumeCallback": isVolumeCallback,
            "setLog": setLog,
            "requestTimeout": requestTimeout?.inMilliseconds,
            "recMode": recMode.index,
          },
        );
      }
    } catch (e) {
      return false;
    }
  }

  /// This function will automatic start the recording and recognizing process.
  ///
  /// `autoRecognize` & `requestRadioMetadata` are false by default
  ///
  Future<bool> start({
    bool autoRecognize = false,
    bool requestRadioMetadata = false,
  }) async {
    final bool data = await _channel.invokeMethod(
      'start',
      {
        "autoRecognize": autoRecognize,
        "requestRadioMetadata": requestRadioMetadata,
      },
    );
    return data;
  }

  /// This function will cancel the recognition immediately.
  ///
  Future<bool> stop() async {
    final bool data = await _channel.invokeMethod('cancel');
    return data;
  }
}
