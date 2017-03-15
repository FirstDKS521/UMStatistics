#iOS开发：通过Runtime实现友盟页面数据统计功能
![UM.png](http://upload-images.jianshu.io/upload_images/1840399-5eda422a8862c33c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

上面这张图片是友盟统计官网的截图，由此可知，如果想要实现友盟的页面统计功能，需要在每个VC中添加`viewWillAppear`和`viewWillDisappear`方法，然后再相应的实现友盟统计的API；当然，如果你的工程中有一个基类，只需要在基类中实现一次也是可以的；

如果说项目中没有基类或者是基类不唯一，也不想多次实现这两个方法，我们可以使用Runtime，动态的截取`UIViewController`的上述两个方法，只需要实现一次即可；

---

在工程中创建一个`UIViewController`的Category，然后通过Runtime动态添加两个方法，分别替代`viewWillAppear`和`viewWillDisappear`方法，我使用的是[RuntimeKit](http://www.cocoachina.com/ios/20170301/18804.html)，有兴趣的可以了解下；

在创建的`UIViewController+UMTool.m`下，实现下面的方法：

```
#import "UIViewController+UMTool.h"
#import <UMMobClick/MobClick.h>
#import "RuntimeKit.h"

@implementation UIViewController (UMTool)

+ (void)load
{
    //创建新的viewWillAppear方法
    [RuntimeKit methodSwap:[self class] firstMethod:@selector(viewWillAppear:) secondMethod:@selector(sy_viewWillAppear:)];
    //创建新的viewWillDisappear方法
    [RuntimeKit methodSwap:[self class] firstMethod:@selector(viewWillDisappear:) secondMethod:@selector(sy_viewWillDisappear:)];
}

//新的viewWillAppear方法
- (void)sy_viewWillAppear:(BOOL)animated
{
    [self sy_viewWillAppear:animated];
    //开始友盟页面统计
    [MobClick beginLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick beginLogPageView:self.title];
}

//新的viewWillDisappear方法
- (void)sy_viewWillDisappear:(BOOL)animated
{
    [self sy_viewWillDisappear:animated];
    //结束友盟页面统计
    [MobClick endLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick endLogPageView:self.title];
}

@end
```
![效果图.png](http://upload-images.jianshu.io/upload_images/1840399-9df2b0300892bbc8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

希望对有所困惑的你提供一些小小的帮助！
[Demo地址](https://github.com/FirstDKS521/UMStatistics.git)