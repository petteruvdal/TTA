function [re_rotated_predictions, re_rotated_input] = reRotateFunction(X_test, Y_test, R_list, net)

    re_rotated_predictions = cell(size(X_test));
    rotated_y = cell(size(Y_test));

    for i = 1:length(X_test)
        %disp(i);
        x = X_test{i};
        y = Y_test{i};

        predictions_cell = cell(size(R_list));
        rotated_y_cell = cell(size(R_list));

        for j = 1:length(R_list)
            r = R_list{j};

            [rotated_x, rotated_y_curr] = performRotation(x, y, r);
            rotated_x = double(rotated_x);
            rotated_y_cell{j} = rotated_y_curr;
            
            c = clock
            predictions = double(predict(net, rotated_x));
            c = clock

            inverse = r';
            [re_rotated_x, re_rotated_y] = performRotation(rotated_x, predictions, inverse);

            predictions_cell{j} = re_rotated_y;
        end
        
        re_rotated_predictions{i} = predictions_cell;
        rotated_y{i} = rotated_y_cell;
        re_rotated_input{i} = re_rotated_x;
    end
end
