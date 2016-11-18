//
//  DiscoverDetailViewController.m
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "XLDataService.h"
#import "IMYWebView.h"
#import "WetChatShareManager.h"//本地分享
#import "NSString+Extend.h"
//发现 URL:appinterface/articlelib
#define ArticlelibURL [NSString stringWithFormat:@"%@library/detail",HttpURL]

@interface DiscoverDetailViewController ()<IMYWebViewDelegate>
@property(nonatomic,strong)IMYWebView *webView;
@property(nonatomic,strong)BaseButton *collect;
@property(nonatomic,strong)DiscoverDetailModal *modal;
@end

@implementation DiscoverDetailViewController
{
   
    UIScrollView *view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@"detail" forKey:Conduct];
    [parame setObject:_ID forKey:@"acid"];
    
    [self navView];
    [self addMainView:parame];
   
    
   
}
#pragma mark - Navi_View
- (void)navView
{
    
    NSString *title = @"详情";
//    switch (_tag) {
//        case 0:
//            title =@"保险详情";
//            break;
//        case 1:
//            title =@"金融详情";
//            break;
//        case 2:
//            title =@"房产详情";
//            break;
//        case 3:
//            title =@"原创详情";
//            break;
//            
//        default:
//            break;
//    }
//    if (_Nav_title) {
//        title =  _Nav_title;
//    }
    [self navViewTitleAndBackBtn:title];
    
    
    
}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    if (view) {
        [view removeFromSuperview];
    }
    view = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight + 10, APPWIDTH, APPHEIGHT -(StatusBarHeight + NavigationBarHeight + 10)));
    view.backgroundColor = WhiteColor;
    [self.view addSubview:view];
    
    __weak DiscoverDetailViewController *weakSelf =self;
    [[ToolManager shareInstance] showWithStatus];
//    NSLog(@"parame =%@",parame);
    [XLDataService postWithUrl:ArticlelibURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] dismiss];
        
        NSLog(@"data =%@",dataObj);
        weakSelf.webView = allocAndInitWithFrame(IMYWebView, CGRectZero);
        weakSelf.webView.backgroundColor = WhiteColor;
        weakSelf.webView.delegate = self;
        weakSelf.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        weakSelf.webView.scrollView.scrollEnabled = NO;
        [view addSubview:weakSelf.webView];
        if (dataObj) {
            
          weakSelf.modal = [DiscoverDetailModal mj_objectWithKeyValues:dataObj];
        if (weakSelf.modal.rtcode ==1) {
    
             [self twoBtn:weakSelf];
            
                UILabel * _descrip= [UILabel createLabelWithFrame:frame(10, 5, APPWIDTH - 20, 30) text:@"" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
                _descrip.numberOfLines = 0;
                _descrip.text = weakSelf.modal.datas.title;
                
                CGSize size = [_descrip sizeWithContent:_descrip.text font:[UIFont systemFontOfSize:26*SpacedFonts]];
                _descrip.frame = frame( 10, 5, APPWIDTH - 20, size.height);
                UIImage *imagetime =[UIImage imageNamed:@"exhibition_time"];
                UILabel *time =allocAndInit(UILabel);
                CGSize sizeTime = [time sizeWithContent:@"2015 - 12 - 31" font:[UIFont systemFontOfSize:22*SpacedFonts]];
                
                NSString *times =weakSelf.modal.datas.createtime;
//                NSLog(@"times =%@",times);
                BaseButton* _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), size.height + 15 , imagetime.size.width + 5 + sizeTime.width, imagetime.size.height-2)  setTitle:[times timeformatString:@"yyyy-MM-dd"]titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:view];
                _time.shouldAnmial = NO;
                
                
//                UIImage *image =[UIImage imageNamed:@"exhibition_brose"];
//                CGSize sizebrowse = [time sizeWithContent:weakSelf.modal.datas.readcount font:[UIFont systemFontOfSize:22*SpacedFonts]];
//                
//                BaseButton* _browse = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_time.frame) + 10, frameY(_time), image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:weakSelf.modal.datas.readcount titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:view];
//                _browse.shouldAnmial = NO;
            
                float height =CGRectGetMaxY(_time.frame)  +10 ;
                                    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(10, CGRectGetMaxY(_time.frame)  + 6, APPWIDTH - 20, 1.0));
                    line1.backgroundColor = LineBg;
                    [view addSubview:line1];
            
                weakSelf.webView.frame= frame(5, height, APPWIDTH -10, 0);
                
                
                [weakSelf.webView loadHTMLString:weakSelf.modal.datas.content baseURL:nil];
            }
            else
            {
                [weakSelf.webView loadHTMLString:@"没有相关数据" baseURL:nil];
            }
            
            
        }
        else
        {
            [weakSelf.webView loadHTMLString:[NSString stringWithFormat:@"<p>%@</p>",weakSelf.modal.rtmsg] baseURL:nil];
            
        }
        
        
    }];
    
    
}
#pragma mark - UIWebview delegete

- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [self webViewFitToScale:webView];
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id objc, NSError * error) {

        if (!error) {
            CGFloat height = [objc floatValue];
           
            CGRect frame = webView.frame;
            webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
        
            view.contentSize = CGSizeMake(frameWidth(view), 70 + height);
        }
    }];
    
}
//结合JS解决用webVIew加载图片时图片自动适配屏幕的问题
- (void)webViewFitToScale:(IMYWebView *)webView
{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView evaluateJavaScript:js completionHandler:^(id objc, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:^(id objc, NSError *error) {
        
    }];
    
}

#pragma mark
#pragma mark -
- (void)twoBtn:(DiscoverDetailViewController *)weakSelf
{
    BaseButton *share = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) backgroundImage:nil iconImage:[UIImage imageNamed:@"icon_widelyspreaddetail_share"] highlightImage:nil inView:self.view];
    
    share.didClickBtnBlock = ^
    {
        
        [[WetChatShareManager shareInstance] dynamicShareTo:_modal.datas.title desc:_modal.datas.title image:_shareImage shareurl:_modal.datas.share_url];
    };
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation DiscoverDetailModal


@end

@implementation DiscoverDetailData
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{
                    @"ID":@"id",
                    
                    };
}

@end
