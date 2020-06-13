
%{ 
            
                                                  icbPMR.                                                                         
                                             :rfFDpbhPP@                                                                          
                                       .7tRR@Q@MR9DS0SZQ.                                                                         
                                   :7DR@RQDMpEXEXbSbSD0@                                                                          
                                7X@R@ZMPDXbSbSEXDPZbRM@R,    ,ri7rc7JcfY2cjri..                                                   
                            .jE@RQ9EPEhbSbXEPZEQR@RQhti:     ,.,...,.:,iiYJER@Q@R@X1i:                                            
                          YD@RRpDXbS0hEPD9RM@QRt7.      :                     .:XQ@Q@R@Zpr.                                       
                       :h@RR9ES0h0SEPDb@Q@Pj,         iP7p,                       ,MRRbRM@QQc.                                    
                     ,MQ@9ES0h0h0PZb@RRJ:           if9c.FpY.                       7QMXbPDE@Q9                                   
                   ,p@ZZX0hbSbXE9QRQL,            .11FjL SYFFY                       LMbS0SEXMR@:                                 
                  URQpES0h0S0XZM@S:             .79UUchi JfLttPi                      Q9bS0h0SDD@.                                
                 MRMPbSbh9hbPQRP               7hSYULt2i fjUcUYPfi                    MDS0hbh0hDRb                                
                RRDX0hbh9hE9@b,              :P22YUcfUE. 79UfYUY1F1.                 i@Xbh0S0h0XQD                                
               XQDS0h0hbS0p@Y              :U9jfY1jY:,     :iUJ1Y2t07.              .@9ES9hbSbSDR2                                
              .RMX0S9hbFbP@c              fhSjtri.. .,7JPLi.. .,r71jXh7            :@EEh0F0h0hEZ@                                 
              :@p0h0S0h0XRp             7E2Y::.:,77FthJ2Y1jht2rr,,.iiUF0:         2@EES0h0SbSED@.                                 
              ,QMX0S0h0hEM7           cXP7crJJPF92X2htSthUhtStPF9FSYYrYY01i     UR@pEh0S0S0XZR@.                                  
               XRZP0h0hbSQr         .JYcrY7ULJ7Y7crYrY7YrcrY7c7Y7Y7j7J77iri. ,t@RMPES9S0hEpRQb                                    
                hRQ9ESbhb9Q                                                7RRQ9ES0h0S0SDD@Mi                                     
                 :b@RR9EXEZQ.                                          :cMRQbDXbh0h0SEpRQQi                                       
                   .1M@Q@ERM@f,                                    ,UP@Q@EDPbSbh0SEpRR@pi                                         
                       71RQ@R@R@2r                           .,c1RR@RR9DXbS0S0XE9RR@Zj                                            
                           .r7pZ@R@R@EpYYir::,:,:,i.    :YS0@Q@RQEZPbX0SbSbSD0RR@Df.                                              
                                   ..ii7rLrLr7ir:i,.    F@RQ9DPEXbXbSbXDpMD@R@XL                                                  
                                                        2RDXbSbXEXDPMZ@R@Mb7:                                                     
                                                        Y@PEPDbRM@R@RZJr                                                          
                                                        SR@R@R@EP7i              

               @@@@         .            @@@@@@                                         @@@@@@            
          7@@@@@@@@@@t    ,@@@i      7Q@@@@@@@@@@D:      M@@@@Q           @@@@@h    0@@@@@@@@@@D:       
         @@@@7    :@@@@.  .@@@:    i@@@@L.    .1@@@@     9@@Q@@D         R@@Q@@U    h@@@     c@@@Z      
        @@@M        77:    @@@:   ,@@@Y          R@@@    X@@i:@@P       9@@ Y@@Y    2@@@      :@@@      
       i@@@                @@@:   @@@@            @@@J   S@@J P@@f     f@@c 0@@Y    f@@@      @@@@      
       Y@@@                @@@:   @@@Z            @@@X   S@@1  R@@Y   7@@p  Z@@Y    f@@@@@@@@@@@2       
       .@@@i               @@@:   P@@@           ,@@@,   S@@h   @@@: ,@@R   M@@Y    f@@@LtF1Y:          
        9@@@,       @@@:  .@@@:    @@@@         :@@@P    X@@S    @@@:@@@    R@@J    2@@@                
         J@@@@9jYh@@@@Z   .@@@i     S@@@@Z2JjhR@@@@r     Z@@D     @@@@@     @@@F    9@@@                
           i0@@@@@@Mr     .@@@,       :P@@@@@@@@U.       1@@2      @@@      0@@7    J@@@        




%}

close all;
clear;

%————模式开关————————————————————————————————
ScienceMode=0;           %调试模式开关
LightBalanceMode=1;      %光平衡开关，是否启用光照平衡
DarkChannelMode=0;       %暗通道去雾模式,没什么用,纯属扯淡，加上他我就是想试试而已


%————暗通道————————————————————————————————

w=0.5;
minfilternum=3;

%———光照均衡模块————————————————————————————————
MutiScaleMode=0;         %多尺度均衡模式,速度慢,没用的计算方式，不用打开了
light_sen=100;            %用于调整论文中的c，light_sen 光尺度敏感系数，越大对光强的提取越细节，卷积核按照图像大小分成多少块。小代表考虑全局光，实际上取值大以后，，运算速度也会变快                           
AdaptiveEntropyMode=1;   %熵自适应模式，对于特别垃圾的照片（特别特别黑或特别特别亮，会根据其熵自动调整平衡系数，有用，开着）                        
light_enhance=0.5;       %light_enhance，光照平衡强度系数，越大反而代表平衡强度越弱，一般在0.4-0.6，你嫌他太强就自己改大点

%建议小一点敏感尺度配合大的修正光照平衡强度



%———色阶调整模块————————————————————————————————
ChannelBalanceMode=1;   %通道均衡模式
off_sen=1;              %对于特别亮或者特别暗的图片，会存在偏移系数，偏移敏感系数，这个值越大，要求偏移更小，这个值越小，越能感应小的便宜，
                        %0-1左右吧，太大了会使得上下届都是0
                        
off_size=2;          %如果存在偏移，那么移动窗口的程度是多少（0-2之间，太大了会移除）
loss=2;                 %需要几倍的西格玛，这个数越大保留的数据就越多，越小增强效果越强烈
channel_sen=5;        %通道不平衡敏感系数，越大就对偏移越敏感,0-10都没有问题，0代表不敏感，代表了越保持主通道

%———主程序————————————————————————————————————
[f,p] = uigetfile('*.*','选择图像文件');
if f
    I=imread(strcat(p,f));
end

input = I;
tic;   %计时器开始

I = adaptiveadj (I,off_sen,off_size,loss,channel_sen,ScienceMode,ChannelBalanceMode);
afterAdAdj=I;
if ScienceMode==1
    figure;
    imshow(afterAdAdj);
end

if LightBalanceMode==1 
    I=lightbalance(I,light_sen,light_enhance,ScienceMode,MutiScaleMode,AdaptiveEntropyMode);
    afterLigBal=I;
    mytimer1=toc;%计时器
    disp(mytimer1);
    figure;
    imshow([input, afterLigBal]);
else
    mytimer1=toc;%计时器
    disp(mytimer1);
end

if DarkChannelMode==1;
    I=im2double(I);
    afterdehaze=darkchannel_hazeremove(I,w,minfilternum,ScienceMode);
    figure;
    imshow(afterdehaze);
    title('去雾后')
end




%————初始参数备份——————————————————————————————————————————————
%{
%———光照均衡模块———————————————
MutiScaleMode=0;         %多尺度均衡模式,速度慢,没用的计算方式，不用打开了
light_sen=20;            %light_sen 光尺度敏感系数，越大对光强的提取越细节，小代表考虑全局光，                           %可以理解为将图片裁成多少份去提取光照，建议取8-12
AdaptiveEntropyMode=1;   %熵自适应模式，对于特别垃圾的照片（特别特别黑或特别特别亮，会根据其熵自动调整平衡系数，有用，开着）                        
light_enhance=0.45;       %light_enhance，光照平衡强度系数，越大反而代表平衡强度越弱，一般在0.4-0.45，你嫌他太强就自己改大点

%建议小一点敏感尺度配合大的修正光照平衡强度

%———色阶调整模块———————————————
ChannelBalanceMode=1;   %通道均衡模式
off_sen=1;              %对于特别亮或者特别暗的图片，会存在偏移系数，偏移敏感系数，这个值越大，要求偏移更小，这个值越小，越能感应小的便宜
off_size=0.75;          %如果存在偏移，那么移动窗口的程度是多少
loss=2;                 %需要几倍的西格玛，这个数越大保留的数据就越多，越小增强效果越强烈
channel_sen=1.5;        %通道不平衡敏感系数，越大就对偏移越敏感,1代表正常值，0代表不敏感，代表了越保持主通道

%}
%———没了—————



%(゜-゜)つロ 干杯~-bilibili————————————————————————————————
% CIOMP 图像部 









