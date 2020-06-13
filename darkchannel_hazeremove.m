% clear;
% close all;
% [f,p] = uigetfile('*.*','选择图像文件');
% if f
%     I=imread(strcat(p,f));
% end
% I=im2double(I);
function out = darkchannel_hazeremove(I,w0,minfilternum,ScienceMode)
[h,w,c]=size(I) ;
for i= 1 : h
    for j= 1 : w
        dark_channel(i,j)=min(I(i,j,:));
    end
end
%求到暗通道，并对它进行最小值滤波
dark_channel=ordfilt2(dark_channel,1,ones(minfilternum,minfilternum),'symmetric');
%求大气亮度值A
A = max(max(dark_channel));
[a,b]=find(dark_channel == A);
a=a(1);
b=b(1);
A=mean(I(a,b,:));
%求初始透射率
transmission=1 - w0 * dark_channel ./ A;
t0=0.1;
t=max(transmission,t0);
for l = 1:c
    dehaze(:,:,l)=(I(:,:,l)-A)./t + A;
end
% dehaze=uint8(dehaze*255);
    if ScienceMode==1
        figure;
        imshow(dark_channel);
        title('粗略暗通道');
        figure;
        imshow(dehaze);
        title('去雾后');
    end
    out=uint8(dehaze*255);
end




% function [dehaze] = dehaze_without_guide(I)
% w0 = 0.8 ;%去雾系数选0.95
% [h,w,c]=size(I) ;
% for i= 1 : h
%     for j= 1 : w
%         dark_channel(i,j)=min(I(i,j,:));
%     end
% end
% %求到暗通道，并对它进行最小值滤波
% dark_channel=ordfilt2(dark_channel,1,ones(3,3),'symmetric');
% %求大气亮度值A
% A = max(max(dark_channel));
% [a,b]=find(dark_channel == A);
% a=a(1);
% b=b(1);
% A=mean(I(a,b,:));
% %求初始透射率
% transmission=1 - w0 * dark_channel ./ A;
% t0=0.1;
% t=max(transmission,t0);
% for l = 1:c
%     dehaze(:,:,l)=(I(:,:,l)-A)./t + A;
% end
% figure;
% imshow([I,dehaze]);
% title('仅经过暗通道(无导向滤波）');
% end
% 
% % 
% % 
% % 
% % dehaze_without_guide(I);
% 
