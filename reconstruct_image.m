function reconstructed_image = reconstruct_image(Spx, Spy)
    % Determine the image size from the maximum coordinates
    max_x = 0;
    max_y = 0;
    for p = 1:256
        if ~isempty(Spx{p})
            max_x = max(max_x, max(Spx{p}));
        end
        if ~isempty(Spy{p})
            max_y = max(max_y, max(Spy{p}));
        end
    end

    % Create an empty image matrix
    reconstructed_image = zeros(max_x, max_y);

    % Iterate through each grayscale level
    for p = 1:256
        x_coords = Spx{p};
        y_coords = Spy{p};

        % Assign pixel values to the reconstructed image
        for i = 1:length(x_coords)
            x = x_coords(i);
            y = y_coords(i);
            reconstructed_image(x, y) = p - 1; % Adjust for 0-based indexing
        end
    end
end