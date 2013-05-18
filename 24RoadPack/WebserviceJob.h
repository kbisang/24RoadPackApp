

#import <Foundation/Foundation.h>

@interface WebserviceJob : NSObject

@property (strong, nonatomic) NSNumber* id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSNumber* state;
@property (strong, nonatomic) NSString* homeStreet;
@property (strong, nonatomic) NSString* homeHouseNumber;
@property (strong, nonatomic) NSString* homeLocation;
@property (strong, nonatomic) NSNumber* homeZip;
@property (strong, nonatomic) NSString* destinationStreet;
@property (strong, nonatomic) NSString* destinationHouseNumber;
@property (strong, nonatomic) NSString* destinationLocation;
@property (strong, nonatomic) NSNumber* destinationZip;
@property (strong, nonatomic) NSString* pickupDate;
@property (strong, nonatomic) NSString* pickupTime;
@property (strong, nonatomic) NSString* deliveryDate;
@property (strong, nonatomic) NSString* deliveryTime;

@end
