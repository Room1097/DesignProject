%main script as an command centre

% Read the grayscale image
img = imread("input_image8.png");
% img = double(img);



[Spx, Spy, np] = find_pixel_coordinates(img);

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

image1 = imread('input_image8.png');
image2 = imread('reconstructed_image.png');

difference_image = pixel_wise_comparison(image1, image2);
%test
diary off; % Stop recording