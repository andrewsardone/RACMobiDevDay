#import <AFNetworking/AFNetworking.h>

@interface APIClient : AFHTTPClient

+ (instancetype)sharedClient;

- (void)createAccountForEmail:(NSString *)email
                    firstName:(NSString *)firstName
                     lastName:(NSString *)lastName
                      success:(void (^)(id account))successBlock
                      failure:(void (^)(NSError *error))failureBlock;

@end
