clear;
file_pathIR ='C:\Users\HJL\Desktop\test\ir\';% ����ͼ��·��
img_path_listIR = dir(strcat(file_pathIR,'*.bmp'));
file_pathVI ='C:\Users\HJL\Desktop\test\vi\';% �ɼ���ͼ��·��
img_path_listVI = dir(strcat(file_pathVI,'*.bmp'));
file_path1 ='C:\Users\HJL\Desktop\test\fusion\';% �ں�ͼ��·��
img_path_list1 = dir(strcat(file_path1,'*.bmp')); % .bmp��Ҫ�����ں�ͼ��ĸ�ʽ��Ӧ����

img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26; 
% sum_0URS = 0;
if img_num > 0 
    for m = 1:26 
        image_name1 = img_path_list1(m).name;
        image_ours = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;  
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end

        image_name3 = img_path_listVI(m).name;
        VI = imread(strcat(file_pathVI,image_name3));
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
        N1=sum(sum((IR-mean(mean(IR))).*(image_ours-mean(mean(image_ours)))));
        D1=sqrt(sum(sum((IR-mean(mean(IR))).^2))*sum(sum((image_ours-mean(mean(image_ours))).^2)));
        r_AF=N1/D1;
        N2=sum(sum((VI-mean(mean(VI))).*(image_ours-mean(mean(image_ours)))));
        D2=sqrt(sum(sum((VI-mean(mean(VI))).^2))*sum(sum((image_ours-mean(mean(image_ours))).^2)));
        r_BF=N2/D2;
        ssim=0.5*r_AF+0.5*r_BF;
%         sum_0URS = sum_0URS+ssim;
        OURS(m) = ssim;
        clear ssim;    
    end
end
mean_OURS = mean(OURS)
std_OURS = std(OURS)
