function Out = adaptiveadj (I,off_sen,off_size,loss,channel_sen,ScienceMode,ChannelBalanceMode)
% close;close;close;
    if ScienceMode==1
        get_hist(I);
    end
% off_sen=1;  %偏移敏感系数，这个值越大，要求偏移更小，这个值越小，越能感应小的便宜
% off_size=0.75;%如果存在偏移，那么移动窗口的程度是多少
% loss=2;%  需要几倍的西格玛，这个数越大保留的数据就越多，越小效果越强烈
% channel_sen=0.5;通道不平衡敏感系数，越大就对偏移越敏感,1代表正常值，0代表不敏感，代表了越突出主通道
[std_off,mean_off,weight_by_ent,ent]=pointcounter(I,channel_sen);
if ChannelBalanceMode==0
    std_off=std_off.*0;
    mean_off=mean_off.*0;
end

%第二个值是通道不平衡敏感系数，越大就对偏移越敏感,1代表正常值，0代表不敏感，代表了越突出主通道

% weight_r=mr/m_sum+(1-std_r/std_sum);
% weight_g=mg/m_sum+(1-std_g/std_sum);
% weight_b=mb/m_sum+(1-std_b/std_sum);
% weight=[weight_r,weight_g,weight_b];
% weight=weight/sum(weight);
% m_weight=(weight_r*mr+weight_b*mb+weight_g*mb)/3;
% std_weight=(weight_r*std_r+weight_g*std_g+weight_b*std_b)/3;
    for i = 1:3
        m=mean(mean(I(:,:,i)));
        std=std2(I(:,:,i));

        off_right=m+off_sen*std-255;%右侧超出量，说明数据严重集中在右侧，此时右偏移，突出右侧
        off_left=off_sen*std-m;%左侧超出量，说明数据严重集中在左侧，此时左偏移，突出左侧
        if off_right<0    %<0说明不偏移
            off_right=0;
        end
        if off_left<0;  %＜0说明不偏移
           off_left=0;
        end
        if off_left>=off_right
            off=-off_size*off_left;
        else
            off=off_size*off_right;
        end
        LOW=min(max((m+mean_off(i)-(loss)*std-std_off(i)+off)/255,0),1);%防止溢出,几倍方差范围内取值
    %     LOW=min(max((m+mean_off(i)-(loss+std_off(i))*std+off)/255,0),1);%防止溢出,几倍方差范围内取值
        LOW1=LOW*255;
        HIGH=max(min((m+mean_off(i)+(loss)*std+std_off(i)+off)/255,1),0);
    %     HIGH=max(min((m+mean_off(i)+(loss+std_off(i))*std+off)/255,1),0);
        HIGH1=HIGH*255;
        Out(:,:,i) = imadjust(I(:,:,i),[LOW HIGH],[]); 
    end
    if ScienceMode==1
        get_hist(Out);
    end
end
% get_hist(Out);
% m_out=mean(mean(mean(Out)));