library(effects)
library(ggplot2)
## 图5.1
# 使用不同的基本几何对象绘制相同数据的效果。从左上到右下的图形名称分别为：散
# 点图、条形图、线图、面积图、路径图、含标签的散点图、色深图/水平图和多边形图。注意
# 观察条形图、面积图和瓦片图的坐标轴范围：这三种几何对象占据了数据本身范围以外的空
# 间，于是坐标轴被自动拉伸了。
df <- data.frame(
  x = c(3, 1, 5),
  y = c(2, 4, 6),
  label = c("a","b","c")
)
p <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
p + geom_point() + labs(title = "geom_point")
p + geom_bar(stat="identity") +
    labs(title = "geom_bar(stat=\"identity\")")
p + geom_line() + labs(title = "geom_line")
p + geom_area() + labs(title = "geom_area")
p + geom_path() + labs(title = "geom_path")
p + geom_text(aes(label = label)) + labs(title = "geom_text")
p + geom_tile() + labs(title = "geom_tile")
p + geom_polygon() + labs(title = "geom_polygon")


## 图5.2
## 永远不要指望依靠默认的参数就能对某个具体的分布获得一个表现力强的图形
## (左图)。(右图) 对 x 轴进行了放大，xlim = c(55,
## 70)，并选取了一个更小的组距宽度， binwidth =
## 0.1，较左图揭示出了更多细节。我们可以发现这个分布是轻度右偏的。同时别
## 忘了在标题中写上重要参数 (如组距宽度) 的信息。
qplot(depth, data = diamonds, geom = "histogram")
qplot(depth, data = diamonds, geom = "histogram", xlim = c(55, 70), binwidth = 0.1)


## 图5.3
## 钻石数据切割和深度分布的三种视图。从上至下分别是分面直方图、条件密度图和频
## 率多边形图。它们都显示了出一个有趣的模式：随着钻石质量的提高，分布逐渐向左偏移且
## 愈发对称。
depth_dist <- ggplot(diamonds, aes(depth)) + xlim(58, 68)
depth_dist + geom_histogram(aes(y = ..density..), binwidth = 0.1) + facet_grid(cut ~ 
    .)
depth_dist + geom_histogram(aes(fill = cut), binwidth = 0.1, position = "fill")
depth_dist + geom_freqpoly(aes(y = ..density.., colour = cut), binwidth = 0.1)


## 图5.4 箱线图可以用于观察针对一个类别型变量 (如 cut) 取条件时
## (左图)，或连续型变量 (如 carat) 取条件时
## (右图)，连续型变量的分布情况。对于连续型变量，必须设置 group 图
## 形属性以得到多个箱线图。此处使用了group = round_any(carat, 0.1, floor)
## 来获得针 对变量carat 以 0.1 个单位为大小分箱后的箱线图。
library(plyr)
qplot(cut, depth, data = diamonds, geom = "boxplot")
qplot(carat, depth, data = diamonds, geom = "boxplot", group = round_any(carat, 
    0.1, floor), xlim = c(0, 3))


## 图5.5 几何对象 jitter
## 可在二维分布中有一个离散型变量时绘制出一个较为粗略的图
## 形。总体来说，这种数据打散的处理对小数据集更有效。上图展示了 mpg
## 数据集中离散型变 量 class 和连续型变量 city，下图则将连续型变量 city
## 替换为离散型变量 drv。
qplot(class, cty, data = mpg, geom = "jitter")
qplot(class, drv, data = mpg, geom = "jitter")


## 图5.6
## 密度图实际上就是直方图的平滑化版本。它的理论性质比较理想，但难以由图回溯到
## 数据本身。左图为变量 depth 的密度图。右图为按照变量 cut
## 的不同取值上色的版本。
qplot(depth, data = diamonds, geom = "density", xlim = c(54, 70))
qplot(depth, data = diamonds, geom = "density", xlim = c(54, 70), fill = cut, 
    alpha = I(0.2))


## 图5.7
## 修改使用的符号可以帮助我们处理轻微到中等程度的过度绘制问题。从左至右分别
## 为：默认的 shape、shape = 1(中空的点)，以及 shape= '.'(像素大小的点)。
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()
norm + geom_point(shape = 1)
norm + geom_point(shape = ".")  # 点的大小为像素级


## 图5.8 以从一个二元正态数据中抽样所得的数据为例，使用 alpha
## 混合来减轻过度绘制问题。alpha 值从左至右分别为：1/3, 1/5, 1/10。
norm + geom_point(colour = "black", alpha = 1/3)
norm + geom_point(colour = "black", alpha = 1/5)
norm + geom_point(colour = "black", alpha = 1/10)


## 图5.9 diamond 数据中的变量table 和变量 depth
## 组成的图形，展示了如何使用数据打 散和 alpha
## 混合来减轻离散型数据中的过度绘制问题。从左至右为：不加任何处理的点，使用
## 默认扰动参数打散后的点，横向扰动参数为 0:5 (横轴单位距离的一半)
## 时打散后的点，alpha 值 1/10，alpha 值 1/50，alpha 值 1/200。
td <- ggplot(diamonds, aes(table, depth)) + xlim(50, 70) + ylim(50, 70)
td + geom_point()
td + geom_jitter()
jit <- position_jitter(width = 0.5)
td + geom_jitter(position = jit)
td + geom_jitter(position = jit, colour = "black", alpha = 1/10)
td + geom_jitter(position = jit, colour = "black", alpha = 1/50)
td + geom_jitter(position = jit, colour = "black", alpha = 1/200)


## 图5.10
## 第一行使用正方形显示分箱，第二行使用六边形显示。左栏使用默认分箱参数，中
## 栏使用参数bins = 10，右栏使用参数binwidth = c(0.02,
## 200)。为了节约空间，均略去 了图例。
d <- ggplot(diamonds, aes(carat, price)) + xlim(1, 3) + theme(legend.position = "none")
d + stat_bin2d()
d + stat_bin2d(bins = 10)
d + stat_bin2d(binwidth = c(0.02, 200))
d + stat_binhex()
d + stat_binhex(bins = 10)
d + stat_binhex(binwidth = c(0.02, 200))


## 图5.11
## 使用密度估计对点的密度建模并进行可视化。上图为基于点和等值线的密度展示，
## 下图为基于色深的密度展示。
d <- ggplot(diamonds, aes(carat, price)) + xlim(1, 3) + theme(legend.position = "none")
d + geom_point() + geom_density2d()
d + stat_density2d(geom = "point", aes(size = ..density..), contour = F) + 
    scale_size_area()
d + stat_density2d(geom = "tile", aes(fill = ..density..), contour = F)
last_plot() + scale_fill_gradient(limits = c(1e-05, 8e-04))


## 图5.12 函数 borders() 的使用实例。左图展示了美国 (2006 年 1 月)
## 五十万人口以上的城 市，右图为德克萨斯州的城市区划。
library(maps)
data(us.cities)
big_cities <- subset(us.cities, pop > 5e+05)
qplot(long, lat, data = big_cities) + borders("state", size = 0.5)
tx_cities <- subset(us.cities, country.etc == "TX")
ggplot(tx_cities, aes(long, lat)) + borders("county", "texas", colour = "grey70") + 
    geom_point(colour = "black", alpha = 0.5)


## 图5.13
## 左侧的等值域图展示了各州人身伤害案件的数量，右侧的等值域图展示了人身伤害
## 和谋杀类案件的比率。
library(maps)
states <- map_data("state")
arrests <- USArrests
names(arrests) <- tolower(names(arrests))
arrests$region <- tolower(rownames(USArrests))

choro <- merge(states, arrests, by = "region")
# 由于绘制多边形时涉及顺序问题 且merge破坏了原始排序 故将行重新排序
choro <- choro[order(choro$order), ]
qplot(long, lat, data = choro, group = group, fill = assault, geom = "polygon")
qplot(long, lat, data = choro, group = group, fill = assault/murder, geom = "polygon")


###### 章节5.7
library(plyr)  # ddply()在新版本中已被剥离并整合到plyr包中，这里先载入该包
ia <- map_data("county", "iowa")
mid_range <- function(x) mean(range(x, na.rm = TRUE))
centres <- ddply(ia, .(subregion), colwise(mid_range, .(lat, long)))
ggplot(ia, aes(long, lat)) + geom_polygon(aes(group = group), fill = NA, colour = "grey60") + 
    geom_text(aes(label = subregion), data = centres, size = 2, angle = 45)


## 图5.14 进行数据变换以移除显而易见的效应。左图对 x 轴和 y
## 轴的数据均取以 10 为底的
## 对数以剔除非线性性。右图剔除了主要的线性趋势。
d <- subset(diamonds, carat < 2.5 & rbinom(nrow(diamonds), 1, 0.2) == 1)
d$lcarat <- log10(d$carat)
d$lprice <- log10(d$price)

# 剔除整体的线性趋势
detrend <- lm(lprice ~ lcarat, data = d)
d$lprice2 <- resid(detrend)

mod <- lm(lprice2 ~ lcarat * color, data = d)

library(effects)
effectdf <- function(...) {
    suppressWarnings(as.data.frame(effect(...)))
}
color <- effectdf("color", mod)
both1 <- effectdf("lcarat:color", mod)

carat <- effectdf("lcarat", mod, default.levels = 50)
both2 <- effectdf("lcarat:color", mod, default.levels = 3)

qplot(lcarat, lprice, data = d, colour = color)
qplot(lcarat, lprice2, data = d, colour = color)


## 图5.15(书中无代码) 展示模型估计结果中变量 color 的不确定性。左图为
## color 的边际效应。右图则 是针对变量 caret 的不同水平 (level)，变量
## color 的条件效应。误差棒显示了 95% 的逐点 置信区间。
fplot <- ggplot(mapping = aes(y = fit, ymin = lower, ymax = upper)) + ylim(range(both2$lower, 
    both2$upper))
fplot %+% color + aes(x = color) + geom_point() + geom_errorbar()
fplot %+% both2 + aes(x = color, colour = lcarat, group = interaction(color, 
    lcarat)) + geom_errorbar() + geom_line(aes(group = lcarat)) + scale_colour_gradient()


## 图5.16(书中无代码) 展示模型估计结果中变量 carat 的不确定性。左图为
## caret 的边际效应。右图则是 针对变量 color 的不同水平，变量 caret
## 的条件效应。误差带显示了 95% 的逐点置信区间。
fplot %+% carat + aes(x = lcarat) + geom_smooth(stat = "identity")

ends <- subset(both1, lcarat == max(lcarat))
fplot %+% both1 + aes(x = lcarat, colour = color) + geom_smooth(stat = "identity") + 
    scale_colour_hue() + theme(legend.position = "none") + geom_text(aes(label = color, 
    x = lcarat + 0.02), ends)


## 图5.17 函数 stat_summary 的使用示例。首行从左至右分别展示了连续型变量
## x 的：中位 数曲线，median_hilow() 所得曲线和平滑带，均值曲线，以及
## mean_cl_boot() 所得曲线和 平滑带。次行从左至右分别展示了离散型变量 x
## 的：mean() 所得均值点，mean_cl_normal ()
## 所得均值点和误差棒，median_hilow()
## 所得中位数点和值域，以及median_hilow() 所 得中位数点和值域条。请注意
## ggplot2 展示了整个数据的取值范围，而不仅仅是各种描述性
## 统计量所涉及的范围。

## 以下两行为解决0.9.3版本中stat_summary的漏洞。之后的版本不需要下两行
library(devtools)
source_gist("https://gist.github.com/4578531")

m <- ggplot(movies, aes(year, rating))
m + stat_summary(fun.y = "median", geom = "line")
m + stat_summary(fun.data = "median_hilow", geom = "smooth")
m + stat_summary(fun.y = "mean", geom = "line")
m + stat_summary(fun.data = "mean_cl_boot", geom = "smooth")
m2 <- ggplot(movies, aes(factor(round(rating)), log10(votes)))
m2 + stat_summary(fun.y = "mean", geom = "point")
m2 + stat_summary(fun.data = "mean_cl_normal", geom = "errorbar")
m2 + stat_summary(fun.data = "median_hilow", geom = "pointrange")
m2 + stat_summary(fun.data = "median_hilow", geom = "crossbar")


###### 章节5.9.1
midm <- function(x) mean(x, trim = 0.5)
m2 + stat_summary(aes(colour = "trimmed"), fun.y = midm, geom = "point") + 
    stat_summary(aes(colour = "raw"), fun.y = mean, geom = "point") + scale_colour_hue("Mean")


###### 章节5.9.2
iqr <- function(x, ...) {
    qs <- quantile(as.numeric(x), c(0.25, 0.75), na.rm = T)
    names(qs) <- c("ymin", "ymax")
    qs
}
m + stat_summary(fun.data = "iqr", geom = "ribbon")


###### 章节5.10
(unemp <- qplot(date, unemploy, data = economics, geom = "line", xlab = "", 
    ylab = "No. unemployed (1000s)"))


###### 章节5.10
presidential <- presidential[-(1:3), ]

yrng <- range(economics$unemploy)
xrng <- range(economics$date)
unemp + geom_vline(aes(xintercept = as.numeric(start)), data = presidential)


###### 章节5.10
library(scales)
unemp + geom_rect(aes(NULL, NULL, xmin = start, xmax = end, fill = party), 
    ymin = yrng[1], ymax = yrng[2], data = presidential) + scale_fill_manual(values = alpha(c("blue", 
    "red"), 0.2))


###### 章节5.10
last_plot() + geom_text(aes(x = start, y = yrng[1], label = name), data = presidential, 
    size = 3, hjust = 0, vjust = 0)


###### 章节5.10
caption <- paste(strwrap("Unemployment rates in the US have\nvaried a lot over the years", 
    40), collapse = "\n")
unemp + geom_text(aes(x, y, label = caption), data = data.frame(x = xrng[2], 
    y = yrng[2]), hjust = 1, vjust = 1, size = 4)


###### 章节5.10
highest <- subset(economics, unemploy == max(unemploy))
unemp + geom_point(data = highest, size = 3, colour = alpha("red", 0.5))


## 图5.18 使用点的大小来展示权重：无权重 (左图)，以人口数量为权重
## (中图)，以面积为权 重 (右图)。
qplot(percwhite, percbelowpoverty, data = midwest)
qplot(percwhite, percbelowpoverty, data = midwest, size = poptotal/1e+06) + 
    scale_size_area("Population\n(millions)", breaks = c(0.5, 1, 2, 4))
qplot(percwhite, percbelowpoverty, data = midwest, size = area) + scale_size_area()

## 图5.19 未考虑权重的最优拟合曲线 (左图)
## 和以人口数量作为权重的最优拟合曲线 (右图)。
lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth
qplot(percwhite, percbelowpoverty, data = midwest, weight = popdensity, size = popdensity) + 
    lm_smooth


## 图5.20 不含权重信息 (左侧) 以及含权重信息 (右侧)
## 的直方图。不含权重信息的直方图展
## 示了郡的数量，而含权重信息的直方图展示了人口数量。权重的加入的确极大地改变了对图
## 形的解读！
qplot(percbelowpoverty, data = midwest, binwidth = 1)
qplot(percbelowpoverty, data = midwest, weight = poptotal, binwidth = 1) + 
    ylab("population") 
