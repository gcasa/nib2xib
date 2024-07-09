#import <Foundation/NSObject.h>
#import "OidProvider.h"

@class XMLNode;

@protocol XMLParsing

- (XMLNode *) toXMLWithParser: (id<OidProvider>)parser;

@end