
// Project includes
#import "WebserviceJob.h"
#import "Coordinate.h"

// Library includes
#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

@property (strong, nonatomic) WebserviceJob* webserviceJob;
@property (strong, nonatomic) Coordinate* HomeCoordinate;
@property (strong, nonatomic) Coordinate* DestinationCoordinate;

+(DataProvider*)sharedDataProvider;


-(void)sendGetRequest:(NSString*)urlString
                withAttributesForMapping:(NSArray*)attributes
                withClassNameForMapping:(Class)className
                completion:(void (^)(NSArray* result))requestCompleted
                failure:(void (^)(NSError* error))requestFailed;

-(void)sendPostRequest:(NSString*)urlString
                withAttributesForMapping:(NSArray*)attributes
                withClassNameForMapping:(Class)className
                withObject:(id)object completion:(void(^)(NSArray* result))requestCompleted;

-(void)sendPostRequestWithoutObjectMapping:(NSString*)urlString
                completion:(void (^)(NSArray *))requestCompleted;

-(void)sendPutRequest:(NSString*)urlString
                withAttributesForMapping:(NSArray*)attributes
                withClassNameForMapping:(Class)className
                withObject:(id)object
                completion:(void(^)(NSArray* result))requestCompleted;

-(void)sendPutRequestWithoutObjectMapping:(NSString*)urlString
                completion:(void(^)(NSArray* result))requestCompleted;

@end
