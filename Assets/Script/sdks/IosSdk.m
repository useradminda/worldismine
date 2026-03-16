//
//  IosSdk.m
//  Unity-iPhone
//
//  Created by 孙才阅 on 16/12/9.
//
//

#import "IosSdk.h"
#if defined(__cplusplus)
extern "C" {
#endif
    
    void Ios_IniSdk(int sdktype, int sdkp1,const char* SdkCBobjname2,const char* SdkCBFunname3)
    {
        //sdktype =  0;
     
        [[IosSdk Ins]IniSdk:sdktype add1: sdkp1 add2: SdkCBobjname2 add3: SdkCBFunname3];

    }
    
    //øÕªß∂ÀÕÀ≥ˆ”Œœ∑◊¢œ˙
    void Ios_LogoutSdk()
    {
        [[IosSdk Ins]LogoutSdk];
        
    }
    void Ios_SdkBuy(const char* objid)
    {
        [[IosSdk Ins]SdkBuy:[ [NSString alloc]initWithUTF8String:objid]];
        
    }
#if defined(__cplusplus)
}
#endif

@implementation IosSdk


NSString *channel = @"1000"; //«˛µ¿±‡∫≈
NSString *appSecret = @"testsecret";
NSString *channelId = @"u9_ylt_00001";
NSString *channelSource = @"ylt";

NSString * MySdkCBobjname;
NSString * MySdkCBFunname;
bool gamequit;
int mysdktype=0;
int mysdkp=0;
static IosSdk *ins =NULL;

bool IniOk;
bool CanBuyObj;
PaymentViewController * Mypay;

////////接受sdk 通知
-(void)IniSdkCB:(NSString *)msg
{
    IniOk = true;
    if([msg isEqual:@"IniOk"])
    {
        CanBuyObj = true;
        NSString* msg =[NSString stringWithFormat:@"IniOk"];
        [self Send_Msg_To_Unity:msg];
        //snbug
        //[self SdkBuy:@"com.u9time.zq.8001"];
    }
    if([msg  isEqual:@"IniOk_NoBuy"])
    {
        CanBuyObj =false;
        NSString* msg =[NSString stringWithFormat:@"IniOk_NoBuy"];
        [self Send_Msg_To_Unity:msg];
    }
}
-(void) CB_NoBuyObj:(NSString * ) buyobj
{
    NSString* msg =[NSString stringWithFormat:@"CB_NoBuyObj:%@",buyobj];
    [self Send_Msg_To_Unity:msg];
}

-(void)CB_Login_Result:(NSString * ) re
{
    NSString* msg =[NSString stringWithFormat:@"CB_Login_Result:%@",re];
    [self Send_Msg_To_Unity:msg];
}
-(void)CB_Loginout_user
{
    NSString* msg =[NSString stringWithFormat:@"CB_Loginout_user"];
    [self Send_Msg_To_Unity:msg];
}


////////////

////////接受sdk 支付通知

//(@"交易完成");
-(void)CB_Buy_Finish:(NSString * ) productIdentifier add2:(NSString * ) receipt add3:(int) issandbox;
{
    NSString* msg =[NSString stringWithFormat:@"CB_Buy_Finish:%@:%@:%d",productIdentifier,receipt,issandbox];
    //NSLog(@"-交易完成----receipt= ------:%@", receipt);
    [self Send_Msg_To_Unity:msg];
}

//(@"商品添加进列表");
-(void)CB_Buy_Purchasing:(NSString * ) productIdentifier
{
    NSString* msg =[NSString stringWithFormat:@"CB_Buy_Purchasing:%@",productIdentifier];
    [self Send_Msg_To_Unity:msg];
    
}
//(@"已经购买过商品");
-(void)CB_Buy_Restored:(NSString * ) productIdentifier
{
    NSString* msg =[NSString stringWithFormat:@"CB_Buy_Restored:%@",productIdentifier];
    [self Send_Msg_To_Unity:msg];
    
}
//(@"交易失败");
-(void)CB_Buy_Failed:(NSString * ) productIdentifier
{
    NSString* msg =[NSString stringWithFormat:@"CB_Buy_Failed:%@",productIdentifier];
    [self Send_Msg_To_Unity:msg];
    
}

//(@"交易失败 用户取消");
-(void)CB_Buy_Failed_cancel:(NSString * ) productIdentifier
{
    NSString* msg =[NSString stringWithFormat:@"CB_Buy_Failed_cancel:%@",productIdentifier];
    [self Send_Msg_To_Unity:msg];
}
////////////////////////


+(IosSdk *)Ins;
{
    if(ins==NULL)
    {
        ins = [[IosSdk alloc] init];
        
    }
    return ins;
}


//public enum sdktype
//{
//   nosdk = 0,
//   sdk_u9 = 1,	//U9sdk  不分ios 还是安卓
//}
//public enum sdkp
//{
//    ceshi =0,		//测试
//    zhengban = 1,	//正版
//    yueyu = 2,		//越狱
//}
-(void) IniSdk:(int) sdktype add1:(int) sdkp add2: (const char*) SdkCBobjname add3: (const char*) SdkCBFunname;
{
    IniOk = false;
    
    MySdkCBobjname =[[NSString alloc]initWithUTF8String: SdkCBobjname];
    MySdkCBFunname =[[NSString alloc]initWithUTF8String: SdkCBFunname];
    mysdkp=sdkp;
    mysdktype =sdktype;
    gamequit = false;
    
    if(mysdktype==0)    //使用ios 内置支付方式
    {
        Mypay = [[PaymentViewController alloc]init];
        [Mypay IniSome];
        //UIViewController * rootview = UnityGetGLViewController();
        //[rootview.view addSubview:Mypay.view];
        
        
    }
    else                //使用 接入sdk支付方式
    {
        
        
    }
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                NSLog(@"允许使用麦克风！");
                NSString* msg =[NSString stringWithFormat:@"MaikefengYes"];
                [self Send_Msg_To_Unity:msg];
            }
            else {
                NSLog(@"不允许使用麦克风！");
                NSString* msg =[NSString stringWithFormat:@"MaikefengNo"];
                [self Send_Msg_To_Unity:msg];
            }
        }];
    }
   
    NSLog(@"Ios_IniSdk  sdktype= %d  sdkp= %d",sdktype,sdkp);
    
}


-(void)SdkBuy:(NSString *)objid
{
    if(IniOk == true)
    {
        if(mysdktype==0&&CanBuyObj == true)    //使用ios 内置支付方式
        {
           
            [Mypay requestProductData:objid];
            
        }
        else                //使用 接入sdk支付方式
        {
            
            
        }
        
    }
    else
    {
        NSLog(@"Error Sdk No  Ini ");
        
    }
}


-(void) LogoutSdk;
{
    gamequit = true;
    
    if(mysdktype==0)    //使用ios 内置支付方式
    {
      if(Mypay!=NULL)
      {
          //释放
          
      }
        
        
        
    }
    else                //使用 接入sdk支付方式
    {
        
        
    }
}


- (void) Send_Msg_To_Unity:( NSString*) msg;
{
    
    UnitySendMessage([MySdkCBobjname UTF8String], [MySdkCBFunname UTF8String], [msg UTF8String]) ;
}


/*
- (void)canMakePayments {
    
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}
// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo {
    NSSet * set = [NSSet setWithArray:@[@"ProductId"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//添加监听
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)buyProdution:(UIButton *)sender{
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo:self.productIdent];
    } else {
        [self showMessage:@"用户禁止应用内付费购买"];
    }
}
//从Apple查询用户点击购买的产品的信息
- (void)getProductInfo:(NSString *)productIdentifier {
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    [self showMessageManualHide:@"正在购买，请稍后"];
}

// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [self hideHUD];
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        [self showMessage:@"无法获取产品信息，请重试"];
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self hideHUD];
    [self showMessage:[error localizedDescription]];
}
//购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    [self hideHUD];
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                self.receipt = [GTMBase64 stringByEncodingData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]]];
                [self checkReceiptIsValid];//把self.receipt发送到服务器验证是否有效
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self showMessage:@"恢复购买成功"];
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                [self showMessage:@"正在请求付费信息，请稍后"];
                break;
                
            default:
                break;
        }
    }
    
}



- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"购买失败，请重试"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alertView show];
    } else {
        [self showMessage:@"用户取消交易"];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

*/


@end
