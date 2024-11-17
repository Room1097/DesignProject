% Load the grayscale image
img = imread('baboon.tif');
img = im2double(img);  % Convert to double for accurate gamma calculation in range [0, 1]

% Calculate and display the original histogram
original_hist = imhist(img);
figure;
subplot(2,2,1); imshow(img); title('Original Image');
subplot(2,2,2); bar(original_hist); title('Original Histogram');

% Analyze the histogram to decide on gamma
% If the histogram is skewed towards the dark side, use gamma < 1 to brighten
% Here, for demonstration, we select a gamma value directly. You may analyze
% original_hist to programmatically decide on gamma.

gamma = 1.5;  % Adjust gamma value based on histogram distribution analysis

% Apply gamma correction
gamma_corrected_img = img .^ gamma;

% Calculate and display the histogram after gamma correction
corrected_hist = imhist(gamma_corrected_img);
subplot(2,2,3); imshow(gamma_corrected_img); title(['Gamma Corrected Image (γ = ', num2str(gamma), ')']);
subplot(2,2,4); bar(corrected_hist); title('Gamma Corrected Histogram');
