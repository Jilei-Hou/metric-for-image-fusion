function [MuInf] = analysis_MI(R,F,method)
if size(F,3) == 3
    F = rgb2gray(F);
end
if size(R,3) == 3
    R = rgb2gray(R);
end;

Hist = JoinHist(R,F);
[rows,columns] = size(R);
N_Hist = Hist./(rows*columns);
Marg_A = sum(N_Hist); %?
Marg_B = sum(N_Hist,2); 
H_A = 0;
H_B = 0;
for i=1:1:size(N_Hist,1)   
    if Marg_A(i) ~= 0
        H_A = H_A+(-Marg_A(i)*log2(Marg_A(i)));
    end
end
for i=1:1:size(N_Hist,2)   
    if Marg_B(i) ~= 0
        H_B = H_B + (-Marg_B(i)*log2(Marg_B(i)));
    end
end
H_AB = sum(sum( -N_Hist.*log2(N_Hist+(N_Hist == 0)) ));
 if strcmp(method,'MI')
     MuInf = H_A+H_B-H_AB;
 end
 if strcmp(method,'NMI')
     MuInf = (H_A+H_B)/H_AB;     
 end;
end

function Hist = JoinHist(R,F)
[rows,columns] = size(R);
Hist = zeros(256,256);
for i = 1:1:rows
    for j = 1:1:columns
        Hist(R(i,j)+1,F(i,j)+1) = Hist(R(i,j)+1,F(i,j)+1)+1;
    end
end
end