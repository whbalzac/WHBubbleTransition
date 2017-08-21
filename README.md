# WHBubbleTransition
自定义UIViewController Present样式，shrinking bubble收缩和扩张的泡沫

>####开门见山，先看效果图：
>![自定义转场动画.gif](http://upload-images.jianshu.io/upload_images/2963444-7b005d4295168826.gif?imageMogr2/auto-orient/strip)



自定义 **UIViewController Present** 样式，**shrinking bubble** 收缩和扩张的泡沫。动画来源于
[https://github.com/andreamazz/BubbleTransition](https://github.com/andreamazz/BubbleTransition)

对此进行了一些改进：

>###1. 把 swift 源码翻译成 OC

>###2. 改进了一些动画机制，具体如下

![BubbleTransition效果图.gif](http://upload-images.jianshu.io/upload_images/2963444-d7ee7b456c1e6322.gif?imageMogr2/auto-orient/strip)



从它给的效果图来看，升缩的效果非常赞 （～￣▽￣～） ——

#####但是。。
聪明的你可能已经看见了，图中的两个 **ViewController** 背景就是纯色，上面没任何其他 **View**，所以显得效果很赞。接下来我们看一下加上 **View** 的效果——

![背景添加了一张图片.gif](http://upload-images.jianshu.io/upload_images/2963444-0a6473cb15fa4e3a.gif?imageMogr2/auto-orient/strip)



这就尴尬了 a(￣3￣)a ——

利用 **Reveal** 我们看看 **View** 的层次结构。
![Reveal结果.png](http://upload-images.jianshu.io/upload_images/2963444-5fec38cee034a6a8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)



中间那一层远大于375 x 667的 **View** 很引人注目呀 （#－.－）——

再来看看代码：
````
//计算一些关键point和frame
CGPoint originalCenter = presentedControllerView.center;
CGSize originalSize = presentedControllerView.frame.size;
CGFloat lengthX = fmax(self.startPoint.x, originalSize.width - self.startPoint.x);
CGFloat lengthY = fmax(self.startPoint.y, originalSize.height - self.startPoint.y);
CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
CGSize size = CGSizeMake(offset, offset);

//上图中的大View，先缩小到最小，再用UIView的动画变大，设置cornerRadius变成圆，然后漏出下面的VC的view
self.bubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
self.bubble.layer.cornerRadius = size.height/2.0f;
self.bubble.center = self.startPoint;
self.bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
self.bubble.backgroundColor = self.bubbleColor;
[containerView addSubview:self.bubble];

//上层VC的View
presentedControllerView.center = self.startPoint;
presentedControllerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
presentedControllerView.alpha = 0;
[containerView addSubview:presentedControllerView];

[UIView animateWithDuration:self.duration animations:^{
self.bubble.transform = CGAffineTransformIdentity;
presentedControllerView.transform = CGAffineTransformIdentity;
presentedControllerView.alpha = 1;
presentedControllerView.center = originalCenter;

} completion:^(BOOL finished) {
[transitionContext completeTransition:finished];
}];
````
注释中解释了动画原因。主要的原理是View的层级关系，通过上层 ** bubble** 这个 **View**，慢慢变大，形成圆扩大的动画。但有一个前提是，下层的 **View**的背景色和** bubble**同色，混合之后，才能形成完整的动画，一旦下层 **View** 有“噪点”，这个动画就失效了。就像上面的gif展示的一样。
>####改进
>既然原代码是通过上下层 **View** 来实现，那让咱们换个思路，只需要修改一点点代码就可以——
#####iOS不是还有一个好玩的东西，叫做 maskView 的吗？
````
CGPoint originalCenter = presentedControllerView.center;
CGSize originalSize = presentedControllerView.frame.size;
CGFloat lengthX = fmax(self.startPoint.x, originalSize.width - self.startPoint.x);
CGFloat lengthY = fmax(self.startPoint.y, originalSize.height - self.startPoint.y);
CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
CGSize size = CGSizeMake(offset, offset);

self.bubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
self.bubble.backgroundColor = [UIColor redColor];
self.bubble.layer.cornerRadius = size.height/2.0f;
self.bubble.center = self.startPoint;
self.bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
//将上层 bubble 当做下层 View 的 maskView
containerView.maskView = self.bubble;

presentedControllerView.center = originalCenter;
[containerView addSubview:presentedControllerView];

[UIView animateWithDuration:self.duration animations:^{
self.bubble.transform = CGAffineTransformIdentity;
} completion:^(BOOL finished) {
[transitionContext completeTransition:finished];
}];
````
