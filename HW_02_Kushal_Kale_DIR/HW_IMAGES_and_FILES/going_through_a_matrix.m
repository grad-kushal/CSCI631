
function going_through_a_matrix()

    my_mat = [magic(3) magic(3)+10] 		% Create a 3x6 mat.

    % Then can go through the elements in the matrix:
    for row = 1 : size( my_mat, 1 )
	    for col = 1 : size( my_mat, 2 )
		    fprintf( '%6.3f,  ', my_mat(row,col) );
            end
            fprintf('\n');
    end

end

