//
//  NetworkViewController.m
//  Network
//
//  Created by sangjo_itwill on 2013. 12. 5..
//  Copyright (c) 2013년 sj. All rights reserved.
//

#import "NetworkViewController.h"

@implementation NetworkViewController

NSMutableData *data;

NSInputStream *iStream;
NSOutputStream *oStream;

CFReadStreamRef readStream = NULL;          // == recv
CFWriteStreamRef writeStream = NULL;        // == send

- (IBAction)btnSend:(id)sender {
    
    const uint8_t *str = (uint8_t*)[textMsg.text cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    //   const uint8_t *str = (uint8_t*)&data;
    
    
    textMsg.text = @"";

    
    [self writeToServer:str];
    
}
// 172.16.1.100     9000

-(void)writeToServer:(const uint8_t*)buf
{
    [oStream write:buf maxLength:strlen((char*)buf)];
}

-(void)connectToServerUsingCFStream:(NSString*)urlstr portNo:(uint)portNo
{
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef) urlstr,
                                       portNo,
                                       &readStream,
                                       &writeStream);
    
    if (readStream && writeStream) {
        
        CFReadStreamSetProperty(readStream,
                                kCFStreamPropertyShouldCloseNativeSocket,
                                kCFBooleanTrue);
        
        CFWriteStreamSetProperty(writeStream,
                                 kCFStreamPropertyShouldCloseNativeSocket,
                                 kCFBooleanTrue);
        
        iStream = (__bridge NSInputStream*)readStream;
        
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [iStream open];
        
        oStream = (__bridge NSOutputStream*)writeStream;
        
        [oStream setDelegate:self];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [oStream open];
    }
}


-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    int bytesRead = 0;
    
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            if (data == nil) {
                data = [[NSMutableData alloc]init];
            }
            
            uint8_t buf[512];
            unsigned int len = 0;
            
            // recV
            len = [(NSInputStream*)aStream read:buf
                                      maxLength:512];
            if (len) {
                [data appendBytes:(const void*)buf
                           length:len];
                
                bytesRead += len;
            }
            else{
                NSLog(@"No data");
            }
            
            NSString *str = [[NSString alloc]
                             initWithData:data
                             encoding:NSUTF8StringEncoding]; //EUC-KR
//                             encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);

            
            NSString *exitingMsg = textView.text;
            
            exitingMsg = [exitingMsg stringByAppendingString:[NSString stringWithFormat:@"%@\n",str]];
            
            textView.text = exitingMsg;
            
            
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"전송된 문자열"
//                                  message:str
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//            
//            [alert show];
            
            data = nil;
        }
            
            break;
            
        default:
            break;
    }
    
    
    
    
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self connectToServerUsingCFStream:@"172.16.4.50"
                                portNo:9000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end







