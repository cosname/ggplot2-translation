library(ggplot2)
options(digits = 2)

## 图10.1 当不断放大图形时，交互地使用 last_plot()
## 可以快速有效地找到最佳视图。最后 一张图上添加了一条截距为 0 斜率为 1
## 的直线。图中可以看到数据中没有正方形的钻石。
qplot(x, y, data = diamonds, na.rm = TRUE)
last_plot() + xlim(3, 11) + ylim(3, 11)
last_plot() + xlim(4, 10) + ylim(4, 10)
last_plot() + xlim(4, 5) + ylim(4, 5)
last_plot() + xlim(4, 4.5) + ylim(4, 4.5)
last_plot() + geom_abline(colour = "red")

## 图10.1-最终图形
qplot(x, y, data = diamonds, na.rm = T) + geom_abline(colour = "red") + xlim(4, 
    4.5) + ylim(4, 4.5)

## 图10.2
## 将标度存储于某一变量中可供很多图形便捷地调用。对图层和分面也可进行类似的操作。
gradient_rb <- scale_colour_gradient(low = "red", high = "blue")
qplot(cty, hwy, data = mpg, colour = displ) + gradient_rb
qplot(bodywt, brainwt, data = msleep, colour = awake, log = "xy") + gradient_rb

## 图10.3 使用“静默”的 x 和 y 标度时，移除了标签并隐藏了刻度和网格线。
xquiet <- scale_x_continuous("", breaks = NA)
yquiet <- scale_y_continuous("", breaks = NA)
quiet <- list(xquiet, yquiet)

qplot(mpg, wt, data = mtcars) + quiet
qplot(displ, cty, data = mpg) + quiet

## 图10.4 创建一个自定义的几何形状函数，用类似 (但不相同)
## 的组件创建图形时即可调用。
geom_lm <- function(formula = y ~ x) {
    geom_smooth(formula = formula, se = FALSE, method = "lm")
}
qplot(mpg, wt, data = mtcars) + geom_lm()
library(splines)
qplot(mpg, wt, data = mtcars) + geom_lm(y ~ ns(x, 3))

library(plyr)
library(reshape2)
range01 <- function(x) {
    rng <- range(x, na.rm = TRUE)
    (x - rng[1])/diff(rng)
}
pcp_data <- function(df) {
    numeric <- laply(df, is.numeric)
    # 每一列的数值调整到相同的范围
    df[numeric] <- colwise(range01)(df[numeric])
    # 行名作为行识别信息
    df$.row <- rownames(df)
    # Melt 将非数值变量作为id.vars
    dfm <- melt(df, id = c(".row", names(df)[!numeric]))
    # 给数据框添加pcp类
    class(dfm) <- c("pcp", class(dfm))
    dfm
}
pcp <- function(df, ...) {
    df <- pcp_data(df)
    ggplot(df, aes(variable, value)) + geom_line(aes(group = .row))
}

pcp(mpg)
pcp(mpg) + aes(colour = drv) 