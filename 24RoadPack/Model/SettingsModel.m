
#import "SettingsModel.h"

@implementation SettingsModel

-(id)init {
    self = [super init];
    
    return self;
}

static SettingsModel* settingsSingleton;

+(SettingsModel*) sharedSettings {
    if(!settingsSingleton){
        settingsSingleton = [[SettingsModel alloc] init];
    }
    return settingsSingleton;
}

//-(void)loadSettings{
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* dummy = [standardUserDefaults stringForKey:@"dummy"];
//}

@end
