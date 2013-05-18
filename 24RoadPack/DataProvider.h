
// Project incldues
#import "User.h"

// Library includes
#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
@property (strong) NSMutableArray* attendedUsers;
@property (strong) NSMutableArray* absencesFromAttendedUser;
@property (strong) NSMutableArray* attendants;
@property (strong) NSMutableArray* absencesFromAttendant;
@property (strong) Configuration* currentConfiguration;
@property (strong) User* currentUser;

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
