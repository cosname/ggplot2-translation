library(effects)
library(ggplot2)

###### 章节6.3
plot <- qplot(cty, hwy, data = mpg)
plot

# 这样做行不通是因为变量类型和默认标度不匹配
plot + aes(x = drv)

# 更正默认标度后解决了问题.
plot + aes(x = drv) + scale_x_discrete()


## 图6.1 调整标度默认参数的示例。(左上图) 使用默认标度的图形。(右上图)
## 手动添加默认 标度，并未改变图形外观。(左下图)
## 调整标度的参数以实现对图例的微调。(右下图) 使用一
## 种不同的颜色标度：ColorBrewer 配色方案中的 Set1。
p <- qplot(sleep_total, sleep_cycle, data = msleep, colour = vore)
p
# 显式添加默认标度
p + scale_colour_hue()

# 修改默认标度的参数, 这里改变了图例的外观
p + scale_colour_hue("What does\nit eat?", breaks = c("herbi", "carni", "omni", 
    NA), labels = c("plants", "meat", "both", "don’t know"))

# 使用一种不同的标度
p + scale_colour_brewer(palette = "Set1")


## 图6.2 图例名称可以接受不同形式的参数。
p <- qplot(cty, hwy, data = mpg, colour = displ)
p
p + scale_x_continuous("City mpg")
p + xlab("City mpg")
p + ylab("Highway mpg")
p + labs(x = "City mpg", y = "Highway", colour = "Displacement")
p + xlab(expression(frac(miles, gallon)))




## 图6.3
## breaks和limits的区别。对x轴的影响(首行)以及彩色图例(次行)。(左栏)默认参
## 数limits = c(4, 8), breaks = 4:8 的图形，(中栏)breaks =
## c(5.5,6.5)，(右栏)limits = c(5.5,6.5)。
p <- qplot(cyl, wt, data = mtcars)
p
p + scale_x_continuous(breaks = c(5.5, 6.5))
p + scale_x_continuous(limits = c(5.5, 6.5))
p <- qplot(wt, cyl, data = mtcars, colour = cyl)
p
p + scale_colour_gradient(breaks = c(5.5, 6.5))
p + scale_colour_gradient(limits = c(5.5, 6.5))


## 图6.4 钻石价格和重量的散点图。演示了对标度进行对数变换(左图)和
## 对数据进行对数变换(右图)的异同。图形主体是完全相同的，但坐标轴上的标签是不同的。
qplot(log10(carat), log10(price), data = diamonds)
qplot(carat, price, data = diamonds) + scale_x_log10() + scale_y_log10()


## 图6.5 个人储蓄率的时间序列图形。(左图) 默认外观，(中图) 每隔 10
## 年为一断点，以及 (右图) 使用年月日的格式仅显示在 2004
## 年内的图形。测量值是在每月月末记录的。
library(scales)
plot <- qplot(date, psavert, data = economics, geom = "line") + ylab("Personal savings rate") + 
    geom_hline(xintercept = 0, colour = "grey50")
plot
plot + scale_x_date(breaks = date_breaks("10 years"))
plot + scale_x_date(limits = as.Date(c("2004-01-01", "2005-01-01")), labels = date_format("%Y-%m-%d"))


## 图6.6 无代码


## 图6.7 温泉喷发时间数据密度估计的三种配色方案。(左图)
## 默认的颜色梯度，(中图) 自定 义的黑白梯度以及 (右图) 中点设为密度均值的
## 3 点梯度。
f2d <- with(faithful, MASS::kde2d(eruptions, waiting, h = c(1, 10), n = 50))
df <- with(f2d, cbind(expand.grid(x, y), as.vector(z)))
names(df) <- c("eruptions", "waiting", "density")
erupt <- ggplot(df, aes(waiting, eruptions, fill = density)) + geom_tile() + 
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 
    0))
erupt + scale_fill_gradient(limits = c(0, 0.04))
erupt + scale_fill_gradient(limits = c(0, 0.04), low = "white", high = "black")
erupt + scale_fill_gradient2(limits = c(-0.04, 0.04), midpoint = mean(df$density))

## 图6.8 使用 vcd
## 包生成的可被良好感知的调色板创建的梯度型颜色标度。从左至右分别为：
## 顺序型、发散型，以及 hcl 热度型调色板。每种标度使用
## scale_fill_gradientn 生成，参 数 colours 分别设置为
## rainbow_hcl(7)、diverge_hcl(7) 和 heat_hcl(7)。
library(vcd)
fill_gradn <- function(pal) {
    scale_fill_gradientn(colours = pal(7), limits = c(0, 0.04))
}
erupt + fill_gradn(rainbow_hcl)
erupt + fill_gradn(diverge_hcl)
erupt + fill_gradn(heat_hcl)


p1 = erupt + fill_gradn(rainbow_hcl)
p2 = erupt + fill_gradn(diverge_hcl)
p3 = erupt + fill_gradn(heat_hcl)

pdf("fig6-8new.pdf", width = 11, height = 3)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 3)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(p1, vp = vplayout(1, 1))
print(p2, vp = vplayout(1, 2))
print(p3, vp = vplayout(1, 3))
dev.off()

## 图6.9 三种 ColorBrewer 调色板，Set1(左图)，Set2(中图) 和
## Pastel1(右图)，分别应用于 点 (首行) 和条形
## (次行)。更明亮的颜色对点效果良好，但对于条形来说过于刺眼。淡色对条
## 形效果良好，但会让点看不清楚。
point <- qplot(brainwt, bodywt, data = msleep, log = "xy", colour = vore)
area <- qplot(log10(brainwt), data = msleep, fill = vore, binwidth = 1)

point + scale_colour_brewer(palette = "Set1")
point + scale_colour_brewer(palette = "Set2")
point + scale_colour_brewer(palette = "Pastel1")
area + scale_fill_brewer(palette = "Set1")
area + scale_fill_brewer(palette = "Set2")
area + scale_fill_brewer(palette = "Pastel1")

## 图6.10 使用手动型标度创建 (左图和中图) 自定义颜色标度和 (右图)
## 形状标度。
plot <- qplot(brainwt, bodywt, data = msleep, log = "xy")
plot + aes(colour = vore) + scale_colour_manual(values = c("red", "orange", 
    "yellow", "green", "blue"))
colours <- c(carni = "red", `NA` = "orange", insecti = "yellow", herbi = "green", 
    omni = "blue")
plot + aes(colour = vore) + scale_colour_manual(values = colours)
plot + aes(shape = vore) + scale_shape_manual(values = c(1, 2, 6, 0, 23))


###### 章节6.4.4
huron <- data.frame(year = 1875:1972, level = LakeHuron)
ggplot(huron, aes(year)) + geom_line(aes(y = level - 5), colour = "blue") + 
    geom_line(aes(y = level + 5), colour = "red")


###### 章节6.4.4
ggplot(huron, aes(year)) + geom_line(aes(y = level - 5, colour = "below")) + 
    geom_line(aes(y = level + 5, colour = "above"))


###### 章节6.4.4
ggplot(huron, aes(year)) + geom_line(aes(y = level - 5, colour = "below")) + 
    geom_line(aes(y = level + 5, colour = "above")) + scale_colour_manual("Direction", 
    values = c(below = "blue", above = "red"))


## 图6.11 无代码


## 图6.12 无代码


## 图6.13 无代码


## 图6.14 无代码
