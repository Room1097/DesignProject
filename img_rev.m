% Step 1: Load and preprocess the image
img = imread('baboon.tif');
img2 = histeq(img,256);

% img = rgb2gray(img);  % Ensure the image is grayscale
[rows, cols] = size(img);

% Compute the original histogram and CDF
original_hist = imhist(img);
original_cdf = cumsum(original_hist) / sum(original_hist);

% Step 2: Apply Histogram Flattening (as before)
threshold = mean(original_hist);  % Set threshold (can be adjusted as needed)
clipped_hist = min(original_hist, threshold);  % Cap histogram counts at the threshold
excess_pixels = original_hist - clipped_hist;  % Calculate excess above the threshold
excess_total = sum(excess_pixels);  % Total excess pixels to redistribute
redistribution = excess_total / length(clipped_hist);  % Redistribute uniformly
flattened_hist = clipped_hist + redistribution;  % Flattened histogram after redistribution
flattened_cdf = cumsum(flattened_hist) / sum(flattened_hist);  % Flattened CDF

% Map the original image using the new flattened CDF
lookup_table_flatten = uint8(255 * flattened_cdf);  % Scale flattened CDF to [0, 255]
flattened_img = lookup_table_flatten(double(img) + 1);  % Map pixels using the lookup table

% Step 3: Reverse the Transformation
% Create an inverse lookup table based on the original CDF
% Find the nearest match in the original CDF for each value in the flattened CDF
inverse_lookup_table = zeros(256, 1, 'uint8');
for i = 1:256
    [~, idx] = min(abs(flattened_cdf(i) - original_cdf));  % Find closest match
    inverse_lookup_table(i) = idx - 1;  % Store the original intensity
end

% Apply the inverse mapping to get the original image back
recovered_img = inverse_lookup_table(flattened_img + 1);

% Display Results
subplot(2,3,1); imshow(img); title('Original Image');
subplot(2,3,2); imshow(flattened_img); title('Flattened Image');
subplot(2,3,3); imshow(recovered_img); title('Recovered Image');
subplot(2,3,4); bar(original_hist); title('Original Histogram');
subplot(2,3,5); bar(flattened_hist); title('Flattened Histogram');
subplot(2,3,6); bar(imhist(recovered_img)); title('Recovered Histogram');
