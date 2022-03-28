#import "AcrCloudSdkPlugin.h"
#if __has_include(<acr_cloud_sdk/acr_cloud_sdk-Swift.h>)
#import <acr_cloud_sdk/acr_cloud_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "acr_cloud_sdk-Swift.h"
#endif

@implementation AcrCloudSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAcrCloudSdkPlugin registerWithRegistrar:registrar];
}
@end
