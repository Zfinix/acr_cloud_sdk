import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/song_model.dart';

enum ACRCloudRecMode {
  remote, //query remote db
  local, //query local db
  both, // query both remote db and local db
  advance_remote, //query remote db and saving recording fingerprint when offline.
  default_mode // default mode
}

class AcrCloudSdk {
  static const MethodChannel _channel =
      const MethodChannel('plugins.chizi.tech/acr_cloud_sdk');

  static const EventChannel _resultChannel =
      const EventChannel('plugins.chizi.tech/acr_cloud_sdk.result');

  static const EventChannel _timeChannel =
      const EventChannel('plugins.chizi.tech/acr_cloud_sdk.time');

  Stream<double> get timeStream =>
      _timeChannel.receiveBroadcastStream(0).cast<double>();

  Stream<String> get resultStream =>
      _resultChannel.receiveBroadcastStream(1).cast<String>();

  Stream<SongModel> get songModelStream =>
      resultStream.map((e) => SongModel.fromJson(e));

  Future<bool> init({
    @required String host,
    @required String accessKey,
    @required String accessSecret,
    String hostAuto,
    String accessKeyAuto,
    String accessSecretAuto,
    int recorderConfigRate = 8000,
    int requestTimeout,
    int recorderConfigChannels = 1,
    bool isVolumeCallback = true,
    bool setLog = true,
    ACRCloudRecMode recMode = ACRCloudRecMode.default_mode,
  }) async {
    try {
      var status = await Permission.microphone.status;
      if ((status.isUndetermined ||
              status.isDenied ||
              status.isPermanentlyDenied) &&
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
            "hostAuto": host ?? hostAuto,
            "accessKeyAuto": accessKey ?? accessKeyAuto,
            "accessSecretAuto": accessSecret ?? accessSecretAuto,
            "recorderConfigRate": recorderConfigRate,
            "recorderConfigChannels": recorderConfigChannels,
            "isVolumeCallback": isVolumeCallback,
            "setLog": setLog,
            "requestTimeout": requestTimeout,
            "recMode": recMode.index,
          },
        );
      }
    } catch (e) {
      return false;
    }
  }

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

  Future<bool> stop() async {
    final bool data = await _channel.invokeMethod('cancel');
    return data;
  }
}
