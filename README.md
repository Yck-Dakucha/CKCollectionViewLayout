# CKCollectionViewLayout
基于CollectionView的自定义布局和自定义流水布局Demo  

_ps：本文是参照简书<http://www.jianshu.com/p/83f2d6ac7e68>仿写学习使用自定义布局与流水布局的Demo，其中增加了部分内容。原作者已经讲述的非常清晰，非常感谢原作者做出的贡献。这里只做出遇到的而原文没有的事项_
###图例：  
![](https://raw.githubusercontent.com/Yck-Dakucha/CKCollectionViewLayout/master/Picture/Demo.gif)

###增加的内容有
* `记录浏览位置，在切换浏览方式时记录了浏览位置（各个方式之间不通）`
* `环形排布按顺时针排放，而且数据中第一个model在环形顶部`
* `水平排布增加单页翻页效果`

###一些基础方法的含义
CollectionView可以进行很多种形式的自定义，而且支持水平滚动和垂直滚动，在我们新建一个CollectionView的时候需要传一个不为空的Layout，而这个Layout就决定了collectionView的Cell怎么去排布。
主要用到的是`UICollectionViewFlowLayout`（流水布局）和`UICollectionViewLayout`（基础布局）  

首先我们要知道的是`UICollectionViewFlowLayout`是继承自`UICollectionViewLayout`的，让我们去`UICollectionViewLayout`中看看有什么方法，自定义布局只要理解几个方法的作用就可以为所欲为了  

![](https://raw.githubusercontent.com/Yck-Dakucha/CKCollectionViewLayout/master/Picture/CollectionViewLayoutMethod.png)  

其中较为常用的方法已在图中标注出来，这些方法都是干什么用的呢？

* `- (void)prepareLayout;`

这个方法是交给子类重写的方法，当collectionView的显示范围发生改变的时候一旦重新刷新布局，就会重新调用这个方法，推荐一些属性也放在这里来进行初始化，因为可能布局还没有添加到布局中，则会返回空。在水平布局中因为每次拖动都会出发这个方法，所以推荐对初始化属性进行加锁，只初始化一次。

```
if (!self.isLayout) {
		//这样设置是为了第一个及最后一个视图在collectionView的中间位置
        CGFloat inset           = self.collectionView.frame.size.width * 0.5 - self.itemSize.width * 0.5;
        //section的偏移量（上左下右）
        self.sectionInset       = UIEdgeInsetsMake(0, inset, 0, inset);
        self.minimumLineSpacing = 10;
        self.isLayout = YES;
}
```
* `- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;` 

当collectionView的显示范围发生改变的时候，他的返回值决定了是否刷新布局，一旦重新刷新布局，就会调用`1.prepareLayout 2.layoutAttributesForElementsInRect`

* `- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect` 

我们现理解`UICollectionViewLayoutAttributes`,  

1. 它是用来描述布局属性的
2. 每个cell都对应自己的UICollectionViewLayoutAttributes对象
3. UICollectionViewLayoutAttributes对象决定了cell展现的样式，位置

而这个方法就返回了在rect这个区域内左右cell的UICollectionViewLayoutAttributes对象的数组

```
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //先取出系统已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //计算collectionView最中心点的X坐标,这里的中心店需加上偏移量
    CGFloat centerX = self.collectionView.frame.size.width * 0.5 + self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //原cell的中心与要显示的中心及collectionView的最中心点之间的距离
        CGFloat spacing = ABS(centerX - attributes.center.x);
        //根据间距算出缩放的比例
        CGFloat scale = 1 - spacing/self.collectionView.frame.size.width;
        //设置缩放
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}
```

* `- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; ` 

它的返回值，就决定了collectionView停止滚动时的偏移量,这个方法在你手离开屏幕之前会调用，也就是cell即将停止滚动的时候,这个方法返回的参数`(CGPoint)proposedContentOffset`，这是它本应该停留的位置，最终停留的的值。而`(CGPoint)targetContentOffsetForProposedContentOffset`:这个是你最终返回的值，也就是你要它停留到哪儿的值（这个参数决定你要cell最后停留在哪儿），velocity 是速率

* `- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset `  

它的返回值决定了视图刷新后或者初始化后将要显示的位置，这里用来设置在切换后再切换回来仍然记录刚才位置

* `- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;`

这个方法在水平布局的时候用不到，这里一起解释了，他返回的是对应每个indexPath的cell的UICollectionViewLayoutAttributes，可以在这个方法里对具体每个cell进行深度的定制。
这里需要注意的是如果你继承的是UICollectionViewLayout而且需要进行布局切换，在布局切换的时候这个方法一定要实现，不然会报错`no UICollectionViewLayoutAttributes instance for -layoutAttributesForItemAtIndexPath:`  

###下面我们来进行具体的实现  
####1.水平布局
水平布局主要用到的是`UICollectionViewFlowLayout`，即流水布局，何为流水，就是在一行满了之后就会流向下一行，UICollectionViewFlowLayout有几个常用属性：  

* scrollDirection 决定了他的滚动方向，默认是垂直`UICollectionViewScrollDirectionVertical`，这里我们需要把设置为水平`UICollectionViewScrollDirectionHorizontal`  
* itemSize 决定了每个cell的大小
* sectionInset 决定了collectionView的section的偏移量，偏移方向是上左下右
* 其他属性不一一解释了

我们要做到水平布局，需要把collectionView的高度调小，在高度不足显示两排的时候，就会变成了水平的  


 





