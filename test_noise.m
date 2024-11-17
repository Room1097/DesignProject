% Function to add noise to an 8x8 input image using modular arithmetic
function noisyImage = add_noise(inputImage, noise)
    % Initialize noisy image
    noisyImage = zeros(32, 32, 'uint8');

    % Add noise to each pixel using modular arithmetic
    for i = 1:32
        for j = 1:32
            % Step 1: Add the original image pixel and the noise
            sumPixel = int32(inputImage(i, j)) + int32(noise(i, j));  % Use int32 for addition
            % Step 2: Apply mod 256 to ensure the result stays within [0, 255]
            noisyImage(i, j) = uint8(mod(sumPixel, 256));
            % Debugging step
            fprintf('Adding: %d + %d = %d, After Modulo 256: %d\n', inputImage(i, j), noise(i, j), sumPixel, noisyImage(i, j));
        end
    end
end

% Function to remove noise from an 8x8 noisy image to reconstruct the original image
function reconstructedImage = remove_noise(noisyImage, noise)
    reconstructedImage = zeros(32, 32, 'uint8');

    % Remove noise from each pixel using modular subtraction
    for i = 1:32
        for j = 1:32
            % Step 1: Subtract the noise from the noisy image pixel
            diffPixel = int32(noisyImage(i, j)) - int32(noise(i, j));
            % Step 2: Apply mod 256 and cast back to uint8
            reconstructedImage(i, j) = uint8(mod(diffPixel + 256, 256));
            % Debugging step
            fprintf('Subtracting: %d - %d = %d, After Modulo 256: %d\n', noisyImage(i, j), noise(i, j), diffPixel, reconstructedImage(i, j));
        end
    end
end

% Main script
inputImage = imread('input_image32.png');  % Replace with 'input_image8.png'
if size(inputImage, 3) == 3
    inputImage = rgb2gray(inputImage);  % Convert to grayscale if needed
end

% Display original image for debugging
disp('Original Image:');
disp(inputImage);

% Generate 8x8 random noise
noise = uint8(randi([0, 255], 32, 32));
disp('Generated Noise Image:');
disp(noise);

% Add noise to input image
noisyImage = add_noise(inputImage, noise);
disp('Noisy Image (after adding noise):');
disp(noisyImage);

% Reconstruct the original image
reconstructedImage = remove_noise(noisyImage, noise);
disp('Reconstructed Image:');
disp(reconstructedImage);

% Convert images to [0, 1] for display
inputImageDisplay = im2double(inputImage);
noiseDisplay = double(noise) / 255;
noisyImageDisplay = double(noisyImage) / 255;
reconstructedImageDisplay = double(reconstructedImage) / 255;

% Display images
figure;
subplot(2, 2, 1);
imshow(inputImageDisplay);
title('Original Image');
subplot(2, 2, 2);
imshow(noiseDisplay);
title('Generated Noise Image');
subplot(2, 2, 3);
imshow(noisyImageDisplay);
title('Noisy Image (Original + Noise)');
subplot(2, 2, 4);
imshow(reconstructedImageDisplay);
title('Reconstructed Original Image');

% Display histograms
figure;
subplot(2, 2, 1);
imhist(inputImageDisplay);
title('Original Image Histogram');
subplot(2, 2, 2);
imhist(noiseDisplay);
title('Noise Image Histogram');
subplot(2, 2, 3);
imhist(noisyImageDisplay);
title('Noisy Image Histogram');
subplot(2, 2, 4);
imhist(reconstructedImageDisplay);
title('Reconstructed Image Histogram');

% Optional: Define and display pixel-wise difference if not defined elsewhere
difference_image = abs(int32(inputImage) - int32(reconstructedImage));
figure;
imshow(difference_image, []);
title('Difference Image');
