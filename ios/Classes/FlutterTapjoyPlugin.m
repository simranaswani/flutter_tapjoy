#import "FlutterTapjoyPlugin.h"
#if __has_include(<flutter_tapjoy/flutter_tapjoy-Swift.h>)
#import <flutter_tapjoy/flutter_tapjoy-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_tapjoy-Swift.h"
#endif

@implementation FlutterTapjoyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTapjoyPlugin registerWithRegistrar:registrar];
}
@end
