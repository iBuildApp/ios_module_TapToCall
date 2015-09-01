/****************************************************************************
 *                                                                           *
 *  Copyright (C) 2014-2015 iBuildApp, Inc. ( http://ibuildapp.com )         *
 *                                                                           *
 *  This file is part of iBuildApp.                                          *
 *                                                                           *
 *  This Source Code Form is subject to the terms of the iBuildApp License.  *
 *  You can obtain one at http://ibuildapp.com/license/                      *
 *                                                                           *
 ****************************************************************************/

#import "mTapToCall.h"
#import "TBXML.h"
#import "notifications.h"
#import "phonecaller.h"


#pragma mark - mTapToCallViewController

/**
 *  ViewController for widget TapToCall
 */
@interface mTapToCallViewController()

/**
 *  ViewController title
 */
@property (nonatomic, copy  ) NSString         *szTitle;

/**
 *  ViewController title
 */
@property (nonatomic, copy  ) NSString         *szPhoneNumber;

/**
 *  Add link to ibuildapp.com to sharing messages
 */
@property (nonatomic, strong) NSArray          *objContainer;

@end

@implementation mTapToCallViewController

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if ( self )
  {
    self.szTitle      = nil;
    self.szPhoneNumber = nil;
    self.objContainer = nil;
  }
  return self;
}

- (void)dealloc
{
  self.szTitle = nil;
  self.szPhoneNumber = nil;
  self.objContainer = nil;
  
  [super dealloc];
}

#pragma mark - 

/**
 *  Special parser for processing original xml file
 *
 *  @param xmlElement_ XML node
 *  @param params_     Dictionary with module parameters
 */
+ (void)parseXML:(NSValue *)xmlElement_
     withParams:(NSMutableDictionary *)params_
{
  TBXMLElement element;
  [xmlElement_ getValue:&element];

  NSMutableDictionary *callParams = [NSMutableDictionary dictionary];
  
  NSString *szTitle = @"";
  TBXMLElement *titleElement = [TBXML childElementNamed:@"title" parentElement:&element];
  if ( titleElement )
    szTitle = [TBXML textForElement:titleElement];
  
     // 1. search for tag <title>
    szTitle = szTitle ? szTitle : @"";
  
  [callParams setObject:szTitle forKey:@"title"];
  
    /// 2. search for tag <phone>
  TBXMLElement *phoneElement = [TBXML childElementNamed:@"phone" parentElement:&element];
  if ( phoneElement )
  {
    NSString *szPhone = [TBXML textForElement:phoneElement];
    if ( [szPhone length] )
    {
      [callParams setObject:szPhone forKey:@"phone"];
    }
  }

  [params_ setObject:callParams forKey:@"data"];
}


- (void)setParams:(NSMutableDictionary *)params
{
  if ( !params )
    return;
  
  NSDictionary *callParams = [params objectForKey:@"data"];
  
  self.szTitle = [callParams objectForKey:@"title"];
  self.szPhoneNumber = [callParams objectForKey:@"phone"];
}

/**
 *  Crutch for supporting scenarios.
 *  This does not necessarily call module (i.e. adding viewController to stack may not happen).
 *  For example, if there is a call third-party application, the method returns a pointer to an object of type NSObject.
 *  Otherwise - the caller makes adding view controller in the stack.
 *
 *  @return id
 */
- (id)performActionWithViewController:(UIViewController *)viewController_
{
  if ( [self.szPhoneNumber length] )
  {
    TPhoneCaller *caller = [[[TPhoneCaller alloc] init] autorelease];
    [caller callNumber:self.szPhoneNumber];
    
    // We must return an object with type NOT ViewController!
    // otherwise it will be added to the stack of viewControllers, this will cause a crash!
    
    //  So we must hold self to NSArray and return it
    self.objContainer = [NSArray arrayWithObject:self];
    return self.objContainer;
  }
  
  return nil;
}

@end
