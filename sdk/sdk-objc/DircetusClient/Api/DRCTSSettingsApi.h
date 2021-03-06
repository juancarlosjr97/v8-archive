#import <Foundation/Foundation.h>
#import "DRCTSGetSettings.h"
#import "DRCTSGetSettingsFor.h"
#import "DRCTSApi.h"

/**
* directus.io
* API for directus.io
*
* OpenAPI spec version: 1.1
* 
*
* NOTE: This class is auto generated by the swagger code generator program.
* https://github.com/swagger-api/swagger-codegen.git
* Do not edit the class manually.
*/



@interface DRCTSSettingsApi: NSObject <DRCTSApi>

extern NSString* kDRCTSSettingsApiErrorDomain;
extern NSInteger kDRCTSSettingsApiMissingParamErrorCode;

-(instancetype) initWithApiClient:(DRCTSApiClient *)apiClient NS_DESIGNATED_INITIALIZER;

/// Returns settings
/// 
///
/// 
///  code:200 message:"settings object"
///
/// @return DRCTSGetSettings*
-(NSURLSessionTask*) getSettingsWithCompletionHandler: 
    (void (^)(DRCTSGetSettings* output, NSError* error)) handler;


/// Returns settings for collection
/// 
///
/// @param collectionName Name of collection to return settings for
/// 
///  code:200 message:"setting object"
///
/// @return DRCTSGetSettingsFor*
-(NSURLSessionTask*) getSettingsForWithCollectionName: (NSNumber*) collectionName
    completionHandler: (void (^)(DRCTSGetSettingsFor* output, NSError* error)) handler;


/// Update settings
/// 
///
/// @param collectionName Name of collection to return settings for
/// @param customData Data based on your specific schema eg: active&#x3D;1&amp;title&#x3D;LoremIpsum
/// 
///  code:200 message:"update complete"
///
/// @return void
-(NSURLSessionTask*) updateSettingsWithCollectionName: (NSNumber*) collectionName
    customData: (NSString*) customData
    completionHandler: (void (^)(NSError* error)) handler;



@end
