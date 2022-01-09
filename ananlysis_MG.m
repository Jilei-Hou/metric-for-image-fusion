function theAG = ananlysis_MG(I)
    I = double(I);     [rI,cI,hI] = size(I); 
     
    for h = 1 : hI 
        [Ix,Iy] = gradient(I(:,:,h),1,1); 
        grad(h) = sum(sum(sqrt((Ix .^ 2 + Iy .^2) ./ 2))) / ((rI - 1) * (cI - 1)); 
    end 
    theAG = mean(grad); 
end