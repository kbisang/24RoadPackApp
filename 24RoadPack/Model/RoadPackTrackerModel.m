
// Project includes
#import "RoadPackTrackerModel.h"
#import "DataProvider.h"
#import "WebserviceJob.h"

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

+(void)loadJob:(NSNumber *)jobId{
    
    NSString* urlString = [NSString
                           stringWithFormat:@"http://10.29.3.195:8080/24RoadPack_webApp/resources/webservice/job/%@",jobId];
    
    
    [[DataProvider sharedDataProvider] sendGetRequest:urlString
                withAttributesForMapping:[self attributes]
                withClassNameForMapping:[WebserviceJob class]
     
                completion:^(NSArray* result){
                    
                [DataProvider sharedDataProvider].webserviceJob = (WebserviceJob*)result;
                                               
                NSLog(@"Job data for job id: %@ successfully loaded", jobId);
                                               
                } failure:^(NSError* error){
                        NSLog(@"Job data for job Id: %@ not loaded",jobId);
                }];
}

@end
