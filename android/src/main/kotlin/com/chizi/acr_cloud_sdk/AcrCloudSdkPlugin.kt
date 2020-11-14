package com.chizi.acr_cloud_sdk

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


/** AcrCloudSdkPlugin */
class AcrCloudSdkPlugin: FlutterPlugin, ActivityAware {

  private var channel: MethodChannel? = null
  private var resultChannel: EventChannel? = null
  private var timeChannel: EventChannel? = null
  private val channelID = "plugins.chizi.tech/acr_cloud_sdk"
  private val resultChannelID = "plugins.chizi.tech/acr_cloud_sdk.result"
  private val timeChannelID = "plugins.chizi.tech/acr_cloud_sdk.time"
  private var handler: MethodCallHandlerImpl? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    setupChannel(flutterPluginBinding)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannel()
  }

  private fun setupChannel(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelID)
    resultChannel = EventChannel(flutterPluginBinding.binaryMessenger, resultChannelID)
    timeChannel = EventChannel(flutterPluginBinding.binaryMessenger, timeChannelID)
    handler = MethodCallHandlerImpl(flutterPluginBinding.applicationContext, null, timeChannel,resultChannel, channel!!)
    channel?.setMethodCallHandler(handler)
  }



  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    handler?.setActivity(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    handler?.setActivity(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    onDetachedFromActivity()
  }

  private fun teardownChannel() {
    channel?.setMethodCallHandler(null)
    channel = null
    handler = null
  }
}

