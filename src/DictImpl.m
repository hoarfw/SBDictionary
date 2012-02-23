//
//  DictImpl.m
//  SBDict
//
//  Created by Hao Wu on 12/20/11.
//  Copyright (c) 2011 Hao Wu. All rights reserved.
//

#import "DictImpl.h"


@implementation DictImpl
@synthesize dictDelegate;

#define CIBA_WS @"http://dict-co.iciba.com/api/dictionary.php?w=%@"
#define QQ_WS @"http://dict.qq.com/dict?q=%@"
#define DICTCN_WS @"http://api.dict.cn/ws.php?utf8=true&q=%@"



-(id) initwith:(id)dtDelegate 
{
    self = [super init];
	if (self) {
        self.dictDelegate = dtDelegate;
    }
    return self;
}

-(void) lookup:(NSString* ) word 
{
    
	NSString *url = [NSString stringWithFormat:DICTCN_WS,word];
    NSLog(@"URL %@", url);
	   
    NSURL *xmlURL = [NSURL URLWithString:url];
    if (parser) {
        [parser release];
    }
    parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    [parser parse]; // return value not used
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    
    if ( [elementName isEqualToString:@"dict"] ) {
        // currentPerson is an ABPerson instance variable
        if (currentStringValue){
            [currentStringValue release];
        }
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
        return;
    }else {
        [currentStringValue appendString:@"\n"];
    }
    
  
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // ignore root and empty elements
    if ([elementName isEqualToString:@"dict"]) {
    
    // currentStringValue is an instance variable
        [dictDelegate updateResult:currentStringValue];
        [currentStringValue release];
        currentStringValue = nil;
    }
}

- (void)parser:(NSXMLParser *)pser parseErrorOccurred:(NSError *)parseError {
    NSString *error = [NSString stringWithFormat:@"Error %i,Description: %@, Line: %i, Column: %i", [parseError code],
                                     [[pser parserError] localizedDescription], [pser lineNumber],
                                     [pser columnNumber]];
    [dictDelegate updateResult:error];
}

@end
