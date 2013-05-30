
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WebserviceJob.h"
#import "Address.h"
#import "Coordinate.h"
#import "RoadPackTrackerViewController.h"

@interface RoadPackTrackerModel : NSObject

+(void)loadJob:(NSNumber *)jobId completion:(CompletionBlock)completionBlock;
+(CLLocationCoordinate2D)getCoordinatesForAddressSynchronously:(Address *) address;

@end
		