//
//  WetChatShareManager.h
//  Lebao
//
//  Created by David on 16/3/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWOptionView.h"
typedef NS_ENUM(NSInteger,ShareType) {
    ShareWxFriendType =0, //聊天界面
    ShareWxTimeLineType //朋友圈
};
@interface WetChatShareManager : NSObject
//单例
+ (instancetype)shareInstance;
//分享图片
- (void)shareImageToWXApp:(UIImage *)image;


//邀请好友评价分享
- (void)invateFriendShareTo:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareurl:(NSString *)url type:(ShareType)sharetype;

//微信分享(知脉动态)
- (void)shareToWeixinAndLocalApp:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen InView:(UIViewController *)vc;
//微信分享
- (void)shareToWeixinApp:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen;

//本地分享
- (void)showLocalShareView:(NSArray *)arrays otherParamer:(NSArray *)Paramer title:(NSString *)title desc:(NSString *)desc  image:(UIImage *)image shareID:(NSString *)str isWxShareSucceedShouldNotice:(BOOL)isWxShareSucceedShouldNotice isAuthen:(BOOL)isAuthen;

//动态分享(分享url)
- (void)dynamicShareTo:(NSString *)title desc:(NSString *)desc image:(UIImage *)image shareurl:(NSString *)url;
//分享到微信
@property(nonatomic,assign)BOOL isWxShareSucceedShouldNotice;
@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *openId;
@property(nonatomic,strong)NSString *unionid;
@property(nonatomic,assign) BOOL isLocalShare;

@end
