function get_hist(I)
Ir=I(:,:,1);%提取红色分量
Ig=I(:,:,2);%提取绿色分量
Ib=I(:,:,3);%提取蓝色分量
figure;
subplot(1,3,1);
imhist(Ir);
title('I). 红色分量直方图');
subplot(1,3,2);
imhist(Ig);
title('I). 绿色分量直方图');
subplot(1,3,3);
imhist(Ib);
title('I). 蓝色分量直方图');
end

