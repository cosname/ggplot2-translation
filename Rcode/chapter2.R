library(ggplot2)
## 图2.1 无代码


###### 章节2.2
set.seed(1410)  # 让样本可重复

dsmall <- diamonds[sample(nrow(diamonds), 100), ]


###### 章节2.3
qplot(carat, price, data = diamonds)


###### 章节2.3
qplot(log(carat), log(price), data = diamonds)


###### 章节2.3
qplot(carat, x * y * z, data = diamonds)



## 图2.2 将 color 变量映射到点的颜色 (左)，cut 变量映射到点的形状 (右)
qplot(carat, price, data = dsmall, colour = color)

qplot(carat, price, data = dsmall, shape = cut)


## 图2.3 将 alpha 值从 1/10(左) 变动到 1/100(中) 再到
## 1/200(右)，来看大部分的点在哪里 进行重叠。
qplot(carat, price, data = diamonds, alpha = I(1/10))

qplot(carat, price, data = diamonds, alpha = I(1/100))

qplot(carat, price, data = diamonds, alpha = I(1/200))


## 图2.4
## 重量与价格的散点图中加入了平滑曲线。左图为dsmall数据集，右图为完整数据集。
qplot(carat, price, data = dsmall, geom = c("point", "smooth"))

qplot(carat, price, data = diamonds, geom = c("point", "smooth"))


## 图2.5 span 参数的作用。左图是 span=0.2，右图是 span=1。
qplot(carat, price, data = dsmall, geom = c("point", "smooth"), span = 0.2)
qplot(carat, price, data = dsmall, geom = c("point", "smooth"), span = 1)


## 图2.6 在运用广义可加模型作为平滑器时 formula 参数的作用。左图是
## formula=y~s( x)，右图是 formula=y~s(x,bs='cs')。
library(mgcv)

qplot(carat, price, data = dsmall, geom = c("point", "smooth"), method = "gam", 
    formula = y ~ s(x))

qplot(carat, price, data = dsmall, geom = c("point", "smooth"), method = "gam", 
    formula = y ~ s(x, bs = "cs"))


## 图2.7 在运用线性模型作为平滑器时 formula 参数的作用。左图是 formula =
## y ~ x 的默认值， 右图是 formula = y ~ ns(x, 5)。
library(splines)

qplot(carat, price, data = dsmall, geom = c("point", "smooth"), method = "lm")

qplot(carat, price, data = dsmall, geom = c("point", "smooth"), method = "lm", 
    formula = y ~ ns(x, 5))


## 图2.8 (书中无代码)
## 利用扰动点图(左)和箱线图(右)来考察以颜色为条件的每克拉价格的分布。
## 随着颜色的改变(从左到右)，每克拉价格的跨度逐渐减小，但分布的中位数没有明显的变化。
qplot(color, price/carat, data = diamonds, geom = "jitter")
qplot(color, price/carat, data = diamonds, geom = "boxplot")


## 图2.9 改变 alpha 的取值，从左到右分别为 1/5，1/50 和
## 1/200。随着不透明度的降低，
## 我们可以看出数据集中的地方。然而，箱线图依然是一个更好的选择。
qplot(color, price/carat, data = diamonds, geom = "jitter", alpha = I(1/5))
qplot(color, price/carat, data = diamonds, geom = "jitter", alpha = I(1/50))
qplot(color, price/carat, data = diamonds, geom = "jitter", alpha = I(1/200))


## 图2.10 展示钻石重量的分布。左图使用的是 geom='histogram' 右图使用的是
## geom=' density'。
qplot(carat, data = diamonds, geom = "histogram")
qplot(carat, data = diamonds, geom = "density")


## 图2.11 变动直方图的组距可以显示出有意思的模式。从左到右，组距分别为
## 1，0.1 和 0.01。只有重量在 0 到 3 克拉之间的钻石显示在图中。
qplot(carat, data = diamonds, geom = "histogram", binwidth = 1, xlim = c(0, 
    3))
qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.1, xlim = c(0, 
    3))
qplot(carat, data = diamonds, geom = "histogram", binwidth = 0.01, xlim = c(0, 
    3))


## 图2.12
## 当一个分类变量被映射到某个图形属性上，几何对象会自动按这个变量进行拆分。
## 左图是重叠的密度曲线图，右图是堆叠起来的直方图。
qplot(carat, data = diamonds, geom = "density", colour = color)
qplot(carat, data = diamonds, geom = "histogram", fill = color)


## 图2.13 钻石颜色的条形图。左图显示的是分组的计数，右图是按 weight=carat
## 进行加 权，展示了每种颜色的钻石的总重量。
qplot(color, data = diamonds, geom = "bar")

qplot(color, data = diamonds, geom = "bar", weight = carat) + scale_y_continuous("carat")


## 图2.14
## 衡量失业程度的两张时序图。左图是失业人口的比例，右图是失业星期数的中位
## 数。图形是用 geom='line' 进行绘制的。
qplot(date, unemploy/pop, data = economics, geom = "line")
qplot(date, uempmed, data = economics, geom = "line")


## 图2.15
## 展示失业率和失业时间长度之间关系的路径图。左图是重叠在一起的的散点图和路
## 径图，右图只有路径图，其中年份用颜色进行了展示。
year <- function(x) as.POSIXlt(x)$year + 1900
qplot(unemploy/pop, uempmed, data = economics, geom = c("point", "path"))
qplot(unemploy/pop, uempmed, data = economics, geom = "path", colour = year(date))


## 图2.16
## 展示以颜色为条件的重量的直方图。左图展示的是频数，右图展示的是频率。频率
## 图可以使得比较不同组的分布时不会受该组样本量大小的影响。高质量的钻石
## (颜色 D) 在小
## 尺寸上的分布是偏斜的，而随着质量的下降，重量的分布会变得越来越平坦。
qplot(carat, data = diamonds, facets = color ~ ., geom = "histogram", binwidth = 0.1, 
    xlim = c(0, 3))

qplot(carat, ..density.., data = diamonds, facets = color ~ ., geom = "histogram", 
    binwidth = 0.1, xlim = c(0, 3))


###### 章节2.7
qplot(carat, price, data = dsmall, xlab = "Price ($)", ylab = "Weight (carats)", 
    main = "Price-weight relationship")


###### 章节2.7
qplot(carat, price/carat, data = dsmall, ylab = expression(frac(price, carat)), 
    xlab = "Weight (carats)", main = "Small diamonds", xlim = c(0.2, 1))


###### 章节2.7
qplot(carat, price, data = dsmall, log = "xy") 