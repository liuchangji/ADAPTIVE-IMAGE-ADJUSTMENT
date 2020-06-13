%光照均衡模块，参考的https://blog.csdn.net/baolinq/article/details/78756322

function out = lightbalance(im,light_sen,light_enhance,ScienceMode,MutiScaleMode,AdaptiveEntropyMode)
    [std_off,mean_off,weight_by_ent,ent]=pointcounter(im,1);
   
    if AdaptiveEntropyMode==1   %对于特别特别暗的图像，完全没有必要去均衡，否则会出现暗斑，所以以此削弱其平衡能力
        ent_loss=(1-sum(ent)/3/8)/2.5;
        light_enhance=max(min(light_enhance+ent_loss,1),0.5);
    end
    [h,s,v]=rgb2hsv(im);    %转到hsv空间，对亮度h处理
    % 高斯滤波
    if MutiScaleMode==0
        HSIZE= 5;
        SIGMA1=2;
%         HSIZE= round((size(im,1)+size(im,2))/2/light_sen);%高斯卷积核尺寸
%         SIGMA1=round(HSIZE/4) ;%论文里面的c
        F1 = fspecial('gaussian',HSIZE,SIGMA1);
        gaus= imfilter(v, F1, 'replicate');
    else
        HSIZE= min(size(im,1),size(im,2));%高斯卷积核尺寸
     
        SIGMA1=HSIZE/4/light_sen;%论文里面的c
        SIGMA2=HSIZE/light_sen;
        SIGMA3=HSIZE*3/light_sen;
        F1 = fspecial('gaussian',HSIZE,SIGMA1);
        F2 = fspecial('gaussian',HSIZE,SIGMA2) ;
        F3 = fspecial('gaussian',HSIZE,SIGMA3) ;
        gaus1= imfilter(v, F1, 'replicate');
        gaus2= imfilter(v, F2, 'replicate');
        gaus3= imfilter(v, F3, 'replicate'); 
        gaus=(gaus1+gaus2+gaus3)/3;    %多尺度高斯卷积，加权，权重为1/3
    end
    if ScienceMode==1
        figure;
        imshow(gaus,[]);
        title('光照分量');
    end
    %二维伽马卷积
    m=mean(gaus(:));
    % [w,height]=size(v);
    % out=zeros(size(v));
    gama=power(light_enhance,((m-gaus)/m));%根据公式gamma校正处理，论文公式有误
    out=(power(v,gama));
    % figure;
    % imshow(out,[]);
    out=uint8(hsv2rgb(h,s,out)*255);   %转回rgb空间显示
    if ScienceMode==1
        figure;
        imshow(out);
        title('光平衡处理结果');
    end
% toc;
end


%{
clc,close all;
tic;
im=imread('1128-2.jpg');
figure;
imshow(im);
title('原图');
[h,s,v]=rgb2hsv(im);    %转到hsv空间，对亮度h处理
% 高斯滤波
HSIZE= min(size(im,1),size(im,2));%高斯卷积核尺寸
q=sqrt(2);
SIGMA1=15;%论文里面的c
SIGMA2=80;
SIGMA3=250;
F1 = fspecial('gaussian',HSIZE,SIGMA1/q);
F2 = fspecial('gaussian',HSIZE,SIGMA2/q) ;
F3 = fspecial('gaussian',HSIZE,SIGMA3/q) ;
gaus1= imfilter(v, F1, 'replicate');
gaus2= imfilter(v, F2, 'replicate');
gaus3= imfilter(v, F3, 'replicate');
gaus=(gaus1+gaus2+gaus3)/3;    %多尺度高斯卷积，加权，权重为1/3
% gaus=(gaus*255);
figure;
imshow(gaus,[]);
title('光照分量');
%二维伽马卷积
m=mean(gaus(:));
[w,height]=size(v);
out=zeros(size(v));
gama=power(0.5,((m-gaus)/m));%根据公式gamma校正处理，论文公式有误
out=(power(v,gama));
figure;
imshow(out,[]);
rgb=hsv2rgb(h,s,out);   %转回rgb空间显示
figure;
imshow(rgb);
title('处理结果')
toc;
%}







%{

             
           
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
        cZ@@@@RU.           00bb.          .jR@@@@E7                                                
     i@@@@@RR@@@@@f        @@@@@@         @@@@bhp@@@@@                                              
    f@@@7      ,@@@,      M@@i @@@       R@@R      bbD.                                             
    @@@7                 1@@0  7@@R      7@@@1.                                                     
   c@@@                 r@@D    J@@h      ,Z@@@@@@RY.                                               
   r@@@                .@@@i,ii:,@@@7         ,Lp@@@@@:                                             
    @@@0        ii.    @@@@@@@@@@@@@@,             t@@@                                             
    .@@@R.     9@@@:  @@@t        i@@@   @@@9      9@@@                                             
      F@@@@@@@@@@b   @@@Q          h@@@  .@@@@@@@@@@@p  ..                                          
          :rr:       :                ,      .irr:.                                                                                                                                                      
                                                                                                                                                      
                                                                                                                                                      
                                                                                                                                                      
            :pQ@Q@R@R@U:          R@M@R.             rf@R@R@R@R@h7              Q@MRZ@R                  ,RQMRM@M       7@MQZ@R@R@ZRXt:               
         .RQ@Q@R@Q@R@Q@Q@2        @R@R@           cR@R@R@Q@R@R@Q@R@RY           @R@R@R@R                 R@R@R@Q@       XQ@Q@R@R@Q@R@R@Q@Y            
        h@R@Q@RMc7ij9@R@Q@R:      R@R@R         :@R@Q@Q@bfr7rU9@R@R@Q@i         R@R@R@Q@L               1@R@Q@R@Q       c@R@RR:LrY7PR@R@R@Qi          
       R@R@R@:        7R@R@R7     @R@R@        U@R@Q@S.          1@Q@R@S        @Q@RpR@R@              .@R@R0Q@Q@       jR@R@7        2R@R@R.         
      t@R@Q@           .R@R@h     R@R@R       7@Q@Q@.             .@Q@R@U       R@R@.rR@R@             @R@Q.7@Q@R       L@Q@QS         hR@Q@Z         
      @R@Q@.            :.        @Q@R@       @R@R@,               .@Q@Q@       @R@R7 @R@RS           pR@QR DR@R@       UR@R@2          @R@R@         
     JQ@R@R                       Q@R@R      tR@R@R                 Z@Q@Rb      R@R@Y .@R@R,         ,Q@Q@  Z@R@Q       L@Q@RP         iQ@R@Q         
     D@R@Qf                       @Q@Q@      R@R@Q7                 rR@R@Q      @R@R1  P@R@R         R@R@i  QR@Q@       jR@Q@U         R@R@RL         
     @Q@Q@i                       R@Q@R      @Q@R@.                 .@Q@R@      R@R@t   R@R@P       S@R@R   R@R@R       7@R@Rf       JQ@R@RM          
     Q@R@Qr                       @R@Q@      Q@Q@R:                 .R@Q@R      @Q@Rh   ,R@R@:     .@R@R    @R@Q@       jR@R@R@R@R@Q@R@Q@Rc           
     QR@R@c                       R@Q@R      @Q@Q@i                 :@R@R@      R@R@t    PR@R@     @R@R7    R@R@Q       L@Q@R@Q@R@R@R@QM:             
     Y@R@R@                       @R@R@      U@R@QQ                 0R@Q@S      @R@Qh     @Q@RR   EQ@Q@     @R@R@       jQ@R@h  ,.,                   
      R@R@Q.            ,:        R@Q@R       R@R@Q.                R@Q@R.      R@R@U      @Q@Q, ,R@R@      R@R@Q       L@R@Rt                        
      EQ@R@Q            @R@QM     @R@Q@       XQ@R@Q               R@Q@Rp       @R@Qh      Y@R@R R@R@i      @R@Q@       jR@R@f                        
       @R@R@R.        .@Q@R@t     R@R@Q        RQ@Q@QL           iQ@R@RR        R@Q@U       R@R@M@R@R       R@R@R       L@R@RX                        
        QR@R@QQr,  .YQ@R@R@r      @R@Q@         1R@R@R@P7.. ..rF@R@Q@Qf         @Q@QS        R@Q@Q@R        @Q@R@       UQ@R@2                        
         rR@R@R@R@Q@R@R@RQ        R@R@Q.         .P@R@Q@R@R@R@R@Q@Q@S           R@R@S        YR@R@R7        R@R@R       U@R@RD                        
           .SR@Q@Q@R@R@L.         @R@R@             iS@R@R@R@Q@R@Fi             @R@Q0         @Q@Q@         @Q@R@       FR@R@P                        
                 .                                         .                                                                                          
                                                                                                                                                      
                                                                                                                                                      

                                                                                                    
         :rtYY:        r:i          .r72YY:.         ,::,i             i,::.     i,::i::.           
      iQ@Q@R@Q@Q@i    .R@Qi      ,QR@Q@R@Q@Q@S.      0@R@Q@           @R@R@Y    9R@Q@R@R@R@9.       
     DQ@R0,  .7@Q@R    @R@.     M@R@9i   .r@Q@Rf     hR@R@Rr         cR@R@R7    c@R@   .:RR@Qr      
    2R@R.       @R@.   R@R,    Q@R@         :R@R2    j@RrE@R         Q@fcQ@i    jQ@R      fQ@R      
    Q@RY               @Q@.   :@R@           YR@R    1R@, R@R       R@R 7@R7    7@R@       @R@      
   ,@R@                R@R,   RR@R            @R@r   J@RY hR@7     7@Rr bQ@i    JR@R      @R@R      
   rR@Q                @R@.   Q@RD            R@Rt   1Q@c  @R@     @R@  P@Q7    7@R@:L72D@R@Q       
   ,@R@                R@R,   RR@R            @Q@i   J@Rt   @Q@   @R@   ZR@r    JQ@R@R@R@Q0.        
    R@Rc               @Q@.   r@R@           iQ@R    1R@Y   J@Rc 7Q@r   9@R7    7@R@                
    SR@R        @Q@,   R@R,    R@Q@          Q@Qh    J@R2    R@R R@R    MR@r    JQ@Q                
     RR@RJ    :@R@Q    @R@.     R@R@c.    .PQ@Rp     hR@j     R@R@R     E@RL    L@Q@                
      7R@R@R@R@R@7    .R@Qi      7@R@R@R@R@Q@R,      0@QZ     UQ@RY     @R@Y    9R@Q                
         cSRDD7,       1c1         .ih0QDDY:         iJ1,      YLJ      i2J,    ,2Lj                
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
       ib@R@R@R@r          .Q@R@:          7R@Q@R@RZ.                                               
     .@Q@R@FXE@R@Ri        R@R@Q@         @R@Rtic9@R@Z                                              
    .@R@h      cQ@R,      r@QL @RD       FQ@M      @R@.                                             
    @R@Z        7i.       @R@  R@Q.      S@R@                                                       
   .R@R.                 QR@i  .Q@Q      .Q@R@7,                                                    
   :@R@                 :R@R    FR@Y       E@Q@R@RMi                                                
   rQ@R                 R@Q      @R@         :7MR@Q@QM                                              
    @R@.               h@R@R@Q@R@R@Q@             iQ@RM                                             
    Q@R@        UP:    @R@hQR@R@MbR@Q7   ..i       :Q@Q                                             
     Q@RR      Y@Q@.  @R@7        ,R@R   R@Q1      f@R@                                             
     .R@R@R92QR@Q@.  bQ@R          QR@R  :R@R@Xtc0R@R@   .                                          
       ,ZR@R@Q@Di   .R@R:           @Q@:   7@R@R@R@Z7   .                                           
                                                                        




                 
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
                                                                                                                                                      
                                                                                                                                                      
                                   .     ..                     ..                                                              .                     
                    .@R       ,ZF@QP,t9..@P   R@1@PiirQ@ir7:    D@,  7p@R:   QEEF1R@QSFEDQ    ,@i R@  M@     7Rc ,R@p@R.    R@f007j@10DQ.             
               :@077ER@9RD@Ri rXYR@,.iM. RF   @MhR R@tS1DS@F    pQiPRL:       pM0M@QDpZZb   :r7R@ @R:Y@b7. rER@DY,@c S@     @RL7X 9Qf:::Y             
       . . . . rRF   Ec   2@.  .U@RP,2p  @Y   RRi@,,:cYUc7r, 1RQQ@0b2RSPR@F ,SjDZ@DfLERQjh: 7R2rD@Y1R@rfp7   @QRL.RL SR     R@iSRFY@,bRM7             
          . .  .MXf:ERQrfYpD. ,D@QpE@rQhDQ@D: @D R@,:QQ1@::     SR  .R@.    .2RR@MccJp@RMF:     QQ  @i     J@Q@7r:@i f@     @Qi:, @R ,@.              
                     @R        r @2 ..   @7   RR :  7@ iR rY    S@tFY :@pJ,  : .RE72LpR: r   ,:ZQi  Rb .R@    R, @R  2QYRi 2R:   ZQ  iQ:                                                                                                                                   


















       
                                                                                                                                                      
                                                                       . ,.:..                                                                        
                                                              .:7YP9RR@Q@D@DZR@RQ00UY::                                                               
                                                         :rSZ@R@R@R@Q@R@i,7  @R@Q@Q@Q@R@Rb7r                                                          
                                                      :7RMMM@Q@R@R@R@R@QMh@UMQ@Q@R@R@R@Q@SP29fr                                                       
                                                   ,7ZQ@Ri .,FX@R@R@MMSXUf77ic7hb@Q@R@Z0.iUYZ@Q@Ui                                                    
                                                 .tM@Q@R@EriFphSJ:.        .r1h   .:U0bf9M@R@M@R@Rbi.                                                 
                                               ,7@R@MRDQR@Rbc,          M@Q@Q@R@.      rhQR@QQM@R@R@hi                                                
                                              iS@R@RQM@Q@Yi            R@R@ZQD@R@.        if@R@L7Y2Y@M7.                                              
                                            .rSb. :RR@Rh. 7@R@Q@R@r   0@R@RRDRM@,           .SQUrr .iPQ7,                                             
                                            i1@QY .7RR7.  @Q@R@Q@R@R7t@QQ9RRQD@P:it2DZ@Q@R2   7R@.hZ0Z@Qr,                                            
                                           rr@R@MRR@Rr.   Z@R@MRZQR@Q@R@Y .@QQR@Q@R@Q@R@R@R@Q9.rR@R@RQZ@Pi                                            
                                          ,:ZRQDQR@Rc,      hQ@RRMM,:M@R@2Yi@Q@. r@MQR@Q@R@Qp  .tR@DRERR@:r                                           
                                          ,iQ@DRERR@,,        ,ER@9..QR  U7i .S@D@RQZZ9REMS,   ::@MRDREQQU:                                           
                                          ::@RRbRE@D:.    ,,:,:YQD@R@Rb .R@R  QRRPQM@L         .iR@DRDRZ@ci                                           
                                          .iE@ZRDRM@::   QR@R@R@DRQ2 iR@Y.:UY0QR  f@M@Q1       :i@MRERE@R7:                                           
                                           :YR@D@R@RE. 7@R@Q@R@R@Q@b7J@Q@Q7:@R@Q@R@ZRM@R@Di   .,RQ@Q@MRRR::                                           
                                           ,:MR@Ut1MRX,::9R@Q@R@Q@R@bQRRM@,.S@Q@R@Q@MQM@R@R   :0Q@1FJMR@ri                                            
                                            ::@RSUU:EQM.   .7,,      b@DRM@R@R@  :@R@R@R@R0  iRR@7ricE@Li                                             
                                             ,:RRb,iitQ@1:          R@MREQM@Q@,    :ir:i:L,:F@RMiFU1R@7:                                              
                                               ,SR@bh.jf@QR7.       pR@R@R@Q@i           ,pQ@01rr7@RQi,                                               
                                                 r0@QXiF:bE@RMYi     .M@9Fi:         i7DR@RDi:iEQ@Qt.                                                 
                                                  .:ER@Rj:iP@R@Q@DEt7.i:     .iicUMQ@Q@Qhr:XDP@RQ7,                                                   
                                                     ,7RR@Q@Rt:tf@QQRRMQZ@R@R@R@R@XMr:9@0SE@R@fr                                                      
                                                        ,iFb@Q@p@Rb:9:c:rR77:PiX@RYh9b@R@RZL:                                                         
                                                             :rhPRQ@Q@R@R@R@M@R@R@R@Z07i                                                              
                                                                    ,,ii7i7i7:r,.                                                                     
                                                                                                                                                      
                                                                                                                                                      
                                                                                                                                                      
                        QQRi,                     rL1j2jEj              ,                  F7   i9rir 7QZ                  .L:i                       
                        .@R@p                  Uh7,,     ZQ            @Rh   , i0@7        @R@.  2Di.7ZQF,                  S@Ri                      
                        :R@Rb,YR@QQ       . .R@R@:.  7,   @Y        .S@J     Q@R@R@         77   .J0@R.         .R@R@     L   ,rtr@S                  
               .R,   .U@R@Z@r,Yh:.        SYQX XR@R2 @R   j1       pR7  ::  :@S Q@R           iDtr.  :Rf         . ,Q2   @R1UY,  :QR                  
               .@R.:RRtr@RQR@QY:          @7, .Q@tLQ.  .  Rj    .M@Rr.YQ@b, ,R7.@R@Qi      Q@RR       @0            :R@ 7R@Y7,,rYi                    
                7@R@,   M@Q@h7r,         rbiY YMRFit.RR@i R7     7  , ,@bi FR@rbR@0Y.      @RE 1M@R@7            @R@:Sf  i  7Y7S2:                    
                  i. ibL@Q@r             1,:@:Yri7Qi@R    @,      LQ@iXQE  Rb, i@Ri         i  .  SR            ZR@R1      :@R@Ri                     
                        R@2              Q.Q,i,7MR7cRY    Ri      R@f. @R:     :R@                c@Y .i..     :Q@R@R     .@R@i@    :                 
                        @R               R@:  ,pMi:   ..:r@7            r      i@          X@YJ7YriJ@FF1j.     Y@Q@Q:     r1, .RYic9@Rr               
                        L7               :.      ,:LL11bSbc.                   7R          ..iii.:.1P            DR@           rPc,, r.     
                                                                                                                                                         
                                                                                                                       










                                                   _(\_/) 
                                                 ,((((^`\
                                                ((((  (6 \ 
                                              ,((((( ,    \
                          ,,,_              ,(((((  /"._  ,`,
                         ((((\\ ,...       ,((((   /    `-.-'
                         )))  ;'    `"'"'""((((   (      
                        (((  /            (((      \
                         )) |                      |
                        ((  |        .       '     |
                        ))  \     _ '      `t   ,.')
                        (   |   y;- -,-""'"-.\   \/  
                        )   / ./  ) /         `\  \
                           |./   ( (           / /'
                           ||     \\          //'|
                           ||      \\       _//'||
                           ||       ))     |_/  ||
                           \_\     |_/          ||
                           `'"                  \_\
                                                `'" 



/***
 * ┌───┐   ┌───┬───┬───┬───┐ ┌───┬───┬───┬───┐ ┌───┬───┬───┬───┐ ┌───┬───┬───┐
 * │Esc│   │ F1│ F2│ F3│ F4│ │ F5│ F6│ F7│ F8│ │ F9│F10│F11│F12│ │P/S│S L│P/B│  ┌┐    ┌┐    ┌┐
 * └───┘   └───┴───┴───┴───┘ └───┴───┴───┴───┘ └───┴───┴───┴───┘ └───┴───┴───┘  └┘    └┘    └┘
 * ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───────┐ ┌───┬───┬───┐ ┌───┬───┬───┬───┐
 * │~ `│! 1│@ 2│# 3│$ 4│% 5│^ 6│& 7│* 8│( 9│) 0│_ -│+ =│ BacSp │ │Ins│Hom│PUp│ │N L│ / │ * │ - │
 * ├───┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─────┤ ├───┼───┼───┤ ├───┼───┼───┼───┤
 * │ Tab │ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │{ [│} ]│ | \ │ │Del│End│PDn│ │ 7 │ 8 │ 9 │   │
 * ├─────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴─────┤ └───┴───┴───┘ ├───┼───┼───┤ + │
 * │ Caps │ A │ S │ D │ F │ G │ H │ J │ K │ L │: ;│" '│ Enter  │               │ 4 │ 5 │ 6 │   │
 * ├──────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴────────┤     ┌───┐     ├───┼───┼───┼───┤
 * │ Shift  │ Z │ X │ C │ V │ B │ N │ M │< ,│> .│? /│  Shift   │     │ ↑ │     │ 1 │ 2 │ 3 │   │
 * ├─────┬──┴─┬─┴──┬┴───┴───┴───┴───┴───┴──┬┴───┼───┴┬────┬────┤ ┌───┼───┼───┐ ├───┴───┼───┤ E││
 * │ Ctrl│    │Alt │         Space         │ Alt│    │    │Ctrl│ │ ← │ ↓ │ → │ │   0   │ . │←─┘│
 * └─────┴────┴────┴───────────────────────┴────┴────┴────┴────┘ └───┴───┴───┘ └───────┴───┴───┘

 *_______________#########_______________________
 *______________############_____________________
 *______________#############____________________
 *_____________##__###########___________________
 *____________###__######_#####__________________
 *____________###_#######___####_________________
 *___________###__##########_####________________
 *__________####__###########_####_______________
 *________#####___###########__#####_____________
 *_______######___###_########___#####___________
 *_______#####___###___########___######_________
 *______######___###__###########___######_______
 *_____######___####_##############__######______
 *____#######__#####################_#######_____
 *____#######__##############################____
 *___#######__######_#################_#######___
 *___#######__######_######_#########___######___
 *___#######____##__######___######_____######___
 *___#######________######____#####_____#####____
 *____######________#####_____#####_____####_____
 *_____#####________####______#####_____###______
 *______#####______;###________###______#________
 *________##_______####________####______________

*
 * ????????????????????????▄??
 * ??????????█???????????▄??▌?
 * ???????????█????????▄?????
 * ????????▄???????▄▄▄???????
 * ?????▄▄????????????█??▄█??
 * ???▄?????????????????██??▌
 * ??????▄▄???????????????▄??
 * ??▌??▌█??????▄?█▄???????█??
 * ?????????????▌██??????????▄
 * ?▌??▄██▄???????????????????
 * ????▄█▄█▌▄?????????????????

/***
                         *                        d*##$.
                         *  zP"""""$e.           $"    $o
                         * '$        '$        J$       $F
                         *   $k        $r     J$       d$
                         *   '$         $     $"       $~
                         *    '$        "$   '$E       $
                         *     $         $L   $"      $F ...
                         *      $.       4B   $      $$$*"""*b
                         *      '$        $.  $$     $$      $F
                         *       "$       R$  $F     $"      $
                         *        $k      ?$ u*     dF      .$
                         *        ^$.      $$"     z$      u$$$$e
                         *         #$b             $E.dW@e$"    ?$
                         *          #$           .o$$# d$$$$c    ?F
                         *           $      .d$$#" . zo$>   #$r .uF
                         *           $L .u$*"      $&$$$k   .$$d$$F
                         *            $$"            ""^"$$$P"$P9$
                         *           JP              .o$$$$u:$P $$
                         *           $          ..ue$"      ""  $"
                         *          d$          $F              $
                         *          $$     ....udE             4B
                         *           #$    """"` $r            @$
                         *            ^$L        '$            $F
                         *              RN        4N           $
                         *               *$b                  d$
                         *                $$k                 $F
                         *                 $$b                $F
                         *                  '$                $
                         *                   $L               $
                         *                    $               $
 */

/***
 *                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.
 *             __.'              ~.   .~              `.__
 *           .'//                  \./                  \\`.
 *         .'//                     |                     \\`.
 *       .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
 *     .'//.-"                 `-.  |  .-'                 "-.\\`.
 *   .'//______.============-..   \ | /   ..-============.______\\`.
 * .'______________________________\|/______________________________`.
 *
 */

  /*
        quu..__
         $$$b  `---.__
          "$$b        `--.                          ___.---uuudP
           `$$b           `.__.------.__     __.---'      $$$$"              .
             "$b          -'            `-.-'            $$$"              .'|
               ".                                       d$"             _.'  |
                 `.   /                              ..."             .'     |
                   `./                           ..::-'            _.'       |
                    /                         .:::-'            .-'         .'
                   :                          ::''\          _.'            |
                  .' .-.             .-.           `.      .'               |
                  : /'$$|           .@"$\           `.   .'              _.-'
                 .'|$u$$|          |$$,$$|           |  <            _.-'
                 | `:$$:'          :$$$$$:           `.  `.       .-'
                 :                  `"--'             |    `-.     \
                :##.       ==             .###.       `.      `.    `\
                |##:                      :###:        |        >     >
                |#'     `..'`..'          `###'        x:      /     /
                 \                                   xXX|     /    ./
                  \                                xXXX'|    /   ./
                  /`-.                                  `.  /   /
                 :    `-  ...........,                   | /  .'
                 |         ``:::::::'       .            |<    `.
                 |             ```|           x| \ `.:``.
                 |                         .'    /'   xXX|  `:`M`M':.
                 |    |                    ;    /:' xXXX'|  -'MMMMM:'
                 `.  .'                   :    /:'       |-'MMMM.-'
                  |  |                   .'   /'        .'MMM.-'
                  `'`'                   :  ,'          |MMM<
                    |                     `'            |tbap\
                     \                                  :MM.-'
                      \                 |              .''
                       \.               `.            /
                        /     .:::::::.. :           /
                       |     .:::::::::::`.         /
                       |   .:::------------\       /
                      /   .''               >::'  /
                      `',:                 :    .'
                                           `:.:'
         

        /*
                                MMMMM
                                  MMMMMM
                                    MMMMMMM
                                     MMMMMMMM     .
                                      MMMMMMMMM
                                      HMMMMMMMMMM
                                       MMMMMMMMMMMM  M
                                       MMMMMMMMMMMMM  M
                                        MMMMMMMMMMMMM  M
                                        MMMMMMMMMMMMM:
                                        oMMMMMMMMMMMMMM
              .MMMMMMMMMMMMMMo           MMMMMMMMMMMMMMM M
        MMMMMMMMMMMMMMMMMMMMMMMMMMM      MMMMMMMMMMMMMMMM
          MMMMMMMMMMMMMMMMMMMMMMMMMMMM.  oMMMMMMMMMMMMMMM.M
            MMMMMMMMMMMMMMMMMMMMMMMMMMMM  MMMMMMMMMMMMMMMM
              MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                     H
                     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                  .         MMM
                      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM              M       MMMMMM
                       .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM          M   MMMMMMMMMM
                MM.      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM       M MMMMMMMMMMMM
                    MM    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    .MMMMMMMMMMMMMM
                      MM  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                        MM MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
               .MMMMMMMMM MMMMMMMMMMMMMMMMMMMMMMMM.MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                  HMMMMMMMMMMMMMMMMMMMMM.MMMMMMMMM.MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                     MMMMMMMMMMMMMMM MMM.oMMMMMMM..MMMMMMMMM:MMMMMMMMMMMMMMMMMMMMMMM
                       MMMMMMMMMMMMMM MM..MMMMMMM...MMMMMMM. MMMMMMMMMMMMMMMMMMMMM
                         MMMMMMMMMMMMMMM ..MMMMMM...MMMMMM ..MMMMMMMMMMMMMMMMMMM
                          MMMMMMM:M.MMM.M.. MMMMM M..MMMMM...MMMMMMMMMMMMMMMMMM  MMM
                            MMMM. .M..MM.M...MMMMMM..MMMMM.. MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM .
                             MMMM..M....M.....:MMM .MMMMMM..MMMMMMM...MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                              MMM.M.. ...M......MM.MMMMM.......MHM.M  .MMMMMMMMMMMMMMMMMMMMMMMMM
                         MMMMMMMM..MM. . MMM.....MMMMMM.M.....M ..MM..M MMMMMMMMMMMMMMMMMMM
                            .MMMMMHMM. ..MMMM. MMM............o..... . .MMMMMMMMMMMMMMM
                               MMM. M... .........................M..:.MMMMMMMMMMMM
                                 oMMM............ .................M.M.MMMMMMMMM
                                    .....MM........................ . MMMMMM
                                   M.....M.....................o.MM.MMMMMMMM.
                                    M........................M.. ...MMMMMMMMMMMMMo
                                      :....MMM..............MMM..oMMMMMMM
                                       M...MMM.............MMMMMMM
                                          .............:MMMMMMMM
                                          M..... MMM.....M
                                          M M.............
                                          ................M
                                       ooM.................MM  MoMMMMMoooM
                                  MMoooM......................MoooooooH..oMM
                              MHooooMoM.....................MMooooooM........M
                            oooooooMoooM......... o........MoooooooM............
                            Mooooooooooo.......M.........Moooooooo:..............M
                           MooMoooooooooM...M........:Mooooooooooo:..............M
                          M..oooooooooooo .........Mooooooooooooooo..............M
                         M...Mooo:oooooooo.M....ooooooooooooooooooo..M...........M
                          ...oooooMoooooooM..Mooooooooooooo:oooooooM.M...........M.
                         M...ooooooMoo:ooooMoooooooooooooHoooooooooH:M. ...........:
                         M..MoooooooMoooooooooooooooooo:ooooooMooooMoM..............M
                         M..ooooooooooMooooooooooooooHoooooooMooHooooM...............M
                         ...ooooooooooooooooooo:MooooooooooooooMoMoooM................
                        M...oooooooooooooooooooooooooooooooooooooMooMM................M
                        ...MooooooooooooooooooooooooooooooooooooooooMo ................
                        ...MooooooooooooooooooooooooooooooooooooooooM M................M
                       M...ooooooooooooooooooooooooooooooooooooooooM   ................M
                       ...MoooooooooooooooooooooooooooooooooooooooMM   .:...............
                       .....MooooooooooooooooooooooooooooooooooooMoo       .............M
                       M...... ooooooooooooooooooooooooooooooooooooM       M..............M
                       M........MooooMMM MM MM  MMMMMMMMMooooooooM         M...............M
                       .........HM     M:  MM :MMMMMM          M           M...............
                      M..........M     M   MoM M                           M................M
                      M.........:M  MoH  M M M MooooHoooMM.   M             M...............M
                      M..........Moooo MMooM    oooooMooooooooM              M..............H
                      M.........MooooM  Mooo  : ooooooMooooMoooM              M........ . .o.M
                      H..  .....ooooo   oooo  M MooooooooooooooM               M... MMMMMMMMMMM
                      MMMMMMMMMMooooM M oooo  .  ooooooMooooooooM              .MMMMMMMMMMMMMMM
                      MMMMMMMMMMooooH : ooooH    oooooooooooooooo               MMMMMMMMMMMMMMM
                      MMMMMMMMMMoooo    ooooM    Moooooooooooooooo              .MMMMMMMMMMMMMMM
                      MMMMMMMMMMoooo    ooooM    MooooooooooooooooM              MMMMMMMMMMMMMMM
                      MMMMMMMMMMoooM    ooooM     ooooooooooooooooo               MMMMMMMMMMM:M
                      MMMMMMMMMMoooM   MooooM     oooooooooooMoooooo               MH...........
                       . ......Mooo.   MooooM     oooooooooooooooooo              M............M
                      M.M......oooo    MooooM     Moooooooooooooooooo:           .........M.....
                      M.M.....Moooo    MooooM      ooooooooooooooooooM            .M............
                      .......MooooH    MooooM      oooooooooMoooooooooo          M..o...M..o....M
                      .o....HMooooM    MooooH      MooooooooMooooooooooM          .:M...M.......M
                     M..M.....MoooM    :oooo:    .MooooooooHooMoooooooooM         M M... ..oM.M
                      M...M.:.Mooo. MMMMooooo   oooooooooooMoooooooooooooM          ....M. M
                       M:M..o.Moooooooooooooo MooooooooooooooMooooooooooooM          .Mo
                              MooooooooooooooMooooooooooooMoMoooooooooooooo
                              Mooooooooooooooo:ooooooooooooooooooooooooooooo
                              ooooooooooooooooMooooooooooMoooooooooooooooooo
                              ooooooooooooooooMoooooooooooMooooooooooooooooHo
                              ooMooooooooooooooMoooooooooooooooooooooooooooMoM
                             MooMoooooooooooooo.ooooooooooooooooooooooooooo:oM
                             MoooooooooooooooooooooooooooooooooooooooooooooooM
                             MoooMooooooooooooooMooooooooooooooooooooooooooooo.
                             MoooMooooooooooooooMoooooooooooooooooooooooooMooooM
                             MooooooooooooooooooMoooooooooooooooooooooooooMoooooM
                             MooooMoooooooooooooMoooooooooooooooooooooooooMoHooooM
                             ooooooMooooooooooooooooooooooooooooooooooooooooMoMoooM
                            MooooooooooooooooooooMooooooooooooooooooooooooooMoooooH:
                            MoooooooMooooooooooooMoooooooooooooooooooooooooooooHoooM
                            MooooooooMoooooooooooMoooooooooooooooooooooooooMoooMooooM
                            Moooooooooooooooooooooooooooooooooooooooooooooo.oooMooooo
                            MoooooooooooooooooooooooooooooooooooooooooooooMoooooooooM
                             MooooooooooooooooooooMoooooooooooooooooooooooooooooooooM
                              MooooooooooooooooooooMHooooooooooooooooooooMoooo:ooooo
                               MMooooooooooooooooooMoMHoooooooooooooooooooooooMooooo
                                MMoooooooooooooooMMooo MMooooooooooooooooooooooooooM
                                MMMoooooooooooooMooooo  oooooooooooooooooooooMooooo
                                MooMMoooooooooMoooMMoM  ooooHooooooooooooooooMooooM
                                MooooMooooooMooooMoooM  MoooooMoooooooooooooMooooo
                                ooooooMMooooooooMooooM  MoooooooooMooooooooooooooM
                                HooooooMoooooooMooooM    HoooooooHooMooooooooooooo
                                 oooMoooooooooHoooM         MoooooooooMoooooooooM
                                  HooooooooooooHM             MooooooooMMoooooooM
                                   MMMMMMMMMMMMMM                Moooooo:MooooHMM
                                    MMMMMMM: ...                  MMMMMMMMMMMMMM
                                   M............M                  MMMMMMMMM ....
                                   M.MM..........                  M.............M
                                M ..............MM                 M..............
                             MMMMM............MMMM                 ..MMMMMMMM ....M
                           MMMMMMMMMMMMMMMMMMMMMMMM               MMMMMMMMMMMMM...M
                        .MMMMMMMMMMMMMMMMMMMMMMMMMM               MMMMMMMMMMMMMMMMMM
                        MMMMMMMMMMMMMMMMMMMMMMMMM                MMMMMMMMMMMMMMMMMMM
                        :MMMMMMMMMMMMMMMMMMH                     MMMMMMMMMMMMMMMMMMM
                           By EBEN Jér?me                        MMMMMMMMMMMMMMMMMM
                                                                 MMMMMMMMMMMMMMM
                                                                  HMMMMMM
         
        */



%}