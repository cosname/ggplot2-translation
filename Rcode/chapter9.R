library(ggplot2)
library(plyr)
###### 章节9.1 选取各个颜色里最小的钻石
ddply(diamonds, .(color), subset, carat == min(carat))
# 选取最小的两颗钻石
ddply(diamonds, .(color), subset, order(carat) <= 2)
# 选取每组里大小为前1%的钻石
ddply(diamonds, .(color), subset, carat > quantile(carat, 0.99))
# 选出所有比组平均值大的钻石
ddply(diamonds, .(color), subset, price > mean(price))


###### 章节9.1 把每个颜色组里钻石的价格标准化，使其均值为0，方差为1
ddply(diamonds, .(color), transform, price = scale(price))
# 减去组均值
ddply(diamonds, .(color), transform, price = price - mean(price))


###### 章节9.1
nmissing <- function(x) sum(is.na(x))
nmissing(msleep$name)
nmissing(msleep$brainwt)

nmissing_df <- colwise(nmissing)
nmissing_df(msleep)

# This is shorthand for the previous two steps
colwise(nmissing)(msleep)


###### 章节9.1
msleep2 <- msleep[, -6]  # Remove a column to save space
numcolwise(median)(msleep2, na.rm = T)
numcolwise(quantile)(msleep2, na.rm = T)

numcolwise(quantile)(msleep2, probs = c(0.25, 0.75), na.rm = T)


###### 章节9.1
ddply(msleep2, .(vore), numcolwise(median), na.rm = T)

ddply(msleep2, .(vore), numcolwise(mean), na.rm = T)


###### 章节9.1
my_summary <- function(df) {
    with(df, data.frame(pc_cor = cor(price, carat, method = "spearman"), lpc_cor = cor(log(price), 
        log(carat))))
}
ddply(diamonds, .(cut), my_summary)

ddply(diamonds, .(color), my_summary)



## 图9.1 图中是不同颜色钻石 price 对 carat
## 的平滑趋势。左图是全部数据，可以看到重量 大于 2
## 克拉后，标准差就激增，因为重量大于 2
## 克拉的钻石的个数较少。右图我们只画重量 小于 2
## 克拉的钻石，重点关注数据较多的区域。
library(ggplot2)
qplot(carat, price, data = diamonds, geom = "smooth", colour = color)
dense <- subset(diamonds, carat < 2)
qplot(carat, price, data = dense, geom = "smooth", colour = color, fullrange = TRUE)


## 图9.2 手动计算图 9.1 中统计量。左图为预测值，右图加上标准差。
library(mgcv)
library(plyr)
smooth <- function(df) {
    mod <- gam(price ~ s(carat, bs = "cs"), data = df)
    grid <- data.frame(carat = seq(0.2, 2, length = 50))
    pred <- predict(mod, grid, se = T)
    grid$price <- pred$fit
    grid$se <- pred$se.fit
    grid
}
smoothes <- ddply(dense, .(color), smooth)
qplot(carat, price, data = smoothes, colour = color, geom = "line")
qplot(carat, price, data = smoothes, colour = color, geom = "smooth", ymax = price + 
    2 * se, ymin = price - 2 * se)


###### 章节9.1.1
mod <- gam(price ~ s(carat, bs = "cs") + color, data = dense)
grid <- with(diamonds, expand.grid(carat = seq(0.2, 2, length = 50), color = levels(color)))
grid$pred <- predict(mod, grid)
qplot(carat, pred, data = grid, colour = color, geom = "line")



## 图9.3 （书中无代码） 如果 economics
## 数据是“宽”的格式时，很容易分别画出两个变量的时间序列图 (左
## 图和中图)，也很容易画出散点图 (右图)。
qplot(date, uempmed, data = economics, geom = "line")
qplot(date, unemploy, data = economics, geom = "line")
qplot(unemploy, uempmed, data = economics) + geom_smooth()


## 图9.4
## 两种方法都能把两个序列画在一张图上，并且结果一样。但是“长”的数据在处理多
## 变量的时候更方便。由于两个序列取值不在一个数量级上，所以只能看到
## unemploy 的变化 形式。仔细看会发现在图形的底下还有条线，那就是 uempmed
## 的趋势线。
ggplot(economics, aes(date)) + geom_line(aes(y = unemploy, colour = "unemploy")) + 
    geom_line(aes(y = uempmed, colour = "uempmed")) + scale_colour_hue("variable")
require(reshape2)
emp <- melt(economics, id = "date", measure = c("unemploy", "uempmed"))
qplot(date, value, data = emp, geom = "line", colour = variable)


## 图9.5
## 当序列数据大小差异很大时，可以使用两个方法：左图，把数据调整到相同的尺度
## 上；或把数据画在不同的分面图形上。
range01 <- function(x) {
    rng <- range(x, na.rm = TRUE)
    (x - rng[1])/diff(rng)
}
emp2 <- ddply(emp, .(variable), transform, value = range01(value))
qplot(date, value, data = emp2, geom = "line", colour = variable, linetype = variable)
qplot(date, value, data = emp, geom = "line") + facet_grid(variable ~ ., scales = "free_y")


###### 章节9.2.2
popular <- subset(movies, votes > 10000)
ratings <- popular[, 7:16]
ratings$.row <- rownames(ratings)
molten <- melt(ratings, id = ".row")



## 图9.6 调整平行坐标图是更好的突出数据模式。为了改进默认的图形
## (左上)，我们尝试了 alpha blending (右上)，jittering (左下)
## 和同时用这两方法 (右下)。
pcp <- ggplot(molten, aes(variable, value, group = .row))
pcp + geom_line()
pcp + geom_line(colour = "black", alpha = 1/20)
jit <- position_jitter(width = 0.25, height = 2.5)
pcp + geom_line(position = jit)
pcp + geom_line(colour = "black", alpha = 1/20, position = "jitter")


###### 章节9.2.2
cl <- kmeans(ratings[1:10], 6)
ratings$cluster <- reorder(factor(cl$cluster), popular$rating)
levels(ratings$cluster) <- seq_along(levels(ratings$cluster))
molten <- melt(ratings, id = c(".row", "cluster"))



## 图9.7 BUG+BUG
## 用平行坐标图展示各类数据。左图是全部数据，不同颜色表示不同类；右图是类内均值。
pcp_cl <- ggplot(molten, aes(variable, value, group = .row, colour = cluster))
pcp_cl + geom_line(position = "jitter", alpha = 1/5)
pcp_cl + stat_summary(aes(group = cluster), fun.y = mean, geom = "line")  ##


## 图9.8 faceting
## 把每个类都放在单独的图内，可以看出类内差异还是相当大的，说明需要增加类的个数。
pcp_cl + geom_line(position = jit, colour = "black", alpha = 1/5) + facet_wrap(~cluster)


## 图9.9 （书中无代码） plot.lm() 一个简单模型的输出结果。


## 图9.10 一个拟合得不好的简单线性模型
qplot(displ, cty, data = mpg) + geom_smooth(method = "lm")
mpgmod <- lm(cty ~ displ, data = mpg)


## 图9.11 (左) 基本的拟合值 -残差图。(中) 标准化的残差。(右) 点大小与
## Cook 距离成比例。 只要有全部的数据就可以很容易的修改基本图形。
mod <- lm(cty ~ displ, data = mpg)
basic <- ggplot(mod, aes(.fitted, .resid)) + geom_hline(yintercept = 0, colour = "grey50", 
    size = 0.5) + geom_point() + geom_smooth(size = 0.5, se = F)
basic
basic + aes(y = .stdresid)
basic + aes(size = .cooksd) + scale_size_area("Cook’s distance")


###### 章节9.3.1
full <- basic %+% fortify(mod, mpg)
full + aes(colour = factor(cyl))
full + aes(displ, colour = factor(cyl))


## 图9.12 把原数据中的变量加到当前模型里可能会产生新的发现。比如 displ 与
## cty 之间 似乎是曲线关系，但增加了气缸数量变量 cyl
## 后，可以看到只要给定了 cyl，displ 与 cty 之间其实是呈线性关系的。
full <- basic %+% fortify(mod, mpg)
full + aes(colour = factor(cyl))
full + aes(displ, colour = factor(cyl))

## 把本书作者Hadley的图像放在图中。
fortify.Image <- function(model, data, ...) {
  colours <- channel(model, "x11")
  colours <- colours[, rev(seq_len(ncol(colours)))]
  melt(colours, c("x", "y"))
}
## 安装EBImage包：
## source("http://bioconductor.org/biocLite.R") 
## biocLite("EBImage")

library(EBImage)
library(reshape2)
library(ggplot2)
img <- readImage("http://had.co.nz/me.jpg")

qplot(x, y, data = img, fill = value, geom="tile") +
  scale_fill_identity() + coord_equal()  
