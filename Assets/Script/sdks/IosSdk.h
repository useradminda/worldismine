#import <StoreKit/StoreKit.h>
#import "PaymentViewController.h"
#import <AVFoundation/AVFoundation.h> 
@interface IosSdk : NSObject

+(IosSdk *)Ins;
-(void) IniSdk:(int) sdktype add1:(int) sdkp add2: (const char*) SdkCBobjname add3: (const char*) SdkCBFunname;
-(void) LogoutSdk;
-(void)IniSdkCB:(NSString *)msg;
- (void) Send_Msg_To_Unity:( NSString*) msg;
-(void)SdkBuy:(NSString *)objid;
-(void) CB_NoBuyObj:(NSString * ) buyobj;
////////接受sdk 支付通知

//(@"交易完成");
-(void)CB_Buy_Finish:(NSString * ) productIdentifier add2:(NSString * ) receipt add3:(int) issandbox;


//(@"商品添加进列表");
-(void)CB_Buy_Purchasing:(NSString * ) productIdentifier;

//(@"已经购买过商品");
-(void)CB_Buy_Restored:(NSString * ) productIdentifier;

//(@"交易失败");
-(void)CB_Buy_Failed:(NSString * ) productIdentifier;


//(@"交易失败 用户取消");
-(void)CB_Buy_Failed_cancel:(NSString * ) productIdentifier;

////////////////////////
@end
