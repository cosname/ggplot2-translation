## 图8.1 （书中无代码）
# 主题改变的效果。(左) 默认的灰色主题：灰色背景，白色网格线。(右) 黑白主题：
# 白色背景，灰色网格线。两幅图中条状图和数据部分是相同的。
qplot(rating, data = movies, binwidth = 1)
last_plot() + theme_bw()


######章节8.1.1
hgram <- qplot(rating, data = movies, binwidth = 1)
# 主题在被创建时对图形无影响
# 在被绘制时才会影响图形
hgram


######章节8.1.1
previous_theme <- theme_set(theme_bw())
hgram


######章节8.1.1
# 你可以通过向图形添加主题来覆盖单个图形中的初始主题。
# 此处我们使用的初始主题。
hgram + previous_theme


######章节8.1.1
# 永久性储存初始主题
theme_set(previous_theme)


## 图8.2
# 改变图形标题的外观
hgramt <- hgram +opts(title = "This is a histogram")
hgramt
hgramt + opts(plot.title = theme_text(size = 20))
hgramt + opts(plot.title = theme_text(size = 20,
  colour = "red"))
hgramt + opts(plot.title = theme_text(size = 20,
  hjust = 0))
hgramt + opts(plot.title = theme_text(size = 20,
  face = "bold"))
hgramt + opts(plot.title = theme_text(size = 20,
  angle = 180))



## 图8.3
# 改变图形中线条和分割线的外观
hgram + opts(panel.grid.major = theme_line(colour = "red"))
hgram + opts(panel.grid.major = theme_line(size = 2))
hgram + opts(panel.grid.major = theme_line(linetype = "dotted"))
hgram + opts(axis.line = theme_segment())
hgram + opts(axis.line = theme_segment(colour = "red"))
hgram + opts(axis.line = theme_segment(size = 0.5,
  linetype = "dashed"))
  
  
## 图8.4
# 改变图形和面板背景的外观
hgram + opts(plot.background = theme_rect(fill = "grey80",
  colour = NA))
hgram + opts(plot.background = theme_rect(size = 2))
hgram + opts(plot.background = theme_rect(colour = "red"))
hgram + opts(panel.background = theme_rect())
hgram + opts(panel.background = theme_rect(colour = NA))
hgram + opts(panel.background =
  theme_rect(linetype = "dotted"))
  
  
## 图8.5
# 使用theme_blank() 逐步从图中删除非数据元素
hgramt
last_plot() + opts(panel.grid.minor = theme_blank())
last_plot() + opts(panel.grid.major = theme_blank())
last_plot() + opts(panel.background = theme_blank())
last_plot() +
  opts(axis.title.x = theme_blank(),
       axis.title.y = theme_blank())
last_plot() + opts(axis.line = theme_segment())

  
## 图8.6 
# 新主题中的条状图和散点图
old_theme <- theme_update(
  plot.background = theme_rect(fill = "#3366FF"),
  panel.background = theme_rect(fill = "#003DF5"),
  axis.text.x = theme_text(colour = "#CCFF33"),
  axis.text.y = theme_text(colour = "#CCFF33", hjust = 1),
  axis.title.x = theme_text(colour = "#CCFF33", face = "bold"),
  axis.title.y = theme_text(colour = "#CCFF33", face = "bold",
   angle = 90)
)
qplot(cut, data = diamonds, geom="bar")
qplot(cty, hwy, data = mpg)
theme_set(old_theme)


######章节8.2.1
set_default_scale("colour", "discrete", "grey")
set_default_scale("fill", "discrete", "grey")
set_default_scale("colour", "continuous", "gradient",
  low = "white", high = "black")
set_default_scale("fill", "continuous", "gradient",
  low = "white", high = "black")
  
  
######章节8.2.2  
update_geom_defaults("point", aes(colour = "darkblue"))
qplot(mpg, wt, data=mtcars)
update_stat_defaults("bin", aes(y = ..density..))
qplot(rating, data = movies, geom = "histogram", binwidth = 1)


## 图8.7 无代码


######章节8.3
qplot(mpg, wt, data = mtcars)
ggsave(file = "output.pdf")
pdf(file = "output.pdf", width = 6, height = 6)
# 在脚本中，你需要明确使用 print() 来打印图形
qplot(mpg, wt, data = mtcars)
qplot(wt, mpg, data = mtcars)
dev.off()




## 图8.8
# 测试图形布局的三幅图形
(a <- qplot(date, unemploy, data = economics, geom = "line"))
(b <- qplot(uempmed, unemploy, data = economics) +
  geom_smooth(se = F))
(c <- qplot(uempmed, unemploy, data = economics, geom="path"))



######章节8.4.1
# 一个占据整个图形设备的视图窗口
library(grid)
vp1 <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
vp1 <- viewport()
# 只占了图形设备一半的宽和高的视图窗口，
# 定位在图形的中间位置
# located in the middle of the plot.
vp2 <- viewport(width = 0.5, height = 0.5, x = 0.5, y = 0.5)
vp2 <- viewport(width = 0.5, height = 0.5)
# 一个2cm x 3cm 的视图窗口，定位在图形设备中心
vp3 <- viewport(width = unit(2, "cm"), height = unit(3, "cm"))


######章节8.4.1
# 在右上角的视图窗口
vp4 <- viewport(x = 1, y = 1, just = c("right", "top"))
# 处在左下角
vp5 <- viewport(x = 0, y = 0, just = c("right", "bottom"))


######章节8.4.1
pdf("polishing-subplot-1.pdf", width = 4, height = 4)
subvp <- viewport(width = 0.4, height = 0.4, x = 0.75, y = 0.35)
b
print(c, vp = subvp)
dev.off()


## 图8.9
# 两个包含子图的图形实例。为得到最优的图形展示，你通常需要微调主题设置。
csmall <- c + theme_gray(9) + labs(x = NULL, y = NULL) +
	opts(plot.margin = unit(rep(0, 4), "lines"))
pdf("polishing-subplot-2.pdf", width = 4, height = 4)
b
print(csmall, vp = subvp)
dev.off()


## 图8.10
# grid.layout() 将三幅图形分置在一页上
pdf("polishing-layout.pdf", width = 8, height = 6)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
vplayout <- function(x, y)
viewport(layout.pos.row = x, layout.pos.col = y)
print(a, vp = vplayout(1, 1:2))
print(b, vp = vplayout(2, 1))
print(c, vp = vplayout(2, 2))
dev.off()
