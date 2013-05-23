
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

- (id)initWithJobDateTime:(NSString*)jobDateTime address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
