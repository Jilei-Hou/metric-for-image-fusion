clear;
file_pathIR ='C:\Users\HJL\Desktop\test\ir\';
img_path_listIR = dir(strcat(file_pathIR,'*.bmp'));
file_pathVI ='C:\Users\HJL\Desktop\test\vi\';
img_path_listVI = dir(strcat(file_pathVI,'*.bmp'));
file_path1 ='C:\Users\HJL\Desktop\test\fusion\';
img_path_list1 = dir(strcat(file_path1,'*.bmp'));

img_num = length(img_path_list1);
I=cell(1,img_num);
OURS = 1:26;
sum_0URS = 0;
if img_num > 0 
    for m = 1:26  
        image_name1 = img_path_list1(m).name; 
        image_OURS = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;  
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name; 
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        u1 = image_OURS;
        u2 = IR;
        u3 = image_OURS;
        u4 = VI;
        m1 = analysis_MI(u1,u2,'MI');
        m2 = analysis_MI(u3,u4,'MI');
        m3 = m1 + m2;
%         sum_0URS = sum_0URS+m3;
        OURS(m) = m3;
        clear m1;
        clear m2; 
    end
end

mean_OURS = mean(OURS)
std_OURS = std(OURS)
