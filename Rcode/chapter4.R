library(ggplot2)
## 通过ggplot创建图形对象
p <- ggplot(diamonds, aes(carat, price, colour = cut))

## 添加“点”几何对象
p <- p + layer(geom = "point")


## 例：手动创建图形对象并添加图层
p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(geom = "bar", geom_params = list(fill = "steelblue"), stat = "bin", 
    stat_params = list(binwidth = 2))
p

## 应用“快捷函数”，得到与上例相同的图形
p + geom_histogram(binwidth = 2, fill = "steelblue")


## 在用ggplot创建的图形对象上添加图层
ggplot(msleep, aes(sleep_rem/sleep_total, awake)) + geom_point()
# 等价于
qplot(sleep_rem/sleep_total, awake, data = msleep)

# 也可以给qplot添加图层
qplot(sleep_rem/sleep_total, awake, data = msleep) + geom_smooth()
# 等价于
qplot(sleep_rem/sleep_total, awake, data = msleep, geom = c("point", "smooth"))
# 或
ggplot(msleep, aes(sleep_rem/sleep_total, awake)) + geom_point() + geom_smooth()

## 例：summary给出图形对象的默认设置和每个图层的信息
p <- ggplot(msleep, aes(sleep_rem/sleep_total, awake))
summary(p)
p <- p + geom_point()
summary(p)

## 例：用不同的数据初始化后添加相同的图层
library(scales)
bestfit <- geom_smooth(method = "lm", se = F, colour = alpha("steelblue", 0.5), 
    size = 2)
qplot(sleep_rem, sleep_total, data = msleep) + bestfit
qplot(awake, brainwt, data = msleep, log = "y") + bestfit
qplot(bodywt, brainwt, data = msleep, log = "xy") + bestfit

## 用%*%添加新的数据集来代替原来的数据集
p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p
mtcars <- transform(mtcars, mpg = mpg^2)
p %+% mtcars

## aes函数的参数
aes(x = weight, y = height, colour = age)
# 也可以使用变量的函数值作为参数
aes(weight, height, colour = sqrt(age))

p <- ggplot(mtcars)
summary(p)

p <- p + aes(wt, hp)
summary(p)

## 使用默认的参数映射来添加图层
p <- ggplot(mtcars, aes(x = mpg, y = wt))
p + geom_point()

## 图4.1 修改图形属性。用factor(cyl)修改颜色(左)，用disp修改y坐标(右)。
p + geom_point(aes(colour = factor(cyl)))
p + geom_point(aes(y = disp))

p <- ggplot(mtcars, aes(mpg, wt))
p + geom_point(colour = "darkblue")
# 注意这里将颜色映射到'darkblue'与上面将颜色设定给'darkblue'的区别
p + geom_point(aes(colour = "darkblue"))

# The difference between (left) setting colour to \code{'darkblue'} and
# (right) mapping colour to \code{'darkblue'}.  When \code{'darkblue'}
# is mapped to colour, it is treated as a regular value and scaled with
# the default colour scale.  This results in pinkish points and a legend.

## 图4.2
## 将颜色设定为'darkblue'(左)与将颜色映射到'darkblue'(右)的区别。当颜色映
## 射到'darkblue'时，'darkblue'将被看作一个普通的字符串，使用默认的颜色标
## 度进行标度转换，结果得到了粉红色的点和图例。
qplot(mpg, wt, data = mtcars, colour = I("darkblue"))
qplot(mpg, wt, data = mtcars, colour = "darkblue")

## 图4.3 正确分组时(分组变量group =
## Subject)每个个体的折线图(左)。错误的分组时连
## 接所有观测点的折线图(右)。此处省略了分组图形属性，效果等同于group =
## 1。
data(Oxboys, package = "nlme")
# 左图的代码
p <- ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line()
# 或
qplot(age, height, data = Oxboys, group = Subject, geom = "line")
# 右图的代码
qplot(age, height, data = Oxboys, geom = "line")

## 图4.4
## 给Oxboys数据添加光滑曲线。左图用了和折线图同样的分组变量，得到了每个男
## 孩的拟合直线。右图在平滑层里用了aes(group = 1)，得到了所有男孩的拟合直
## 线。 左图
p + geom_smooth(aes(group = Subject), method = "lm", se = F)
# 或
qplot(age, height, data = Oxboys, group = Subject, geom = "line") + geom_smooth(method = "lm", 
    se = F)
# 右图
p + geom_smooth(aes(group = 1), method = "lm", size = 2, se = F)
# 或
qplot(age, height, data = Oxboys, group = Subject, geom = "line") + geom_smooth(aes(group = 1), 
    method = "lm", size = 2, se = F)


## 图4.5
## 如果想用箱线图来查看每个时期的身高分布，默认的分组是正确的(左图)。如果
## 想用\texttt{geom_line()}添加每个男孩的轨迹，就需要在新图层里设定
## aes(group = Subject)(右图)。 左图
qplot(Occasion, height, data = Oxboys, geom = "boxplot")
# 右图
qplot(Occasion, height, data = Oxboys, geom = "boxplot") + geom_line(aes(group = Subject), 
    colour = "#3366FF")
# 或
boysbox <- ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot()
boysbox + geom_line(aes(group = Subject), colour = "#3366FF")

## 图4.6
## 对于线条和路径，线段的图形属性是由起始点的图形属性决定的。如果颜色是离
## 散的(左图)，在相邻的颜色间插入其他颜色是没有任何意义的。如果颜色是连续
## 的(右图)，可以在相邻的颜色间进行插补，但默认条件下R不会这样做。
df <- data.frame(x = 1:3, y = 1:3, colour = c(1, 3, 5))
qplot(x, y, data = df, colour = factor(colour), size = I(5)) + geom_line(aes(group = 1), 
    size = 2)
qplot(x, y, data = df, colour = colour, size = I(5)) + geom_line(size = 2)

## 用线性插值法做颜色渐变线条
xgrid <- with(df, seq(min(x), max(x), length = 50))
interp <- data.frame(x = xgrid, y = approx(df$x, df$y, xout = xgrid)$y, colour = approx(df$x, 
    df$colour, xout = xgrid)$y)
qplot(x, y, data = df, colour = colour, size = I(5)) + geom_line(data = interp, 
    size = 2)

## 图4.7 一个条形图(左)按组分解后得到的叠加条形图(右)，两者轮廓相同。
qplot(color, data = diamonds)
qplot(color, data = diamonds, fill = cut)

## 例：生成变量
ggplot(diamonds, aes(carat)) + geom_histogram(aes(y = ..density..), binwidth = 0.1)
# 或
qplot(carat, ..density.., data = diamonds, geom = "histogram", binwidth = 0.1)

## 图4.8 应用于条形图的三种位置调整。从左到右依次是:堆叠(stacking)，填充
## (filling)和并列(dodging)
dplot <- ggplot(diamonds, aes(clarity, fill = cut))
dplot + geom_bar(position = "stack")
dplot + geom_bar(position = "fill")
dplot + geom_bar(position = "dodge")

## 图4.9 同一调整(identity
## adjustment)不适用于条形图(左)，因为后画的条形会挡住先
## 画的条形。但它适用于线型图(右)，因为线条不存在相互遮掩的问题。
dplot + geom_bar(position = "identity")
qplot(clarity, data = diamonds, geom = "line", colour = cut, stat = "bin", 
    group = cut)

## 图4.10 直方图的三种变体。频率多边形(frequency
## polygon)(左)；散点图，点的大小和
## 高度都映射给了频率(中)；热图(heatmap)用颜色来表示频率。
d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = "area")
d + stat_bin(aes(size = ..density..), binwidth = 0.1, geom = "point", position = "identity")
d + stat_bin(aes(y = 1, fill = ..count..), binwidth = 0.1, geom = "tile", position = "identity")

## 例：nlme包的Oxboys数据集
require(nlme, quiet = TRUE, warn.conflicts = FALSE)
model <- lme(height ~ age, data = Oxboys, random = ~1 + age | Subject)
oplot <- ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line()

age_grid <- seq(-1, 1, length = 10)
subjects <- unique(Oxboys$Subject)

preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, preds)

oplot + geom_line(data = preds, colour = "#3366FF", size = 0.4)

Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)

oplot %+% Oxboys + aes(y = resid) + geom_smooth(aes(group = 1))

model2 <- update(model, height ~ age + I(age^2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)

oplot %+% Oxboys + aes(y = resid2) + geom_smooth(aes(group = 1)) 
