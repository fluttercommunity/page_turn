#import "PageTurnPlugin.h"
#import <page_turn/page_turn-Swift.h>

@implementation PageTurnPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPageTurnPlugin registerWithRegistrar:registrar];
}
@end
