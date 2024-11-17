% Read the input image (grayscale)
inputImage = im2double(imread('test.png'));  % Replace 'boat.png' with your image file
height = 32;
width = 32;

% Parameters
initialNoiseLevel = 0.05;  % Starting noise level

% Initialize variables
noiseLevel = initialNoiseLevel;
noisyImage = inputImage;
cumulativeNoise = zeros(height, width);  % To store cumulative noise applied

% Loop to adjust noise level and add unique noise each time
for i = 1:5  % Adjust noise over multiple iterations
    % Generate random noise (using uniform distribution)
    noise = noiseLevel * (rand(height, width) - 0.5);  % Uniform noise in range [-noiseLevel/2, +noiseLevel/2]
    
    % Accumulate noise for each iteration
    cumulativeNoise = cumulativeNoise + noise;
    
    % Add the noise to the image progressively
    noisyImage = noisyImage + noise;
    
    % Clip values to stay within the valid range [0, 1]
    noisyImage = max(min(noisyImage, 1), 0);
    
    % Increase noise level slightly for the next iteration
    noiseLevel = noiseLevel + 0.5;
end

% Display the original, noise, and final noisy images
figure;
subplot(1, 3, 1);
imshow(inputImage);
title('Original Image');

subplot(1, 3, 2);
imshow(cumulativeNoise, []);
title('Accumulated Noise Image');

subplot(1, 3, 3);
imshow(noisyImage);
title('Final Noisy Image');

% Display histograms of the original, noise, and noisy images
figure;
subplot(1, 3, 1);
imhist(inputImage);
title('Original Image Histogram');

subplot(1, 3, 2);
imhist(cumulativeNoise, 256);
title('Noise Histogram');

subplot(1, 3, 3);
imhist(noisyImage);
title('Noisy Image Histogram');