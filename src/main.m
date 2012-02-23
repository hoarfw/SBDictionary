#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <UIKit/UIKeyboard.h>
#import "DictImpl.h"
extern void UIKeyboardEnableAutomaticAppearance();
extern void UIKeyboardDisableAutomaticAppearance();

//@class UIApplication;

@class UIButton;
@class UITextField;
@class UITextView;
@class UIImage;
@class UIImageView;
@class UIKeyboard;
typedef NSUInteger UIControlState;

#define UIControlStateNormal 0
#define UIControlEventTouchUpInside (1 << 6)
#define UIControlEventValueChanged  (1 << 12)

@interface DictinaryView : UIView<UITextViewDelegate, DictDelegate>{
	UITextField *searchTextView;
	UITextView *resultTextView;
    DictImpl *dict;
}


@property (retain, nonatomic) UITextField *searchTextView;
@property (retain, nonatomic) UITextView *resultTextView;
@property (retain, nonatomic) DictImpl *dict;


- (DictinaryView*) initWindow;
- (void) btClick;
- (void) showKeyboard:(BOOL)show ;
- (void) transitionOut;
- (void) transitionIn;
- (void) CloseButtonPressed; 
- (void) endTimer:(NSTimer *)timer;

- (UIWindow*) getAppWindow;
@end

@implementation DictinaryView
@synthesize searchTextView, resultTextView, dict;
//************************************************************************************************************
// initWindow - Initializes the brightness view window.
//************************************************************************************************************
- (DictinaryView*) initWindow
{
	self = [super initWithFrame:CGRectMake(-274.0f, 40.0f, 274.0f, 271.0f)];
	NSString* CurrentTheme;
	UIWindow* Window = [self getAppWindow];
	if([Window respondsToSelector:@selector(getCurrentTheme)])
	{
		CurrentTheme = [NSString stringWithString:[Window getCurrentTheme]];
	}
	else
	{
		CurrentTheme = [NSString stringWithString:@"Default"];
	}
	
	// Setup the background image.
	UIImageView* Image = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 274.0f, 241.0f)];
	Image.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/SBSettings/Themes/%@/SliderFrame3Row.png", CurrentTheme]];
	[self addSubview: Image];
	[Image release];
    
    
	UITextField *searchBox = [[UITextField alloc]initWithFrame:CGRectMake(15, 20, 180, 20)];
    //[searchBox setFont:[UIFont systemFontOfSize:20]];
    [searchBox setBackgroundColor: [UIColor whiteColor]];
    [self addSubview:searchBox];
  
    
    
    UIButton *searchBt = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 20, 20)] ;
    [searchBt setBackgroundColor:[UIColor blueColor]];
    [searchBt setTitle:@">" forState:UIControlStateNormal];
    
    [searchBt addTarget:self action:@selector(btClick) forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:searchBt];
    
    //[searchBox setScrollEnabled:NO];
    UITextView *resultBox = [[UITextView alloc]initWithFrame:CGRectMake(15, 45,245, 190)] ;
    resultBox.editable=NO;
    
    self.searchTextView=searchBox;
    
    // [searchBox  addTarget:self action:@selector(searchTextChange) forControlEvents:UIControlEventValueChanged];
    [searchTextView setDelegate:self];
    [self addSubview:resultBox];
    
    self.resultTextView = resultBox;
    DictImpl *sdict =[ [DictImpl alloc] initwith:self];
    self.dict=sdict;
    [sdict release];
                              
    [searchBox release];
    [resultBox release];
    [searchBt release];
   
	
	// Setup the close button
	UIButton* CloseButtonBigger = [[UIButton alloc] initWithFrame:CGRectMake(234.0f, 0.0f, 40.0f, 40.0f)];
	[CloseButtonBigger addTarget:self action:@selector(CloseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview: CloseButtonBigger];
	[CloseButtonBigger release];

	UIButton* CloseButton = [[UIButton alloc] initWithFrame:CGRectMake(244.0f, 5.0f, 25.0f, 25.0f)];
	[CloseButton setShowsTouchWhenHighlighted: YES];
	[CloseButton setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/SBSettings/Themes/%@/Close.png", CurrentTheme]] forState:UIControlStateNormal];
	[CloseButton addTarget:self action:@selector(CloseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview: CloseButton];
	[CloseButton release];
	UIKeyboardEnableAutomaticAppearance();
			
	return self;
}


-(void) btClick
{
    NSLog(@"click search");
    [self.dict lookup:[self.searchTextView text]];
    
}

//************************************************************************************************************
// textViewShouldBeginEditing - when text box is clicked into.
//************************************************************************************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	NSLog(@"should begin editing\n");
	[self showKeyboard: YES];
	return YES;
}

//************************************************************************************************************
// showKeyboard - enables / disables the keyboard.
//************************************************************************************************************
- (void) showKeyboard:(BOOL)show 
{
	NSLog(@"Showing keyboard %d", show);
	if([UIKeyboard respondsToSelector:@selector(activeKeyboard)]){
		NSLog(@"Get active method keyboard ");
		UIKeyboard *key = [UIKeyboard activeKeyboard];
		if (!key) 
		{
			NSLog(@"Showing keyboard null");
			return;
		}
		if (show) 
		{
			NSLog(@"Showing keyboard int animation");
			[key activate];
		} 
		else 
		{
			NSLog(@"Showing keyboard out animation");
			
			[key deactivate];
		}
	}else {
		NSLog(@"Showing keyboard no method activeKeyboard");
	}	
	[self.searchTextView becomeFirstResponder];
}

-(void) updateResult:(NSString *)rst
{
    [self.resultTextView setText:rst];
}


//************************************************************************************************************
// CloseButtonPressed: When the close button pressed. Closes up the window.
//************************************************************************************************************
- (void) CloseButtonPressed 
{
	//UIKeyboardDisableAutomaticAppearance();
	[self showKeyboard: NO];
	[self transitionOut];
}

//************************************************************************************************************
// transitionOut - transitions the window view out.
//************************************************************************************************************
- (void) transitionOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[[[UIApplication sharedApplication] keyWindow] addSubview: self];
	CGAffineTransform transformView	= CGAffineTransformMakeTranslation(-297.0f, 0.0f);
	[self setTransform: transformView];
	[UIView commitAnimations];

	[NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(endTimer:) userInfo:nil repeats:NO];
}

//************************************************************************************************************
// endTimer: Timer callback to remove the rest of the controls after animation completes.
//************************************************************************************************************
- (void) endTimer:(NSTimer *)timer 
{   
    [dict release];
	[searchTextView release];
	[resultTextView release];
	[self removeFromSuperview];
}

//************************************************************************************************************
// getAppWindow - attempts to retrieve the app window.
//************************************************************************************************************
- (UIWindow*) getAppWindow
{
	UIWindow* TheWindow = nil;
	UIApplication* App = [UIApplication sharedApplication];
	NSArray* windows = [App windows];
	int i;
	for(i = 0; i < [windows count]; i++)
	{
		TheWindow = [windows objectAtIndex:i];
		if([TheWindow respondsToSelector:@selector(getCurrentTheme)])
		{
			break;
		}
	}
	
	if(i == [windows count])
	{
		NSLog(@"Couldn't find the app window, defaulting to keyWindow\n");
		TheWindow = [App keyWindow];
	}
	
	return TheWindow;
}

//************************************************************************************************************
// transitionIn - animates the view in place.
//************************************************************************************************************
- (void) transitionIn
{
	UIWindow* TheWindow = [self getAppWindow];
	
	[TheWindow addSubview: self];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transformView	= CGAffineTransformMakeTranslation(297.0f, 0.0f);
	[self setTransform: transformView];
	[UIView commitAnimations];
}

@end

BOOL isCapable()
{
	return YES;
}

BOOL isEnabled()
{
	return YES;
}


void setState(BOOL Enable)
{
	DictinaryView* dictView = [[DictinaryView alloc] initWindow];
	[dictView transitionIn];
	[dictView release];
}

float getDelayTime()
{
	return 0.0f;
}


