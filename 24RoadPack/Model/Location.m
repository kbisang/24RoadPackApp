
#import "Location.h"

@interface Location ()

@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *JobDateTime;
@property (nonatomic, assign) CLLocationCoordinate2D Coordinate;
@end

@implementation Location

- (id)initWithJobDateTime:(NSString*)jobDateTime address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([jobDateTime isKindOfClass:[NSString class]]) {
            self.JobDateTime = jobDateTime;
        } else {
            self.JobDateTime = @"Unknown charge";
        }
        self.Address = address;
        self.Coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return self.Address;
}

- (NSString *)subtitle {
    return self.JobDateTime;
}

- (CLLocationCoordinate2D)coordinate {
    return self.Coordinate;
}

@end
