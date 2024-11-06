% Function to add noise to an 8x8 input image using modular arithmetic
function noisyImage = add_noise(inputImage, noise)
    % Initialize noisy image
    noisyImage = zeros(8, 8, 'uint8');    % Updated to 8x8

    % Add noise to each pixel using modular arithmetic
    for i = 1:8   % Update loop to 8x8
        for j = 1:8   % Update loop to 8x8
            % Step 1: Add the original image pixel and the noise
            sumPixel = int32(inputImage(i, j)) + int32(noise(i, j));  % Use int32 for addition
            
            % Step 2: Apply mod 256 to ensure the result stays within [0, 255]
            % After modulo, cast the result back to uint8
            noisyImage(i, j) = uint8(mod(sumPixel, 256));  
            
            % Debugging Step: Display intermediate steps
            fprintf('Adding: %d + %d = %d, After Modulo 256: %d\n', inputImage(i, j), noise(i, j), sumPixel, noisyImage(i, j));
        end
    end
end

% Function to remove noise from an 8x8 noisy image to reconstruct the original image
function reconstructedImage = remove_noise(noisyImage, noise)
    reconstructedImage = zeros(8, 8, 'uint8');  % Initialize reconstructed image

    % Remove noise from each pixel using modular subtraction
    for i = 1:8   % Update loop to 8x8
        for j = 1:8   % Update loop to 8x8
            % Step 1: Subtract the noise from the noisy image pixel
            diffPixel = int32(noisyImage(i, j)) - int32(noise(i, j));  % Use int32 for subtraction
            
            % Step 2: Apply mod 256 to ensure the result stays within [0, 255]
            % After modulo, cast the result back to uint8
            reconstructedImage(i, j) = uint8(mod(diffPixel + 256, 256));  % Adding 256 ensures non-negative values
            
            % Debugging Step: Display intermediate steps
            fprintf('Subtracting: %d - %d = %d, After Modulo 256: %d\n', noisyImage(i, j), noise(i, j), diffPixel, reconstructedImage(i, j));
        end
    end
end

% Main script
% Read the 8x8 input image (grayscale) - Replace with your 8x8 image file
inputImage = imread('input_image8.png');  % Replace with 'input_image8.png'

% Convert to grayscale if the image has multiple color channels (RGB)
if size(inputImage, 3) == 3
    inputImage = rgb2gray(inputImage);  % Convert RGB to grayscale
end

% Display the original image array for debugging (2D matrix)
disp('Original Image:');
disp(inputImage);  % Display the entire array of the original image

% Define noise (example, replace with generated noise if needed)
noise = uint8(randi([0, 255], 8, 8));  % Generate 8x8 random noise between 0 and 255

% Print the noise matrix row by row
disp('Generated Noise Image:');
for i = 1:8
    disp(noise(i, :));  % Display the entire i-th row of the noise matrix
end

% Add noise to the input image
noisyImage = add_noise(inputImage, noise);
disp('Noisy Image (after adding noise to original):');
for i = 1:8
    disp(noisyImage(i, :));  % Display the entire i-th row of the noisy image
end

% Reconstruct the original image by removing the noise
reconstructedImage = remove_noise(noisyImage, noise);
disp('Reconstructed Image (after removing noise):');
for i = 1:8
    disp(reconstructedImage(i, :));  % Display the entire i-th row of the reconstructed image
end

% Convert images back to display range [0, 1] for viewing
inputImageDisplay = im2double(inputImage);           % Original image in [0, 1] range
noiseDisplay = double(noise) / 255;                  % Convert noise to [0, 1] range for display
noisyImageDisplay = double(noisyImage) / 255;        % Noisy image in [0, 1] range for display
reconstructedImageDisplay = double(reconstructedImage) / 255;  % Reconstructed in [0, 1] range for display

% Display the original, noise, noisy, and reconstructed images
figure;
subplot(2, 2, 1);
imshow(inputImageDisplay);  % Display original image
title('Original Image');

subplot(2, 2, 2);
imshow(noiseDisplay);  % Display noise image
title('Generated Noise Image');

subplot(2, 2, 3);
imshow(noisyImageDisplay);  % Display noisy image
title('Noisy Image (Original + Noise)');

subplot(2, 2, 4);
imshow(reconstructedImageDisplay);  % Display reconstructed image
title('Reconstructed Original Image');

% Display histograms of the original, noise, noisy, and reconstructed images
figure;
subplot(2, 2, 1);
imhist(inputImageDisplay);  % Histogram of original image
title('Original Image Histogram');

subplot(2, 2, 2);
imhist(noiseDisplay);  % Histogram of noise image
title('Noise Image Histogram');

subplot(2, 2, 3);
imhist(noisyImageDisplay);  % Histogram of noisy image
title('Noisy Image Histogram');

subplot(2, 2, 4);
imhist(reconstructedImageDisplay);  % Histogram of reconstructed image
title('Reconstructed Original Image Histogram');

difference_image = pixel_wise_comparison(inputImage, reconstructedImage);