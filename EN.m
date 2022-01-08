file_path ='C:\Users\HJL\Desktop\test\fusion\';% path of fusion image

img_path_list1 = dir(strcat(file_path,'*.bmp'));% .bmp needs to be changed according to the format of the fusion image
img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26;  % 26 corresponds to the number of fusion images. OURS can be changed to the corresponding method name. It is a 1x26 matrix that stores the EN of each fusion image
% sum_0URS = 0;
if img_num > 0 
    for m = 1:26 % 26 corresponds to the number of fusion images
        image_name1 = img_path_list1(m).name;
        image_IR = imread(strcat(file_path,image_name1));
        En = entrCompute(image_IR,1);
%         sum_0URS = sum_0URS+En;
        OURS(m) = En;
    end
end
mean_OURS = mean(OURS)
std_OURS = std(OURS)
