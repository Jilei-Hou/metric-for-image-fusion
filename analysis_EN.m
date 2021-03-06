
function [entr,ind] = analysis_EN(InImg,groupNum)

entr = Imentropy(InImg);
%对信息熵进行排序
% trash = cell(numel(entr),1);
% ind = cell(numel(entr),1);
% for id = 1 : numel(entr)
%     [trash{id} ind{id}] = sort(entr{id},'descend');
% end
% end

function entr = Imentropy(im)
%      I = roundn(im,-1) ; %取小数点后n位
    [C,R] = size(im); %求图像的规格
     Img_size = C * R;  %图像像素点的总个数
     P_N = unique(im);
     L = length(P_N);
     H_img = 0;
     nk = zeros(L,1);
     for i = 1 : C
         for j = 1 : R
            for k = 1 : L
                 temp = P_N(k,1);
                        if im(i,j) == temp
                         nk(k,1) = nk(k,1) + 1;
                        end
            end
         end
     end
        for k = 1 : L
         Ps(k) = nk(k)/Img_size;  %计算每一个灰度级像素点所占的概率
         if Ps(k)~=0 %去掉概率为0的像素点
             H_img = -Ps(k)*log2(Ps(k))+H_img; %求熵值的公式
         end
        end
     entr = H_img;



