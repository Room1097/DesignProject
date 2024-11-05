function [qx_reconstructed, qy_reconstructed] = reconstructPolynomials(t, shadow_images, ~, ~)
    % Input:
    % t - threshold number of shadow images needed for reconstruction
    % shadow_images - cell array containing t shadow images (each a 23x23 matrix)
    % n - number of unique values at which the polynomial is evaluated
    % prime - finite field prime value for modulo operations
    % Output:
    % qx_reconstructed, qy_reconstructed - cell arrays containing reconstructed
    % polynomials q(x)_p(z) and q(y)_p(z) for each pixel value p in [0, 255]
    
    syms z;
    qx_reconstructed = cell(1, 270);  % To store q(x) for each pixel value
    qy_reconstructed = cell(1, 270);  % To store q(y) for each pixel value

    % Initialize the reconstructed polynomials to zero
    for p = 1:256
        qx_reconstructed{p} = 0;
        qy_reconstructed{p} = 0;
    end
    % index = 0;
    % Loop through each pixel position in the shadow images
    for row = 0:22
        for col = 0:22
            if mod(row, 2) == 0  % Even row
                index = floor(row * 23 / 2) + floor(col / 2) + 1;
                if mod(col, 2) == 0  % Even column
                    coord = 'x';  % Assign to qx
                    %index = index + 1;
                else
                    coord = 'y';  % Assign to qy
                end
            else  % Odd row
                index = floor(row * 23 / 2) + floor((col + 1) / 2) + 1;
                if mod(col, 2) == 0  % Even column
                    coord = 'y';  % Assign to qy
                    %index = index + 1;
                else
                    coord = 'x';  % Assign to qx
                end
            end
            
            
            
            % Calculate polynomial coefficients
            for i = 1:t
                temp = 1;  % Reset temp for each shadow image
                
                for j = 1:t
                    if i ~= j
                        % Calculate the term for Lagrange interpolation
                        temp = temp * (z - shadow_images{j}(23, 23)) / (shadow_images{i}(23, 23) - shadow_images{j}(23, 23));
                    end
                end
                
                % Multiply by the current pixel value
                temp = temp * shadow_images{i}(row + 1, col + 1);  % Convert to 1-based index
                
                % Accumulate the temporary value into the appropriate polynomial
                if coord == 'x'
                    qx_reconstructed{index } = qx_reconstructed{index } + temp;
                else
                    qy_reconstructed{index } = qy_reconstructed{index } + temp;
                end
            end
            
            % % Check for exit condition
            % if row == 22 && col == 6
            %     break;  % Exit the function if the condition is met
            % end
        end
    end
end
