
// Project includes
#import "RoadPackTrackerModel.h"
#import "DataProvider.h"
#import "WebserviceJob.h"
#import "Coordinate.h"
#import "Address.h"

// Library includes
#import <RestKit.h>

@implementation RoadPackTrackerModel

+(NSArray*) attributes
{
    static NSArray* array;
    if(!array)
    {
        array = [[NSArray alloc] initWithObjects:
                 @"id",
                 @"title",
                 @"state",
                 @"homeStreet",
                 @"homeHouseNumber",
                 @"homeLocation",
                 @"homeZip",
                 @"destinationStreet",
                 @"destinationHouseNumber",
                 @"destinationLocation",
                 @"destinationZip",
                 @"pickupDate",
                 @"pickupTime",
                 @"deliveryDate",
                 @"deliveryTime",
                 nil];
    }
    
    return array;
}

+(NSArray*) coordinateAttributes
{
    static NSArray* array;
    if(!array)
    {
        array = [[NSArray alloc] initWithObjects:
                 @"results.geometry.location.lat",
                 @"results.geometry.location.lng",
                 nil];
    }
    
    return array;
}

+(void)loadJob:(NSNumber *)jobId{
    
    NSString* urlString = [NSString
                           stringWithFormat:@"http://10.29.3.195:9080/24RoadPack_webApp/resources/webservice/job/%@",jobId];
    
    
    [[DataProvider sharedDataProvider] sendGetRequest:urlString
                withAttributesForMapping:[self attributes]
                withClassNameForMapping:[WebserviceJob class]
     
                completion:^(NSArray* result){
                    
                [DataProvider sharedDataProvider].webserviceJob = (WebserviceJob*)[result objectAtIndex:0];
                                               
                NSLog(@"Job data for job id: %@ successfully loaded", jobId);
                                               
                } failure:^(NSError* error){
                        NSLog(@"Job data for job Id: %@ not loaded",jobId);
                }];
}

+(CLLocationCoordinate2D)getCoordinatesForAddressSynchronously:(Address *) address {
    NSString* urlString = [NSString
                           stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@+%@,+%@,+%@&sensor=true",address.HouseNumber, address.Street, address.Location, address.Zip];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSData * response = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSDictionary *geoCoordinatesFromGoogle = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: nil];
    Coordinate* coordinate = [[Coordinate alloc]init];
    NSArray* lat = [geoCoordinatesFromGoogle valueForKeyPath:@"results.geometry.location.lat"];
    coordinate.lat = [lat objectAtIndex:0];
    NSArray* lng = [geoCoordinatesFromGoogle valueForKeyPath:@"results.geometry.location.lng"];
    coordinate.lng = [lng objectAtIndex:0];
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.latitude = [coordinate.lat doubleValue];
    coordinate2D.longitude = [coordinate.lng doubleValue];
    return coordinate2D;
}

@end
