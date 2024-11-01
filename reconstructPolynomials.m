function [qx_reconstructed, qy_reconstructed] = reconstructPolynomials(t, shadow_images, n, prime)
    % Input:
    % t - threshold number of shadow images needed for reconstruction
    % shadow_images - cell array containing t shadow images (each a 23x23 matrix)
    % n - number of unique values at which the polynomial is evaluated
    % prime - finite field prime value for modulo operations

    % Output:
    % qx_reconstructed, qy_reconstructed - cell arrays containing reconstructed
    % polynomials q(x)_p(z) and q(y)_p(z) for each pixel value p in [0, 255]

    % Initialize reconstructed polynomials
    syms z;
    qx_reconstructed = cell(1, 256);
    qy_reconstructed = cell(1, 256);

    % Loop through each grayscale value p (0 to 255)
    for p = 0:255
        % Initialize polynomial components
        qx_p = 0;
        qy_p = 0;
        
        % Reconstruct the polynomials using Lagrange interpolation
        for i = 1:t
            % Obtain the index from the shadow image to get evaluation points
            eval_point = shadow_images{i}(23, 23); % Last element in each shadow image for z value

            % Initialize the Lagrange basis polynomial
            Lagrange_basis = 1;
            for j = 1:t
                if i ~= j
                    % Calculate the Lagrange basis polynomial term
                    eval_point_j = shadow_images{j}(23, 23);
                    Lagrange_basis = mod(Lagrange_basis * (z - eval_point_j) / (eval_point - eval_point_j), prime);
                end
            end
            
            % Add the term to reconstruct q(x)_p(z) and q(y)_p(z)
            qx_p = mod(qx_p + shadow_images{i}(p+1) * Lagrange_basis, prime);
            qy_p = mod(qy_p + shadow_images{i}(p+2) * Lagrange_basis, prime);  % Assuming q(y) share is stored next to q(x)
        end

        % Store reconstructed polynomials
        qx_reconstructed{p+1} = qx_p;
        % disp(qx_p);
        qy_reconstructed{p+1} = qy_p;
        % disp(qy_p);
    end
end
