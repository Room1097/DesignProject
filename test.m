% img = imread("shadow_image_1.png");
% imshow(img);
% [Spx, Spy, np] = find_pixel_coordinates(img);
% val = img(23,23);
% figure
% bar(0:255, np);
% xlabel('Grayscale Value');
% ylabel('Frequency');
% title('Pixel Value Frequency Distribution');
% [Qx, Qy] = recover_polynomials(shadow_images);
% [Qx, Qy] = reconstructPolynomials(t, shadow_images, n, prime);
% disp(Qy);
% disp(Qx);
% syms z;
% i = 15;
% j = 254;
% qxj = double(subs(qx{j+1}, z, i));

% reconstructed_image = reconstruct_image(Spx, Spy);
% 
img = imread('input_image8.png');
% [Spx, Spy, np] = find_pixel_coordinates(img);
% reconstructed_image = reconstruct_image(Spx, Spy);
% Display the reconstructed image
% imshow(uint8(reconstructed_image));
% Save the reconstructed image as a .tif file
% imwrite(uint8(reconstructed_image), 'reconstructed_image.png');
% 
image2 = imread('reconstructed_image.png');
disp(img);
disp(image2);
% 
difference_image = pixel_wise_comparison(img, image2);
% 
% [Spx, Spy, np] = find_pixel_coordinates(difference_image);
% figure
% bar(0:255, np);
% xlabel('Grayscale Value');
% ylabel('Frequency');
% title('Pixel Value Frequency Distribution');






% for i = 1:5
%     imshow(shadow_images{i});
%     title(['Shadow Image ', num2str(i)]);
%     % Extract the image data as a matrix
%     image_data = shadow_images{i};
%     % Display the image data as an array
%     disp(image_data);
%     % pause; % Pause to view each image and array
% end

   % image_data = imread("input_image8.png");
   % % Display the image data as an array
   % disp(image_data);


% [Qx, Qy] = reconstructPolynomials(t,shadow_images);
% 
% for i = 1:length(Qy)
%     disp(['Qx(', num2str(i), '):']);
%     disp(Qx{i});
%     disp(['Qy(', num2str(i), '):']);
%     disp(Qy{i});
% end
% 
% reconstructed_image = reconstructImage2(Qx,Qy,np,8);