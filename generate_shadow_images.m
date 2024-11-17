function shadow_images = generate_shadow_images(qx, qy, n, max_np, ~)
    % Input:
    % qx, qy - cell arrays containing q(x)_p(z) and q(y)_p(z) for each pixel value p in [0, 255]
    % n - number of shadow images to generate
    % max_np - maximum number of points (np) used for polynomial evaluations
    % prime - prime number for modulus in finite field

    syms z; % Declare z as a symbolic variable

    shadow_images = cell(n, 1);

    % Generate each shadow image
    for i = 1 + max_np:n + max_np
        shadow_images{i} = zeros(23, 23); % Initialize a 23x23 matrix
        row = 1;
        col = 1;

        % Iterate over each grayscale value p (0 to 255)
        for j = 0:255
            % Evaluate q(x)_p(z) and q(y)_p(z) at z = i within the finite field
            qxj = vpa(subs(qx{j+1}, z, i));
            qyj = vpa(subs(qy{j+1}, z, i));

            % Display the evaluated results for debugging
            fprintf('Evaluating polynomial for p=%d at z=%d, row=%d, col=%d\n', j, i, row, col);
            disp(qxj);
            disp(qyj);

            % Store the finite field results in the shadow image matrix
            shadow_images{i - max_np}(row, col) = qxj;
            col = mod(col, 23) + 1;

            if col == 1
                row = row + 1;
            end

            shadow_images{i - max_np}(row, col) = qyj;
            col = mod(col, 23) + 1;

            % Move to the next row if we reach the end of the current row
            if col == 1
                row = row + 1;
            end
        end

        % Store the evaluation point in the last element for reference
        shadow_images{i - max_np}(23, 23) = i;

        % Save the shadow image as an actual image file
        % Normalize to fit in an 8-bit image range if within [0, 255]
        shadow_img_normalized = uint8(mod(shadow_images{i - max_np}, 256));
        imwrite(shadow_img_normalized, sprintf('shadow_image_%d.png', i - max_np));
    end
end
