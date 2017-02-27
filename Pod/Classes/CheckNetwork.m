//
//  CheckNetwork.m
//  Bulletin
//
//  Created by Peter on 04/06/14.
//  Copyright (c) 2014 Imaginovation. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "CheckNetwork.h"

UIAlertView *Alert;
@implementation CheckNetwork

//--Check whether network connection available or no
+ (BOOL) isNetwork
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	BOOL connected;
	BOOL isConnected;
	const char *host = "www.apple.com";
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
	SCNetworkReachabilityFlags flags;
	connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    isConnected = NO;
	isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	CFRelease(reachability);
	return isConnected;
}


//-- Throw alert when network not available
+ (void) NoNetworkAlert
{
    @try
    {
        Alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        Alert.frame = CGRectMake(0, 0, 200, 40);
        
        
        //-- Set View as subview for alertview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Alert.frame.size.width, Alert.frame.size.height)];
        
        //-- Set title label
        UILabel *TextLabel = [[UILabel alloc] init];
        TextLabel.text =  @"No Network Connection";
        TextLabel.backgroundColor = [UIColor clearColor];
        
        //-- Set imageview
        UIImageView *imageView = [[UIImageView alloc]init ];
        imageView.image = [UIImage imageNamed:@"NetworkError.png"];
        
        //-- Use view as accessoryView for iOS 7 & higher
        if([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7.0f)
        {
            Alert.frame = CGRectMake(0, 0, 50, 10);
            Alert.title = nil;
            
            //-- For iOS8 & above
            if([[[UIDevice currentDevice] systemVersion] floatValue ] >= 8.0f)
            {
                TextLabel.frame = CGRectMake(Alert.frame.origin.x+70, 2, 200, 40);
                
                imageView.frame =  CGRectMake(Alert.frame.origin.x +20 , 5, 30, 30);
            }
            else
            {
                TextLabel.frame = CGRectMake(Alert.frame.origin.x+30, Alert.frame.origin.y, 200, 40);
                
                imageView.frame =  CGRectMake(Alert.frame.origin.x -10 , Alert.frame.origin.y+3, 30, 30);
            }
            
            view.backgroundColor = [UIColor clearColor];
            [Alert setValue:view forKey:@"accessoryView"];
            
            [view addSubview:TextLabel];
            [view addSubview:imageView];
        }
        
        //-- Use view as subview for iOS 6.1 & lower
        else
        {
            //-- Text label Frame
            TextLabel.frame = CGRectMake(Alert.frame.origin.x+15, Alert.frame.origin.y+12, 275, 40);
            [TextLabel setTextColor:[UIColor whiteColor]];
            TextLabel.textAlignment = NSTextAlignmentCenter;
            [Alert addSubview:TextLabel];
        
        
            //-- Processing imageview frame
            imageView.frame =  CGRectMake(Alert.frame.origin.x + 20, Alert.frame.origin.y+15, 30, 30);
            
            [Alert addSubview:imageView];
            //[Alert addSubview:view];
        }
        [self performSelector:@selector(NoNetworkAlertDismiss) withObject:Alert afterDelay:2.5];
        
        [Alert show];
    }
    
    @catch (NSException *e)
    {
        Alert = [[UIAlertView alloc]initWithTitle:@"No Network Connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        
         NSString *Exception = @"\n CheckNetwork Class File, NoNetworkAlert Method ";
        [self ExceptionAlert:Exception];
    }
    //[self performSelector:@selector(NoNetworkAlertDismiss) withObject:Alert afterDelay:2];
}

+ (void)NoNetworkAlertDismiss
{
    [Alert dismissWithClickedButtonIndex:0 animated:YES];
}


//-- Throw alert when exception occurs
+ (void) ExceptionAlert:(NSString *)OccuredString
{
    //-- Display occured exception as alert for developer purpose of internal testing.

    //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception Occured" message:OccuredString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
}

@end
