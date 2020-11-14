import 'package:acr_cloud_sdk_example/utils/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/theme.dart';
import 'views/home_page.dart';

void main() {
  Log.init(kReleaseMode);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    overrideDeviceColors();
    return MaterialApp(
      title: 'SoundCheck',
      debugShowCheckedModeBanner: false,
      theme: themeData(context),
      home: HomePage(),
    );
  }
}
