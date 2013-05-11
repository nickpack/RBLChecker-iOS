#import "AFHTTPClient.h"

@interface RBLCheckerAPIClient : AFHTTPClient

+ (RBLCheckerAPIClient *)sharedClient;

@end
