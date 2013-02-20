library(ggplot2)
## 图3.1 发动机排量(以升为单位 displ)对高速公路耗油量(英里每加仑
## hwy)散点图。点
## 根据汽缸数目着色。该图可以发现影响燃油经济性最重要的因素：发动机排量大
## 小。
qplot(displ, hwy, data = mpg, colour = factor(cyl))

## 图3.2 ：无代码


## 图3.3 更复杂的图形一般没有特定的名称。这幅图在图3.1的基础上对每个
## 组添加了回归线。这个图应该叫什么名字呢？
qplot(displ, hwy, data = mpg, colour = factor(cyl)) + geom_smooth(data = subset(mpg, 
    cyl != 5), method = "lm")

## 图3.6 一个含有分面和多个图层的复杂图形
qplot(displ, hwy, data = mpg, facets = . ~ year) + geom_smooth()

## 图3.8
## 四种不同标度的图例。从左到右依次是:连续型变量映射到大小和颜色，离散型变
## 量映射到形状和颜色。
x <- 1:10
y <- factor(letters[1:5])
qplot(x, x, size = x)
qplot(x, x, 1:10, colour = x)
qplot(y, y, 1:10, shape = y)
qplot(y, y, 1:10, colour = y)

## 图3.9
## 三种不同坐标系的坐标轴和网格线:笛卡尔(Cartesian)、半对数(semi-log)和极
## 坐标系(polar)。极坐标系展示了非笛卡尔坐标系的缺点:很难画好坐标轴。
x1 <- c(1, 10)
y1 <- c(1, 5)
p <- qplot(x1, y1, geom = "blank", xlab = NULL, ylab = NULL) + theme_bw()
p
p + coord_trans(y = "log10")
p + coord_polar()

p <- qplot(displ, hwy, data = mpg, colour = factor(cyl))
summary(p)
# 保存图形对象
save(p, file = "plot.rdata")
# 读入图形对象
load("plot.rdata")
# 将图片保存成png格式
ggsave("plot.png", width = 5, height = 5) 
