package com.chizi.acr_cloud_sdk


import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import android.widget.TextView
import androidx.core.app.ActivityCompat
import com.acrcloud.rec.*
import com.acrcloud.rec.utils.ACRCloudLogger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.*


internal class MethodCallHandlerImpl(context: Context, activity: Activity?, timeChannel: EventChannel?,  resultChannel: EventChannel?, methodChannel: MethodChannel) : MethodCallHandler, IACRCloudListener, IACRCloudRadioMetadataListener, EventChannel.StreamHandler {

    private var context: Context?
    private var activity: Activity?
    private var timeChannel: EventChannel?
    private var resultChannel: EventChannel?
    private var methodChannel: MethodChannel?

    private val TAG: String =  "acr_cloud_sdk"


    private var mProcessing = false
    private var mAutoRecognizing = false
    private var initState = false

    private val mediaPlayer = MediaPlayer()

    private var timeEvents: EventChannel.EventSink? = null
    private var resultEvents: EventChannel.EventSink? = null

    private val path = ""

    private var startTime: Long = 0
    private val stopTime: Long = 0

    private val PRINT_MSG = 1001

    private var mConfig: ACRCloudConfig? = null
    private var mClient: ACRCloudClient? = null

    fun setActivity(act: Activity?) {
        this.activity = act
    }

    init {
        this.activity = activity
        this.context = context
        this.resultChannel = resultChannel
        this.timeChannel = timeChannel
        this.methodChannel = methodChannel
        timeChannel?.setStreamHandler(this)
        resultChannel?.setStreamHandler(this)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Handler(Looper.getMainLooper()).post {
            when (call.method) {
                "init" -> {
                    init(call, result)
                }
                "start" -> {
                    start(call,result)
                }
                "cancel" -> {
                    cancel(result)
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }

    private fun init(call: MethodCall, result: MethodChannel.Result) {

        val host = call.argument<String>("host")
        val accessKey = call.argument<String>("accessKey")
        val accessSecret = call.argument<String>("accessSecret")


        val hostAuto = call.argument<String>("hostAuto")
        val accessKeyAuto = call.argument<String>("accessKeyAuto")
        val accessSecretAuto = call.argument<String>("accessSecretAuto")

        val recorderConfigRate = call.argument<Int>("recorderConfigRate") ?: 8000
        val recorderConfigChannels= call.argument<Int>("recorderConfigChannels") ?: 1
        val isVolumeCallback = call.argument<Boolean>("isVolumeCallback")?: false
        val setLog = call.argument<Boolean>("setLog") ?: false

        try {

            verifyPermissions()

            mConfig = ACRCloudConfig()

            mConfig!!.acrcloudListener = this
            mConfig!!.context = context

            

            mConfig!!.host = host
            mConfig!!.accessKey = accessKey
            mConfig!!.accessSecret = accessSecret

            // auto recognize access key

            mConfig!!.hostAuto =  hostAuto
            mConfig!!.accessKeyAuto = accessKeyAuto
            mConfig!!.accessSecretAuto = accessSecretAuto


            mConfig!!.recorderConfig.rate = recorderConfigRate
            mConfig!!.recorderConfig.channels = recorderConfigChannels

            // If you do not need volume callback, you set it false.

            mConfig!!.recorderConfig.isVolumeCallback = isVolumeCallback

            mClient = ACRCloudClient()
            ACRCloudLogger.setLog(setLog)

            initState = mClient!!.initWithConfig(mConfig)

        } catch (e: Exception){
            result.error(TAG, null, e.toString())
        }

    }




    private fun start(call: MethodCall, result: MethodChannel.Result) {
        val autoRecognize = call.argument<Boolean>("autoRecognize")?: false
        val requestRadioMeta = call.argument<Boolean>("requestRadioMetadata")?: false

        if(requestRadioMeta) requestRadioMetadata()

        if (autoRecognize) {
            openAutoRecognize(result)
        } else {
            closeAutoRecognize(result)
        }

        if (!initState) {
            result.error(TAG, "init error", "please initialize plugin with .init()")
            return
        }
        if (!mProcessing) {
            mProcessing = true
            if (mClient == null || !mClient!!.startRecognize()) {
                mProcessing = false

                result.error(TAG, "start error!", "Could not start the service")
            }
            startTime = System.currentTimeMillis()
        }
    }

    private fun cancel(result: MethodChannel.Result) {
        if (mProcessing && mClient != null) {
            mClient!!.cancel()
        }
        reset()
        result.success(true)
    }

    private fun openAutoRecognize(result: MethodChannel.Result) {
        if (!mAutoRecognizing) {
            mAutoRecognizing = true
            if (mClient == null || !mClient!!.runAutoRecognize()) {
                mAutoRecognizing = true
                result.error(TAG, "openAutoRecognize error!", "Could not openAutoRecognize")

            }
        }
    }

    private fun closeAutoRecognize(result: MethodChannel.Result) {
        if (mAutoRecognizing) {
            mAutoRecognizing = false
            mClient!!.cancelAutoRecognize()
            result.error(TAG, "closeAutoRecognize error!", "Could not closeAutoRecognize")

        }
    }

    // callback IACRCloudRadioMetadataListener
    private fun requestRadioMetadata() {
        val lat = "39.98"
        val lng = "116.29"
        val freq: MutableList<String> = ArrayList()
        freq.add("88.7")
        if (!mClient!!.requestRadioMetadataAsyn(lat, lng, freq,
                        ACRCloudConfig.RadioType.FM, this)) {
            println("requestRadioMetadata error")
        }
    }

    private fun reset() {
        mProcessing = false
    }

    private val REQUEST_EXTERNAL_STORAGE = 1
    private val PERMISSIONS = arrayOf(
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.ACCESS_WIFI_STATE,
            Manifest.permission.INTERNET,
            Manifest.permission.RECORD_AUDIO
    )

    private fun verifyPermissions() {
        for (i in PERMISSIONS.indices) {
            val permission = activity?.let { ActivityCompat.checkSelfPermission(it, PERMISSIONS[i]) }
            if (permission != PackageManager.PERMISSION_GRANTED) {
                activity?.let {
                    ActivityCompat.requestPermissions(it, PERMISSIONS,
                            REQUEST_EXTERNAL_STORAGE)
                }
                break
            }
        }
    }



    override fun onResult(results: ACRCloudResult?) {
        this.reset()

        // If you want to save the record audio data, you can refer to the following codes.
        /*
	byte[] recordPcm = results.getRecordDataPCM();
        if (recordPcm != null) {
            byte[] recordWav = ACRCloudUtils.pcm2Wav(recordPcm, this.mConfig.recorderConfig.rate, this.mConfig.recorderConfig.channels);
            ACRCloudUtils.createFileWithByte(recordWav, path + "/" + "record.wav");
        }
	*/
        val result: String = results!!.result
        resultEvents?.success(result)
    }

    override fun onVolumeChanged(p0: Double) {
        val time = (System.currentTimeMillis() - startTime) / 1000
        timeEvents?.success(time.toDouble())

    }


    override fun onRadioMetadataResult(result: String?) {
        resultEvents?.success(result)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        when (arguments) {
            0 -> {
                this.timeEvents = events
            }
            1 -> {
                this.resultEvents = events
            }
            else -> {
                
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        if (mProcessing && mClient != null) {
            mClient!!.release()
            mClient!!.cancel()
        }
        reset()
    }
}
