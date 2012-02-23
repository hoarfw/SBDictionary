//
//  DictImpl.h
//  SBDict
//
//  Created by Hao Wu on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#

@protocol DictDelegate <NSObject>
@optional

-(void) updateResult:(NSString*)rst;
@end


@interface DictImpl : NSObject{
    NSURLConnection *theConnection;
    NSXMLParser *parser;
    NSMutableString *currentStringValue;
}

-(id) initwith:(id)delegate;
-(void) lookup:(NSString* ) word;

@property (assign) id dictDelegate;
@end

