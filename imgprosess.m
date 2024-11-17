% Load the grayscale image
img = imread('baboon.tif');
% img = rgb2gray(img);  % Ensure the image is grayscale if not already
[rows, cols] = size(img);

% Step 1: Calculate the original histogram
original_hist = imhist(img);

% Step 2: Flatten the histogram by clipping peaks
threshold = mean(original_hist);  % Set a threshold for peak clipping
clipped_hist = min(original_hist, threshold);  % Clip peaks above the threshold

% Calculate excess pixels above the threshold and redistribute uniformly
excess_pixels = original_hist - clipped_hist;
excess_pixels(excess_pixels < 0) = 0;  % Ensure non-negative values
excess_total = sum(excess_pixels);  % Total pixels to redistribute
redistribution = excess_total / length(clipped_hist);  % Amount to add to each bin

% Add redistributed excess to create the flattened histogram
flattened_hist = clipped_hist + redistribution;

% Step 3: Generate CDFs for both original and flattened histograms
original_cdf = cumsum(original_hist) / sum(original_hist);  % Original CDF
flattened_cdf = cumsum(flattened_hist) / sum(flattened_hist);  % Flattened CDF

% Step 4: Create lookup table for the flattened transformation
lookup_table_flatten = uint8(255 * flattened_cdf);  % Scale CDF to [0, 255]
flattened_img = lookup_table_flatten(double(img) + 1);  % Map original image using flattened CDF

% Step 5: Reverse the Transformation (using the original CDF)
% Create an inverse lookup table to map flattened image back to original
inverse_lookup_table = zeros(256, 1, 'uint8');
for i = 1:256
    [~, idx] = min(abs(flattened_cdf(i) - original_cdf));  % Find closest match
    inverse_lookup_table(i) = idx - 1;  % Store the original intensity level
end

% Apply the inverse mapping to the flattened image to approximate the original
recovered_img = inverse_lookup_table(flattened_img + 1);

% Display Results
figure;
subplot(3,2,1); imshow(img); title('Original Image');
subplot(3,2,2); bar(original_hist); title('Original Histogram');
subplot(3,2,3); imshow(flattened_img); title('Flattened Image');
subplot(3,2,4); bar(flattened_hist); title('Flattened Histogram');
subplot(3,2,5); imshow(recovered_img); title('Recovered Image');
subplot(3,2,6); bar(imhist(recovered_img)); title('Recovered Histogram');
