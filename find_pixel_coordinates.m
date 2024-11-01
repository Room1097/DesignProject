function [Spx, Spy, freq] = find_pixel_coordinates(I)
    % Initialize the sets of x and y coordinates for each pixel value
    Spx = cell(256, 1);
    Spy = cell(256, 1);
    freq = zeros(256, 1);

    % Iterate through each pixel in the image
    [m, n] = size(I);
    for i = 1:m
        for j = 1:n
            p = I(i, j) + 1; % Adjust for 1-based indexing
            Spx{p} = [Spx{p}, i];
            Spy{p} = [Spy{p}, j];
            freq(p) = freq(p) + 1;
        end
    end
end