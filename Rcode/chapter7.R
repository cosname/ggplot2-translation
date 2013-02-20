library(ggplot2)
## 图7.1 无代码



###### 章节7.2
mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))


###### 章节7.2.1 和 qplot(cty, hwy, data = mpg2) 效果一样
qplot(cty, hwy, data = mpg2) + facet_null()


###### 章节7.2.1
qplot(cty, hwy, data = mpg2) + facet_grid(. ~ cyl)


###### 章节7.2.1
qplot(cty, data = mpg2, geom = "histogram", binwidth = 2) + facet_grid(cyl ~ 
    .)


###### 章节7.2.1
qplot(cty, hwy, data = mpg2) + facet_grid(drv ~ cyl)


###### 章节7.2.1
p <- qplot(displ, hwy, data = mpg2) + geom_smooth(method = "lm", se = F)
p + facet_grid(cyl ~ drv)
p + facet_grid(cyl ~ drv, margins = T)


## 图7.2
## 图形的边际图生成与列联表类似，提供给我们一个无依赖条件的数据观察视角。左图
## 展示了根据气缸数和驱动器数生成的分面图形，右图补充了它们的边际图。
qplot(displ, hwy, data = mpg2) + geom_smooth(aes(colour = drv), method = "lm", 
    se = F) + facet_grid(cyl ~ drv, margins = T)



## 图7.3 每十年电影平均评分的分布。
movies$decade <- round_any(movies$year, 10, floor)
# round_any() 需要加载 plyr 包
qplot(rating, ..density.., data = subset(movies, decade > 1890), geom = "histogram", 
    binwidth = 0.5) + facet_wrap(~decade, ncol = 6)


## 图7.4
## 每个分面中固定尺度即有横纵坐标范围相同的尺度(左图)，而自由的尺度即横纵坐标范围尺度可变(右图)
p <- qplot(cty, hwy, data = mpg)
p + facet_wrap(~cyl)
p + facet_wrap(~cyl, scales = "free")


## 图7.5 自由标度在展示不同量纲的时间序列时非常有用。
em <- melt(economics, id = "date")
# 0.9.0版本中 melt() 函数需要加载 reshape2 包
qplot(date, value, data = em, geom = "line", group = variable) + facet_grid(variable ~ 
    ., scale = "free_y")


## 图7.6 每种小汽车的城市油耗英里数的点图。(左)车类型按mpg均值排序，
## (右)使用 scales = 'free_y' 和 pace = 'free' ，按生产商进行分面。
mpg3 <- within(mpg2, {
    model <- reorder(model, cty)
    manufacturer <- reorder(manufacturer, -cty)
})
models <- qplot(cty, model, data = mpg3)

models
models + facet_grid(manufacturer ~ ., scales = "free", space = "free") + theme(strip.text.y = element_text())


## 图7.7 分面与分组的差异：克拉与价格的双对数图，四种颜色标注。
xmaj <- c(0.3, 0.5, 1, 3, 5)
xmin <- as.vector(outer(1:10, 10^c(-1, 0)))
ymaj <- c(500, 1000, 5000, 10000)
ymin <- as.vector(outer(1:10, 10^c(2, 3, 4)))
dplot <- ggplot(subset(diamonds, color %in% c("D", "E", "G", "J")), aes(carat, 
    price, colour = color)) + scale_x_log10(breaks = xmaj, labels = xmaj, minor = xmin) + 
    scale_y_log10(breaks = ymaj, labels = ymaj, minor = ymin) + scale_colour_hue(limits = levels(diamonds$color)) + 
    theme(legend.position = "none")

dplot + geom_point()
dplot + geom_point() + facet_grid(. ~ color)

dplot + geom_smooth(method = lm, se = F, fullrange = T)
dplot + geom_smooth(method = lm, se = F, fullrange = T) + facet_grid(. ~ color)


## 图7.8 并列(上)vs分面(下)对于水平完全交叉的变量对。
qplot(color, data = diamonds, geom = "bar", fill = cut, position = "dodge")
qplot(cut, data = diamonds, geom = "bar", fill = cut) + facet_grid(. ~ color) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8, colour = "grey50"))


## 图7.9
## 对于嵌套型数据，分面(上，中)的优势相比并列(下)是明显的，它能控制图形并进行标注。
## 此例中，上图不是很实用，但对于几乎交叉的数据非常有用，比如缺失了一个水平组合的情况。

mpg4 <- subset(mpg, manufacturer %in% c("audi", "volkswagen", "jeep"))
mpg4$manufacturer <- as.character(mpg4$manufacturer)
mpg4$model <- as.character(mpg4$model)

base <- ggplot(mpg4, aes(fill = model)) + geom_bar(position = "dodge") + theme(legend.position = "none")

base + aes(x = model) + facet_grid(. ~ manufacturer)
last_plot() + facet_grid(. ~ manufacturer, scales = "free_x", space = "free")
base + aes(x = manufacturer)



## 图7.10
## 将连续变量离散化的三种方式。从上至下：面板长度为1；每个面板等长；
## 每个面板包含点数目相同。
mpg2$disp_ww <- cut_interval(mpg2$displ, length = 1)
mpg2$disp_wn <- cut_interval(mpg2$displ, n = 6)
mpg2$disp_nn <- cut_number(mpg2$displ, n = 6)

plot <- qplot(cty, hwy, data = mpg2) + labs(x = NULL, y = NULL)
plot + facet_wrap(~disp_ww, nrow = 1)
plot + facet_wrap(~disp_wn, nrow = 1)
plot + facet_wrap(~disp_nn, nrow = 1)


## 图7.11 无代码


## 图7.12 无代码


## 图7.13 坐标系的范围设置 vs 标度的范围设置。(左) 完整的数据集；(中)x
## 的标度范围设置 为 (325,500)；(右) 坐标系 x 轴范围设置为
## (325,500)。坐标系的放缩就是图像的放缩，而
## 标度的范围设置则是对数据取子集，然后再重新拟合曲线。
(p <- qplot(disp, wt, data = mtcars) + geom_smooth())
p + scale_x_continuous(limits = c(325, 500))
p + coord_cartesian(xlim = c(325, 500))


## 图7.14 坐标系的范围设置 vs 标度的范围设置。(左) 完整的数据集；(中)x
## 的标度范围设置 为 (0,2)；(右) 坐标系的 x 轴设置为
## (0,2)。比较方块的大小：当设定标度范围时，方块的
## 数目还是相同的，只是覆盖了更少数据的区域；当设定坐标系范围时，方块数目变少，但他
## 们覆盖的区域没变。
(d <- ggplot(diamonds, aes(carat, price)) + stat_bin2d(bins = 25, colour = "grey70") + 
    theme(legend.position = "none"))
d + scale_x_continuous(limits = c(0, 2))
d + coord_cartesian(xlim = c(0, 2))



## 图7.15 (左) 散点图和相应的平滑曲线，x 轴代表发动机排量 (displ) 和 y
## 代表城市油耗 (cty)。(中) 互换两个变量 cty 和 displ 使图形旋转 90
## 度，平滑曲线拟合的是旋转后的变 量。(右) coord_flip
## 拟合初始数据，然后再翻转输出结果，就变成了以 y 为条件变量刻画 x
## 的曲线了。
qplot(displ, cty, data = mpg) + geom_smooth()
qplot(cty, displ, data = mpg) + geom_smooth()
qplot(cty, displ, data = mpg) + geom_smooth() + coord_flip()



## 图7.16 (左) 克拉与价格对数转换后的散点图。直线为回归曲线：log(y)= a +
## b log(x)。 (右) 将前面的图转换回去 (
## coord_trans(x='pow10',y='pow10'))，标度还原，因此线
## 性趋势变成指数形式，y = k
## c^x。图形很明显地揭示了克拉越大钻石越贵，且增幅速度越大。
qplot(carat, price, data = diamonds, log = "xy") + geom_smooth(method = "lm")
## 译者注: 原书中为'pow10'，0.9.0 中为 exp_trans(10)，且需加载scales包
library(scales)
last_plot() + coord_trans(x = exp_trans(10), y = exp_trans(10))


## 图7.17 (左) 堆叠的条状图。(中)
## 极坐标中堆叠的条状图，常被称为饼图，其中，x 被 映射成了半径，y
## 坐标映射成了角度，coord_polar(theta='y')。(右) 映射的变量相反，
## coord_polar(theta='x')，这个图常被称为牛眼图。 堆叠条状图
(pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) + geom_bar(width = 1))
# 饼图
pie + coord_polar(theta = "y")

# 牛眼图
pie + coord_polar() 