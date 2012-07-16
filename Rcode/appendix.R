library(grid) ## 需要 editGrob() 函数
p <- qplot(wt, mpg, data = mtcars, colour = cyl)
p
## 修改图形元件：图例字体改为斜体
grob <- ggplotGrob(p)
grob <- editGrob(grob, "title-2-2", gp = gpar(fontface = "italic"),
grep = TRUE, global = TRUE)
## 重新绘制
grid.newpage()
grid.draw(grob)