
// Project includes
#import "DataProvider.h"

// Library includes
#import <RestKit.h>

#define ENABLE_RESTKIT_LOGLEVEL_TRACE NO

@implementation DataProvider

-(id)init {
    self = [super init];
    
    return self;
}

static DataProvider* dataProviderSingleton;

@synthesize webserviceJob;
@synthesize HomeCoordinate;
@synthesize DestinationCoordinate;

+(DataProvider*) sharedDataProvider {
    if(!dataProviderSingleton){
        
        dataProviderSingleton = [[DataProvider alloc] init];
        
        if(ENABLE_RESTKIT_LOGLEVEL_TRACE)
            RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    }
    return dataProviderSingleton;
}

-(RKObjectMapping*)createObjectMapping:(Class)className withAttributes:(NSArray *)attributes{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:className];
//    [mapping addAttributeMappingsFromDictionary:attributes];
    [mapping addAttributeMappingsFromArray:attributes];
    return mapping;
}

-(RKResponseDescriptor*)createResponseDescriptor:(RKObjectMapping*)mapping{
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                        pathPattern:nil keyPath:nil statusCodes:nil];
    return responseDescriptor;
}

-(void)sendGetRequest:(NSString*)urlString
                        withAttributesForMapping:(NSArray*)attributes
                        withClassNameForMapping:(Class)className
                        completion:(void (^)(NSArray* result))requestCompleted
                        failure:(void (^)(NSError* error))requestFailed{
    
    RKObjectMapping* mapping = [self createObjectMapping:className withAttributes:attributes];
    RKResponseDescriptor *responseDescriptor = [self createResponseDescriptor:mapping];
    
    NSURL* url = [NSURL URLWithString:urlString];
                  
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        
        requestCompleted([result array]);
              
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            requestFailed(error);
        }];
    
    [operation start];

}

-(void)sendPostRequest:(NSString*)urlString
                    withAttributesForMapping:(NSArray*)attributes
                    withClassNameForMapping:(Class)className
                    withObject:(id)object
                    completion:(void (^)(NSArray *))requestCompleted
{
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:className];
    [responseMapping addAttributeMappingsFromArray:attributes];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:nil
        keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:attributes];
    
    RKRequestDescriptor* requestDescriptor = [RKRequestDescriptor   requestDescriptorWithMapping:requestMapping
            objectClass:className
            rootKeyPath:nil];
    
    RKObjectManager* manager = [RKObjectManager
                managerWithBaseURL:[NSURL
                    URLWithString:urlString]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
     manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [manager postObject:object
                    path:urlString
                    parameters:nil
                    success:^(RKObjectRequestOperation* operation, RKMappingResult* mappingResult){
                        
                        requestCompleted([mappingResult array]);
                    }
                failure:^(RKObjectRequestOperation* operation, NSError* error){
                    NSLog(@"%@",error);
                }];
}

-(void)sendPostRequestWithoutObjectMapping:(NSString*)urlString
                            completion:(void (^)(NSArray *))requestCompleted
{
    RKObjectManager* manager = [RKObjectManager
                                managerWithBaseURL:[NSURL
                                    URLWithString:urlString]];
    
    [manager postObject:nil
                   path:urlString
             parameters:nil
                success:^(RKObjectRequestOperation* operation, RKMappingResult* mappingResult){
                    
                    requestCompleted([mappingResult array]);
                }
                failure:^(RKObjectRequestOperation* operation, NSError* error){
                    NSLog(@"%@",error);
                }];
}


-(void)sendPutRequest:(NSString*)urlString
withAttributesForMapping:(NSArray*)attributes
withClassNameForMapping:(Class)className
            withObject:(id)object
            completion:(void (^)(NSArray *))requestCompleted
{
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:className];
    [responseMapping addAttributeMappingsFromArray:attributes];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:nil
                                                                                           keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:attributes];
    
    RKRequestDescriptor* requestDescriptor = [RKRequestDescriptor   requestDescriptorWithMapping:requestMapping
                                                                                     objectClass:className
                                                                                     rootKeyPath:nil];
    
    RKObjectManager* manager = [RKObjectManager
        managerWithBaseURL:[NSURL URLWithString:urlString]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [manager putObject:object
                   path:urlString
             parameters:nil
                success:^(RKObjectRequestOperation* operation, RKMappingResult* mappingResult){
                    
                    requestCompleted([mappingResult array]);
                }
                failure:^(RKObjectRequestOperation* operation, NSError* error){
                    NSLog(@"%@",error);
                }];
}

-(void)sendPutRequestWithoutObjectMapping:(NSString*)urlString
                               completion:(void(^)(NSArray* result))requestCompleted{
    
    RKObjectManager* manager = [RKObjectManager
                        managerWithBaseURL:[NSURL
                        URLWithString:urlString]];
    
    [manager putObject:nil
                   path:urlString
             parameters:nil
                success:^(RKObjectRequestOperation* operation, RKMappingResult* mappingResult){
                    
                    requestCompleted([mappingResult array]);
                }
                failure:^(RKObjectRequestOperation* operation, NSError* error){
                    NSLog(@"%@",error);
                }];

    
}

@end
