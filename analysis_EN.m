
function [entr,ind] = analysis_EN(InImg,groupNum)

entr = Imentropy(InImg);
%����Ϣ�ؽ�������
% trash = cell(numel(entr),1);
% ind = cell(numel(entr),1);
% for id = 1 : numel(entr)
%     [trash{id} ind{id}] = sort(entr{id},'descend');
% end
% end

function entr = Imentropy(im)
%      I = roundn(im,-1) ; %ȡС�����nλ
    [C,R] = size(im); %��ͼ��Ĺ��
     Img_size = C * R;  %ͼ�����ص���ܸ���
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
         Ps(k) = nk(k)/Img_size;  %����ÿһ���Ҷȼ����ص���ռ�ĸ���
         if Ps(k)~=0 %ȥ������Ϊ0�����ص�
             H_img = -Ps(k)*log2(Ps(k))+H_img; %����ֵ�Ĺ�ʽ
         end
        end
     entr = H_img;


