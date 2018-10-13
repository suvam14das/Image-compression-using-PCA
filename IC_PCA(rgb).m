% PCA-based color image compression
% Break up RGB image into channels and perform SVD on each of them
% Take sub-portions of components to regenerate channels and combine

%% Load image
img = imread('Rubber_Ducky.jpg');
%% Get grayscale image
figure(1);

subplot(1,2,1);
imshow(img);
title('Original');

%% Do SVD on grayscale NxN matrix
shape = size(img);
U = zeros(shape);
S = zeros(shape);
V = zeros(shape);
for i = 1:3
    [U(:,:,i),S(:,:,i),V(:,:,i)] = svd(im2double(img(:,:,i)));
end

%% Contains sub-portion of components
Ug = zeros(shape);
Sg = zeros(shape);
Vgt = zeros(shape);
Vt = zeros(shape);
for i = 1:3
    Vt(:,:,i) = V(:,:,i)';
end

%% Regenerate from components (for varying sub-portions p)
% N = size(img,1);
N = 100;
for p = 1:N
    regenerated_img = zeros(shape);

    for i = 1:3
        Ug(:, 1:p, i) = U(:, 1:p, i);
        Sg(1:p, 1:p, i) = S(1:p, 1:p, i);     
        Vgt(1:p, :, i) = Vt(1:p, :, i);
        regenerated_img(:,:,i) = Ug(:,:,i) * Sg(:,:,i) * Vgt(:,:,i);
    end
    
    imwrite(regenerated_img,sprintf('PCA_rgb_Rubber_Ducky_%d.png', p),'png');
end