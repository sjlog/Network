//
//  NetworkViewController.h
//  Network
//
//  Created by sangjo_itwill on 2013. 12. 5..
//  Copyright (c) 2013년 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkViewController : UIViewController<NSStreamDelegate, UITextFieldDelegate>
{
    
    IBOutlet UITextField *textMsg;
    
    IBOutlet UITextView *textView;
}

- (IBAction)btnSend:(id)sender;

@end
