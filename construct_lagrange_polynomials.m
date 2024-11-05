function [qxp, qyp] = construct_lagrange_polynomials(Spx, Spy, t, ~, prime)
    % Input:
    % t - threshold value
    % Spx, Spy - cell arrays containing x and y coordinate sets for pixel values [0,255]
    % n - number of shadow images
    % prime - a prime number greater than n + max(np)

    % Output:
    % qxp, qyp - cell arrays of symbolic Lagrange polynomials for each pixel value p
    
    % Initialize symbolic polynomials for x and y coordinates
    z = sym('z');
    qxp = cell(1, 256);
    qyp = cell(1, 256);
    
    for p = 0:255
        % Get the number of coordinates for the current pixel value
        np = length(Spx{p+1});
        
        % Generate a random polynomial rp(z) of degree (t-1) - np in the finite field
        rp = poly2sym(randi([0, prime-1], 1, t - np), z);
        fprintf('the random polynomial for p%d ',p);
        disp(rp);
        
        % Construct q(x)_p(z) and q(y)_p(z) polynomials
        qx_sum = 0;
        qy_sum = 0;

        % Calculate the Lagrange polynomial for each point in Spx and Spy
        for i = 1:np
            % Lagrange basis polynomial for each xi in Spx{p+1}
            li_x = 1;
            li_y = 1;
            for j = 1:np
                if i ~= j
                    li_x = li_x * ((z - j) / (i - j));
                    li_y = li_y * ((z - j) / (i - j));
                end
            end
            qx_sum = qx_sum + Spx{p+1}(i) * li_x;
            qy_sum = qy_sum + Spy{p+1}(i) * li_y;
        end
        
        % Multiply rp(z) by product term and add Lagrange terms
        qxp{p+1} = rp * prod(z - (1:np)) + qx_sum;
        qyp{p+1} = rp * prod(z - (1:np)) + qy_sum;
        fprintf('the qy for p%d ',p);
        disp(qyp{p+1});
        fprintf('the qx for p%d ',p);
        disp(qxp{p+1});
    end
end
