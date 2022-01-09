file_path ='C:\Users\HJL\Desktop\test\fusion\';% path of fusion image
img_path_list1 = dir(strcat(file_path1,'*.bmp'));
img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26;
% sum_0URS = 0;
if img_num > 0 
    for m = 1:26   
        image_name1 = img_path_list1(m).name;
        image_IR = imread(strcat(file_path1,image_name1));
        Mg = ananlysis_MG(image_IR);
%         sum_0URS = sum_0URS+Mg;
        OURS(m) = Mg;
    end
end
mean_OURS = mean(OURS)
std_OURS = std(OURS)