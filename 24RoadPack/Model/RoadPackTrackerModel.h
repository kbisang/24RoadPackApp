
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WebserviceJob.h"
#import "Address.h"
#import "Coordinate.h"

@interface RoadPackTrackerModel : NSObject

+(void)loadJob:(NSNumber *)jobId;
+(CLLocationCoordinate2D)getCoordinatesForAddressSynchronously:(Address *) address;

@end
