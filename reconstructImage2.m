function reconstructed_image = reconstructImage2(qx, qy, np, image_size)
    % Initialize the reconstructed image matrix
    reconstructed_image = zeros(image_size, image_size);
    syms z;

    % Loop over each pixel grayscale value p (0 to 255)
    for p = 0:255
        % Get the reconstructed polynomials for the current grayscale value
        qx_poly = qx{p + 1};
        qy_poly = qy{p + 1};

        % Determine the number of points for the current grayscale level
        num_points = np(p + 1);

        % Loop to evaluate the polynomial q(x)_p and q(y)_p at each point from 1 to np
        for i = 1:num_points
            % Evaluate q(x)_p(z) and q(y)_p(z) at z = i
            x_coord = round(double(subs(qx_poly, z, i)));
            y_coord = round(double(subs(qy_poly, z, i)));

            % Ensure coordinates are within image bounds
            if x_coord > 0 && x_coord <= image_size && y_coord > 0 && y_coord <= image_size
                reconstructed_image(x_coord, y_coord) = p;
            end
        end
    end

    imshow(uint8(reconstructed_image));
    imwrite(uint8(reconstructed_image), 'reconstructed_image.png');
end