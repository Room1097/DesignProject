function [qx, qy] = recover_polynomials(shadow_images)
    % Initialize the output polynomials
    qx = cell(256, 1);
    qy = cell(256, 1);

    % Symbolic variable for polynomial calculations
    syms z;

    for row = 0:22
        for col = 0:22
            if mod(row, 2) == 0
                index = (row * 23 + col) / 2 + 1;
            else
                index = (row * 23 + col + 1) / 2 + 1;
            end

            if mod(col, 2) == 0
                qx{index} = 0;
            else
                qy{index} = 0;
            end

            for i = 1:length(shadow_images)
                temp = 1;
                for j = 1:length(shadow_images)
                    if i ~= j
                        temp = temp * (z - shadow_images{j}(23, 23)) / (shadow_images{i}(23, 23) - shadow_images{j}(23, 23));
                    end
                end
                temp = temp * shadow_images{i}(row + 1, col + 1);

                if mod(col, 2) == 0
                    qx{index} = qx{index} + temp;
                else
                    qy{index} = qy{index} + temp;
                end
            end

            if row == 22 && col == 6
                break;
            end
        end
    end
end