file_path ='C:\Users\HJL\Desktop\test\fusion\';% 融合图像路径

img_path_list1 = dir(strcat(file_path,'*.bmp'));% .bmp需要根据融合图像的格式相应更改
img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26;  % 26对应融合图像的张数 OURS可以改为对应的方法名称，是一个1x26的矩阵,存放着每一张融合图像的EN值
% sum_0URS = 0;
if img_num > 0 
    for m = 1:26 % 26对应融合图像的张数
        image_name1 = img_path_list1(m).name;
        image_IR = imread(strcat(file_path,image_name1));
        En = entrCompute(image_IR,1);
%         sum_0URS = sum_0URS+En;
        OURS(m) = En;
    end
end
mean_OURS = mean(OURS)
std_OURS = std(OURS)
