# CJTCarouselFigure
一个支持 URL 与本地图片的混合的无限循环滚动图
主要实现：
1、多张图片无缝向右无限循环；
2、pageController 的值，随着 scrollView 的变化而变化；
3、可通过设置 openTime 打开自动滚动；
4、自己实现一个三层缓存。

实现原理：
1、首尾各多设置一张图片，作为滚动后对其位置进行切换；
2、通过判断 contentOffset，计算页数；
