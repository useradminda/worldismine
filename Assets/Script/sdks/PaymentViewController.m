//
//  PaymentViewController.m
//  IAPPayTest
//
//


#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

//////对外通知
-(void)CB_IniOk
{
    [[IosSdk Ins]IniSdkCB:@"IniOk"];
    
}

-(void)CB_IniOk_NoBuy
{
    [[IosSdk Ins]IniSdkCB:@"IniOk_NoBuy"];
    
}

//没有该商品
-(void) CB_NoBuyObj:(NSString * ) buyobj
{
    [[IosSdk Ins]CB_NoBuyObj:buyobj];

}
//(@"交易完成");
-(void)CB_Buy_Finish:(NSString * ) productIdentifier add2:(NSString * ) receipt add3:(int) issandbox
{
    [[IosSdk Ins]CB_Buy_Finish:productIdentifier add2:receipt add3:issandbox];
    
}

//(@"商品添加进列表");
-(void)CB_Buy_Purchasing:(NSString * ) productIdentifier
{
    [[IosSdk Ins]CB_Buy_Purchasing:productIdentifier];
    
}
//(@"已经购买过商品");
-(void)CB_Buy_Restored:(NSString * ) productIdentifier
{
    [[IosSdk Ins]CB_Buy_Restored:productIdentifier];
    
}
//(@"交易失败");
-(void)CB_Buy_Failed:(NSString * ) productIdentifier
{
    [[IosSdk Ins]CB_Buy_Failed:productIdentifier];
    
}

//(@"交易失败 用户取消");
-(void)CB_Buy_Failed_cancel:(NSString * ) productIdentifier
{
    [[IosSdk Ins]CB_Buy_Failed_cancel:productIdentifier];
    
}



///////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)IniSome
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if([SKPaymentQueue canMakePayments]==false)
    {
        [self CB_IniOk_NoBuy];
        NSLog(@"不允许程序内付费");
    }
    else
    {
        [self CB_IniOk];
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
    //创建label视图
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    //设置显示内容
    label.text = @"no sdk 苹果内置购买";
    //设置背景颜色
    label.backgroundColor = [UIColor blueColor];
    //设置文字颜色
    label.textColor = [UIColor whiteColor];
    //设置显示位置居中
    label.textAlignment = NSTextAlignmentCenter;
    //设置字体大小
    label.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:8] size:15];
    [self.view addSubview:label];
    */
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //self.productID.text = @"com.games.ztyxs.product_point.1";
    if([SKPaymentQueue canMakePayments]==false)
    {
        [self CB_IniOk_NoBuy];
        NSLog(@"不允许程序内付费");
    }
    else
    {
        [self CB_IniOk];
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//请求商品
NSString * AskBuyObjId;
- (void)requestProductData:(NSString *)type
{
    NSLog(@"-------------请求对应的产品信息-----AskBuyObjId = %@-----------",type);
    AskBuyObjId = type;
    [self SaveBuyproductIdentifier:AskBuyObjId];

    NSArray *product = [[NSArray alloc] initWithObjects:type,  nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    //[self requestceshi];
    //return;
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        [self CB_NoBuyObj:AskBuyObjId];
        AskBuyObjId =NULL;
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:AskBuyObjId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败ceshi
- (void)requestceshi
{
    
    NSString* msg =[NSString stringWithFormat:@"Error = ceshi:"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请求商品信息失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    //[alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //SKProductsRequest* thisre =request;
    //thisre.
    if( AskBuyObjId==NULL)
    {
        
        AskBuyObjId=[self GetBuyproductIdentifier];
    }
    [self CB_Buy_Failed:AskBuyObjId];
    
    
    
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
   
     NSString* msg =[NSString stringWithFormat:@"Error = :%@",error];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请求商品信息失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    //[alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //SKProductsRequest* thisre =request;
    //thisre.
    if( AskBuyObjId==NULL)
    {
        
        AskBuyObjId=[self GetBuyproductIdentifier];
    }
    [self CB_Buy_Failed:AskBuyObjId];

    
    
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品购买中");
                //[self CB_Buy_Purchasing];
               
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                
                 [self restoreTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败  error.code= %ld",tran.error.code);
               NSString* msg =[NSString stringWithFormat:@"SKPaymentTransactionStateFailed tran.error.code= :%ld",tran.error.code];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"购买商品失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                //[alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];

                [self failedTransaction:tran];
                break;
            }
            default:
                NSLog(@"sk pay error transactionState= %ld",(long)tran.transactionState);

                break;
        }
    }
}

//交易成功
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易成功");
    NSString * receipt;
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] > 6.9f) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];//苹果推荐
        NSError *error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
       
         receipt = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else {
        receipt = transaction.transactionReceipt;
    }
    if ([productIdentifier length] > 0) {
         //BOOL issandbox = transaction.payment.simulatesAskToBuyInSandbox;
        int i_issandbox =1;
        //if(issandbox==true)
        //{
        //    i_issandbox =1;
        
       //}
       
        // 向自己的服务器验证购买凭证
        [self CB_Buy_Finish:productIdentifier add2:receipt add3:i_issandbox];
    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    AskBuyObjId =NULL;
}




- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSString * productIdentifier = transaction.payment.productIdentifier;

    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
         [self CB_Buy_Failed:productIdentifier];
    } else {
        NSLog(@"用户取消交易");
         [self CB_Buy_Failed_cancel:productIdentifier];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    AskBuyObjId =NULL;
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSString * productIdentifier = transaction.payment.productIdentifier;

    // 对于已购商品，处理恢复购买的逻辑
    [self CB_Buy_Restored:productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    AskBuyObjId =NULL;
}

-(void) SaveBuyproductIdentifier:(NSString*) productIdentifier
{
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

//存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下

[userDefaults setObject:productIdentifier forKey:@"productIdentifier"];


//立刻保存（同步）数据（如果不写这句话，会在将来某个时间点自动将数据保存在preferences目录下）

[userDefaults synchronize];

NSLog(@"数据已保存 productIdentifier = %@",productIdentifier);
}
-(NSString*) GetBuyproductIdentifier
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //读取数据
    
    NSString *productIdentifier  = [userDefaults objectForKey:@"productIdentifier"];
    
    
    //打印数据
    
    NSLog(@"productIdentifier = %@ ",productIdentifier);
    
    return productIdentifier;
}
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    //[super dealloc];
}

@end
