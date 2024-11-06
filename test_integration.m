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



%main script as an command centre

% Read the grayscale image
img = imread("input_image8.png");
% img = double(img);

if size(img, 3) == 3
    img = rgb2gray(img);  % Convert RGB to grayscale
end

disp('Original Image:');
disp(img);

noise = uint8(randi([0, 255], 8, 8));

noisyImage = add_noise(inputImage, noise);
disp('Noisy Image (after adding noise to original):');
for i = 1:8
    disp(noisyImage(i, :));  % Display the entire i-th row of the noisy image
end


[Spx, Spy, np] = find_pixel_coordinates(noisyImage);

bar(0:255, np);
xlabel('Grayscale Value');
ylabel('Frequency');
title('Pixel Value Frequency Distribution');

% Find the grayscale level with the maximum frequency
[max_np, grayscale_max] = max(np);
max_freq_grayscale = grayscale_max - 1; % Adjust for 0-based indexing

n = max_np + 2;   % Total number of shares to generate
t = max_np + 1;   % Threshold number of shares needed for reconstruction


% zero_pixel_x_coords = Spx{106};
% zero_pixel_y_coords = Spy{106};
% lenght = length(zero_pixel_x_coords);

% Print the coordinates
% fprintf('Coordinates of pixels with grayscale value 0:\n');
% for i = 1:length(zero_pixel_x_coords)
%     fprintf('(%d, %d)\n', zero_pixel_x_coords(i), zero_pixel_y_coords(i));
% end

% reconstructed_image = reconstruct_image(Spx, Spy);

% Display the reconstructed image
%imshow(uint8(reconstructed_image));
% Save the reconstructed image as a .tif file
%imwrite(uint8(reconstructed_image), 'reconstructed_image.tif');
diary('output.txt'); % Start recording output to a file

prime = nextprime(n + max_np);

[qx, qy] = construct_lagrange_polynomials(Spx, Spy, t, n, prime);

shadow_images = generate_shadow_images(qx, qy, n, max_np, prime);

% for i = 1:n
%     filename = sprintf('shadow_image_%d.png', i);
%     imwrite(uint8(shadow_images{i}), filename);
% end

 [Qx, Qy] = reconstructPolynomials(t,shadow_images);
% [Qx, Qy] = reconstructPolynomials(t, shadow_images, n, prime);
for i = 1:256
    disp(['Qx(', num2str(i), '):']);
    disp(Qx{i});
    disp(['Qy(', num2str(i), '):']);
    disp(Qy{i});
end

reconstructed_image = reconstructImage2(Qx,Qy,np,8);
reconstructed_noise_less_image = remove_noise(noisyImage, noise);

image1 = imread('input_image8.png');
image2 = imread('reconstructed_image.png');

difference_image = pixel_wise_comparison(image1, reconstructed_noise_less_image);
%test
diary off; % Stop recording