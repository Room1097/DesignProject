function reconstructed_image = reconstructImage(qx_reconstructed, qy_reconstructed, prime)
    % Input:
    % qx_reconstructed, qy_reconstructed - cell arrays containing the reconstructed
    % polynomials q(x)_p(z) and q(y)_p(z) for each pixel value p in [0, 255]
    % prime - finite field prime value for modulo operations

    % Output:
    % reconstructed_image - matrix representing the reconstructed grayscale image

    % Initialize the reconstructed image matrix (assuming a square image for simplicity)
    image_size = 256; % Example size, adjust as needed
    reconstructed_image = zeros(image_size, image_size);

    % Loop over each pixel grayscale value p (0 to 255)
    for p = 0:255
        % Evaluate the polynomial q(x)_p(z) and q(y)_p(z) at each index 1 to np
        qx_poly = qx_reconstructed{p+1};
        qy_poly = qy_reconstructed{p+1};
        
        % Determine the number of points to evaluate for this grayscale value
        np = numel(coeffs(qx_poly));

        for i = 1:np
            % Evaluate q(x)_p and q(y)_p at z = i
            x_coord = mod(subs(qx_poly, i), prime);
            y_coord = mod(subs(qy_poly, i), prime);

            % Assign the grayscale value p to the evaluated coordinates
            if x_coord > 0 && x_coord <= image_size && y_coord > 0 && y_coord <= image_size
                reconstructed_image(x_coord, y_coord) = p;
            end
        end
    end
end
