function [oQ, Q, qMap] = analysis_ms_ssim(imgSeq, fI, K, window, level, weight)
% ========================================================================
% Multi-exposure fused (MEF) image quality model Version 1.0
% Copyright(c) 2015 Kede Ma, Kai Zeng and Zhou Wang
% All Rights Reserved.
%
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
% This is an implementation of an objective image quality assessment model
% for MEF images using their corresponding input source sequences 
% as reference.
% 
% Please refer to the following paper:
%
% K. Ma et al., "Perceptual Quality Assessment for Multi-Exposure
% Image Fusion" submitted to IEEE Transactions on 
% Image Processing.
%
%
% Kindly report any suggestions or corrections to k29ma@uwaterloo.ca,
% kzeng@uwaterloo.ca or zhouwang@ieee.org
%
%----------------------------------------------------------------------
%
%Input : (1) imgSeq: source sequence being used as reference in [0-255] grayscale.
%        (2) fI: the MEF image being compared in [0-255] grayscale.
%        (3) K: constant in the SSIM index formula (see the above
%            reference). defualt value: K = 0.03
%        (4) window: local window for statistics. default widnow is 
%            Gaussian given by window = fspecial('gaussian', 11, 1.5);
%        (5) level: multi-scale level used for downsampling. default value:
%            level = 3;
%        (6) weight: the weights in each scale (see the above reference).
%            default value is given by 
%            weight = [0.0448  0.2856  0.3001]'; 
%            weight = weight / sum(weight);
%            Note that the length of weight and level should be the same.
%            
%Output: (1) oQ: The overlll quality score of the MEF image.
%        (2)  Q: The quality scores in each scale.
%        (3) qMap: The quality maps of the MEF image in each scale. 
%
%Basic Usage:
%   Given the test MEF image and its corresponding source sequence 
%
%   [oQ, Q, qMap] = mef_ms_ssim(imgSeq, fI);
%
%
%========================================================================


if (nargin < 2 || nargin > 6)
   oQ = -Inf;
   Q = -Inf;
   qMap = -Inf;
   return;
end

if (~exist('K', 'var'))
   K = 0.03;
end

if (~exist('window', 'var'))
   window = fspecial('gaussian', 11, 1.5);
end

[H, W] = size(window);

if (~exist('level','var'))
   level = 3;
end

if (~exist('weight', 'var'))
   weight = [0.0448  0.2856  0.3001]'; 
   weight = weight / sum(weight);
end

if level ~= length(weight)
   oQ = -Inf;
   Q = -Inf;
   qMap = -Inf;
   return;
end

[s1, s2, s3] = size(imgSeq);
minImgWidth = min(s1, s2)/(2^(level-1));
maxWinWidth = max(H, W);
if (minImgWidth < maxWinWidth)
   oQ = -Inf;
   Q = -Inf;
   qMap = Inf;
   return;
end

imgSeq = double(imgSeq);
fI = double(fI);
downsampleFilter = ones(2)./4;
Q = zeros(level,1);
qMap = cell(level,1);
if level == 1
    [Q, qMap] = mef_ssim(imgSeq, fI,  K, window);
    oQ = Q;
    return;
else
    for l = 1 : level - 1
        [Q(l), qMap{l}] = mef_ssim(imgSeq, fI,  K, window); 
        imgSeqC = imgSeq;
        clear imgSeq;
        for i = 1:s3
            rI = squeeze(imgSeqC(:,:,i));
            dI = imfilter(rI, downsampleFilter, 'symmetric', 'same');
            imgSeq(:,:,i) = dI(1:2:end, 1:2:end);
        end
        dI = imfilter(fI, downsampleFilter, 'symmetric', 'same');
        clear fI;
        fI = dI(1:2:end, 1:2:end);
    end
    % the coarsest scale
    [Q(level), qMap{level}] = mef_ssim(imgSeq, fI,  K, window);
    Q = Q(:);
    oQ = prod(Q.^weight);
end

function [Q, qMap] = mef_ssim(imgSeq, fI,  K, window) 

if (nargin < 2 || nargin > 4)
   Q = -Inf;
   qMap = Inf;
   return;
end

if (~exist('K', 'var'))
   K = 0.03;
end

if (~exist('window', 'var'))
   window = fspecial('gaussian', 11, 1.5);
end


imgSeq = double(imgSeq);
fI = double(fI);
[s1, s2, s3] = size(imgSeq);
wSize = size(window,1);
sWindow = ones(wSize) / wSize^2; % square window used to calculate the distance
bd = floor(wSize/2);
mu = zeros(s1-2*bd, s2-2*bd, s3);
ed = zeros(s1-2*bd, s2-2*bd, s3);
for i = 1:s3
    img = squeeze(imgSeq(:,:,i));
    mu(:,:,i) = filter2(sWindow, img, 'valid');
    muSq = mu(:,:,i) .* mu(:,:,i);
    sigmaSq = filter2(sWindow, img.*img, 'valid') - muSq;
    ed(:,:,i) =  sqrt( max( wSize^2 * sigmaSq, 0 ) ) + 0.001; % add a small constant to avoid instability
end

R = zeros(s1-2*bd,s2-2*bd); % consistency map which could be used as an output if necessary
for i = bd+1:s1-bd
    for j = bd+1:s2-bd
        vecs = reshape(imgSeq(i-bd:i+bd,j-bd:j+bd,:),[wSize*wSize, s3]);
        denominator = 0;
        for k = 1:s3
            denominator = denominator + norm(vecs(:,k) - mu(i-bd,j-bd,k));
        end
        numerator = norm(sum(vecs,2) - mean(sum(vecs,2)));
        R(i-bd,j-bd) = (numerator + eps) / (denominator + eps);
    end
end

R(R > 1) = 1 - eps; % get rid of numerical instability
R(R < 0) = 0 + eps;


p = tan(pi/2 * R);
p( p >  10 ) = 10; % to avoid blow up (large number such as 10 is equivalent to taking maximum)
p = repmat(p,[1,1,s3]);


wMap = (ed / wSize).^p + eps; % to avoid blowing up
normalizer = sum(wMap,3);
wMap = wMap ./ repmat(normalizer,[1,1,s3]);
maxEd = max(ed,[],3);

C = (K * 255)^2;
qMap = zeros(s1-2*bd, s2-2*bd); 
for i = bd+1:s1-bd
    for j = bd+1:s2-bd
        blocks = imgSeq(i-bd:i+bd,j-bd:j+bd,:);
        rBlock = zeros(wSize,wSize);
        for k = 1 : s3
            rBlock = rBlock  + wMap(i-bd,j-bd,k) * ( blocks(:,:,k) - mu(i-bd,j-bd,k) ) / ed(i-bd,j-bd,k);
        end  
        if norm(rBlock(:)) > 0
            rBlock = rBlock / norm(rBlock(:)) * maxEd(i-bd,j-bd);
        end
        fBlock = fI(i-bd:i+bd,j-bd:j+bd);
        rVec = rBlock(:);
        fVec = fBlock(:);
        mu1 = sum( window(:) .* rVec );
        mu2 = sum( window(:) .* fVec );
        sigma1Sq = sum( window(:) .* (rVec - mu1).^2 );
        sigma2Sq = sum( window(:) .* (fVec - mu2).^2 );
        sigma12 = sum(  window(:) .* (rVec - mu1) .* (fVec - mu2)  );
        qMap(i-bd,j-bd) = ( 2 * sigma12 + C ) ./ ( sigma1Sq + sigma2Sq + C ); 
    end
end

Q = mean2(qMap);

