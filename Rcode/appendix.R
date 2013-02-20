library(ggplot2)
library(gtable)
library(grid)  ## 需要 editGrob() 函数
p <- qplot(wt, mpg, data = mtcars, colour = cyl, main = "Title text")
p
## 修改图形元件：图形题目字体改为斜体红色
g <- ggplotGrob(p)
idx <- which(g$layout$name == "title")
g$grobs[[idx]] <- editGrob(g$grobs[[idx]], gp = gpar(fontface = "italic", col = "red"))
## 重新绘制
grid.draw(g) 
