# ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT
没啥学术价值，但是看着好像还行
博客：https://blog.csdn.net/weixin_43446161/article/details/106736586
## 运行

编写环境：Matlab2015b

运行run_me.m文件即可，打开你想处理的图片
## 一个BUG
写程序的时候忘了考虑单通道的图像了，所以手动把单通道图像扩充一下吧
## 程序结构
run_me.m 启动文件，并且修改参数 ，运行他，打开你想处理的图片  
adaptiveadj.m 自适应调整模块，整个恢复的主力  
darkchannel_hazeremove.m 暗通道去雾程序，没什么用，run_me里有个开关可以打开或关闭它。没什么用  
get_hist.m 获取直方图  
i dont't konw.m 忘了。跟run_me差不多，删了也没什么关系  
lightbalance.m 光照平衡模块  
pointcounter.m 通道分数计算器，用于计算熵？好像是  

## 参数
在run_me.m中调整各项参数去做处理  

## 看看效果

![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/fish.png)

![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/1.PNG)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/123123.png)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E5%85%89%E5%B9%B3%E8%A1%A1.png)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20200520112057.png)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20200320183026.png)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E6%8D%95%E8%8E%B75.PNG)



![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E6%8D%95%E8%8E%B77.PNG)
![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/%E6%8D%95%E8%8E%B76.PNG)

![image](https://github.com/liuchangji/ADAPTIVE-IMAGE-COLOR-LEVEL-ADJUSTMENT/blob/master/results/水下.png)



