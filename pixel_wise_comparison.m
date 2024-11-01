function difference_image = pixel_wise_comparison(image1, image2)

    % Ensure images are of the same size
    if ~isequal(size(image1), size(image2))
        error('Images must have the same size');
    end

    % Convert images to double precision for accurate calculations
    image1 = double(image1);
    image2 = double(image2);

    % Calculate the pixel-wise difference
    difference_image = abs(image1 - image2);

    % Normalize the difference image (optional)
    difference_image = mat2gray(difference_image);

    % Display the difference image
    imshow(difference_image);
end