import Flutter
import UIKit
public class SwiftAcrCloudSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var _start = false
    var _client: ACRCloudRecognition?
    var timeEvents:FlutterEventSink?
    var resultEvents:FlutterEventSink?
    final var TAG = "acr_cloud_sdk"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.chizi.tech/acr_cloud_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftAcrCloudSdkPlugin()
        let timeChannel = FlutterEventChannel.init( name: "plugins.chizi.tech/acr_cloud_sdk.time",binaryMessenger: registrar.messenger())
        
        let resultChannel = FlutterEventChannel.init(name: "plugins.chizi.tech/acr_cloud_sdk.result",binaryMessenger: registrar.messenger());
        
        timeChannel.setStreamHandler(instance)
        resultChannel.setStreamHandler(instance)
        
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        
        if arguments as? Int == 0 {
            timeEvents = eventSink
        }
        
        if arguments as? Int == 1 {
            resultEvents = eventSink
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timeEvents = nil
        resultEvents = nil
        return nil
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        DispatchQueue.main.async { [self] in
            switch call.method {
            case "init":
                self.initialize(call:call, result: result)
                
            case "start":
                if(_client != nil){
                    self.startRecognition(result: result)
                }else{
                    result(FlutterError.init(code: TAG, message:  "init error", details: "please initialize plugin with  .init()"))
                }
                
            case "cancel":
                if(_client != nil){
                    self.stopRecognition(result: result)
                }else{
                    result(FlutterError.init(code: TAG, message:  "init error", details: "please initialize plugin with  .init()"))
                }
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    public func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        do{
            if let args = call.arguments as? Dictionary<String, Any>,
               let host = args["host"] as? String,
               let accessKey = args["accessKey"] as? String,
               let accessSecret = args["accessSecret"] as? String,
               let requestTimeout = args["recorderConfigChannels"] as? Int,
               let recMode = args["recMode"] as? Int{
                let config = ACRCloudConfig();
                
                config.accessKey = accessKey
                config.accessSecret = accessSecret
                config.host = host
                
                config.requestTimeout = requestTimeout
                //if you want to identify your offline db, set the recMode to "rec_mode_local"
                
                switch recMode {
                case 0:
                    config.recMode = rec_mode_remote;
                    
                case 1:
                    config.recMode = rec_mode_local;
                    
                case 2:
                    config.recMode = rec_mode_both;
                    
                case 3:
                    config.recMode = rec_mode_advance_remote;
                    
                default:
                    config.recMode = rec_mode_remote;
                }
                
                config.requestTimeout = 10;
                config.protocol = "https";
                
                /* used for local model */
                if (config.recMode == rec_mode_local || config.recMode == rec_mode_both) {
                    config.homedir = Bundle.main.resourcePath!.appending("/acrcloud_local_db");
                }
                
                config.stateBlock = {[weak self] state in
                    self?.handleState(state!);
                }
                config.volumeBlock = {[weak self] volume in
                    //do some animations with volume
                    self?.handleVolume(volume);
                };
                config.resultBlock = {[weak self] result, resType in
                    self?.handleResult(result!, resType:resType);
                }
                self._client = ACRCloudRecognition(config: config);
                result(true)
            } else {
                result(FlutterError.init(code: TAG, message: nil, details: "init failed"))
            }
            
        }
        
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        _client = nil
    }
    
    public func startRecognition(result: @escaping FlutterResult) {
        if (_start) {
            result(false)
            return;
        }
        self._client?.startRecordRec();
        self._start = true;
        result(true)
    }
    
    func stopRecognition(result: @escaping FlutterResult) {
        self._client?.stopRecordRec()
        self._start = false;
    }
    
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void
    {
        
        DispatchQueue.main.async {
            if(self.resultEvents != nil){
                self.resultEvents!(result);
            }
            self._client?.stopRecordRec();
            self._start = false;
        }
    }
    
    func handleVolume(_ volume: Float) -> Void {
        DispatchQueue.main.async {
            if(self.timeEvents != nil){
                self.timeEvents!(Double(volume));
            }
            //  self.volumeLabel.text = String(format: "Volume: %f", volume)
        }
    }
    
    func handleState(_ state: String) -> Void
    {
        DispatchQueue.main.async {
            
            debugPrint(state)
        }
    }
}
