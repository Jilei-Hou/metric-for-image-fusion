file_path ='C:\Users\HJL\Desktop\test\fusion\';% �ں�ͼ��·��

img_path_list1 = dir(strcat(file_path,'*.bmp'));% .bmp��Ҫ�����ں�ͼ��ĸ�ʽ��Ӧ����
img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26;  % 26��Ӧ�ں�ͼ������� OURS���Ը�Ϊ��Ӧ�ķ������ƣ���һ��1x26�ľ���,�����ÿһ���ں�ͼ���ENֵ
% sum_0URS = 0;
if img_num > 0 
    for m = 1:26 % 26��Ӧ�ں�ͼ�������
        image_name1 = img_path_list1(m).name;
        image_IR = imread(strcat(file_path,image_name1));
        En = entrCompute(image_IR,1);
%         sum_0URS = sum_0URS+En;
        OURS(m) = En;
    end
end
mean_OURS = mean(OURS)
std_OURS = std(OURS)
