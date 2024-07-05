#import <Foundation/NSObject.h>

@class NSString;
@class NSMutableArray;
@class NSMutableDictionary;

@interface XMLNode : NSObject <NSCopying>
{
	NSString *_name;
	NSString *_value;
	NSMutableDictionary *_attributes;
	NSMutableArray *_elements;
}

- (id) initWithName: (NSString *)name;
- (id) initWithName: (NSString *)name value: (NSString *)value attributes: (NSMutableDictionary *)attributes elements: (NSMutableArray *)elements;

- (NSString *) name;
- (void) setName: (NSString *)name;

- (NSMutableDictionary *) attributes;
- (void) setAttributes: (NSMutableDictionary *) attributes;

- (NSMutableArray *) elements;
- (void) setElements: (NSMutableArray *) elements;

- (NSString *) value;
- (void) setValue: (NSString *)value;

- (void) addElement: (XMLNode *)element;
- (void) addAttribute: (NSString *)key value: (NSString *)value;

@end
