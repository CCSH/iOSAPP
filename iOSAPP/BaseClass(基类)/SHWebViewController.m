//
//  SHWebViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/10/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHWebViewController.h"
#import <WebKit/WebKit.h>

// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject < WKScriptMessageHandler >

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id< WKScriptMessageHandler > scriptDelegate;

- (instancetype)initWithDelegate:(id< WKScriptMessageHandler >)scriptDelegate;

@end
@implementation WeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id< WKScriptMessageHandler >)scriptDelegate
{
    self = [super init];
    if (self)
    {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface SHWebViewController () <
    WKNavigationDelegate,
    WKUIDelegate,
    WKScriptMessageHandler >

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation SHWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configUI];
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

#pragma mark - 配置
- (void)configUI
{
    if (self.shareModel)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAcrion)];
    }
    self.navigationItem.leftBarButtonItems = @[[self closeItem]];
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:0
                      context:nil];
    
    if (!self.title.length)
    {
        self.title = @"详情";
        //添加监测网页标题title的观察者
        [self.webView addObserver:self
                       forKeyPath:@"title"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

#pragma mark - 事件
- (void)shareAcrion
{
    SHLog(@"分享！！");
}

- (void)goBack{
    [self.webView goBack];
}

//kvo 监听进度 必须实现此方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary< NSKeyValueChangeKey, id > *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _webView)
    {
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              self.progressView.progress = 0;
            });
        }
    }
    else if ([keyPath isEqualToString:@"title"] && object == self.webView)
    {
        self.navigationItem.title = self.webView.title;
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - WKNavigationDelegate
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self.progressView setProgress:0.0f animated:NO];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.progressView setProgress:0.0f animated:NO];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.navigationItem.leftBarButtonItems = @[[self closeItem]];
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[[self closeItem],[self webBackItem]];
    }
    //app 调用 js
    NSString *js = [NSString stringWithFormat:@"appTojs('%@','%@')", @"reload", @"1"];
    [_webView evaluateJavaScript:js
               completionHandler:^(id _Nullable data, NSError *_Nullable error) {
                 NSLog(@"刷新");
               }];

}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    SHLog(@"发送跳转请求：%@", url.absoluteString);
    
    if ([url.scheme isEqualToString:@"app"]) {
        NSArray *query = [url.query componentsSeparatedByString:@"&"];
        NSMutableDictionary *param = [NSMutableDictionary new];
        for (NSString *obj in query) {
            NSArray *temp = [obj componentsSeparatedByString:@"="];
            param[temp[0]] = temp[1];
        }
        
        if (self.block) {
            self.block(url.host, param);
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
  
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSString *url = navigationResponse.response.URL.absoluteString;
    SHLog(@"当前跳转地址：%@", url);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//解决 页面内跳转（a标签等）还是取不到cookie的问题
- (void)getCookie
{
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
        @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";

    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies)
    {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //app 调用 js
    [_webView evaluateJavaScript:JSCookieString completionHandler:nil];
}

//js 调用 oc
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"方法名:%@\n内容:%@", message.name, message.body);
}

#pragma mark - 懒加载
- (WKWebView *)webView
{
    if (!_webView)
    {
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc] init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate name:@"jsToOcNoPrams"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate name:@"jsToOcWithPrams"];
        
        WKUserContentController *userController = [WKUserContentController new];
        
        NSMutableString *javascript = [NSMutableString string];
        
        //图片自适应
        NSString *js = @"var script = document.createElement('script');"
        "script.type = 'text/javascript';"
        "script.text = \"function ResizeImages() { "
        "var myimg,oldwidth;"
        "var maxwidth = %f;"
        "for(i=0;i"
        "myimg = document.images[i];"
        "if(myimg.width > maxwidth){"
        "oldwidth = myimg.width;"
        "myimg.width = %f;"
        "}"
        "}"
        "}\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - 20];
        js = [NSString stringWithFormat:@"%@%@", js, @""];
        [javascript appendString:js];
        
        //禁止缩放
        [javascript appendString:@"var script = document.createElement('meta');"
         "script.name = 'viewport';"
         "script.content=\"width=device-width, user-scalable=no\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        
        //禁止长按
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
        //禁止选择
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];
        
        //以下代码适配文本大小
        [javascript appendString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"];
        
        //用于进行JavaScript注入
        WKUserScript *script = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
       
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [WKPreferences new];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        [userController addUserScript:script];
        
        config.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, kNavContentAreaH) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, 1.0)];
        _progressView.progressTintColor = kColorMain;
        _progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (UIBarButtonItem *)webBackItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UINavigationBar appearance].backIndicatorImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    return item;
}

- (UIBarButtonItem *)closeItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];

    return item;
}


@end
