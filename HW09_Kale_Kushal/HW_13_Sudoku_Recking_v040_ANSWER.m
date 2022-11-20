function HW_13_Sudoku_Recking_v040_ANSWER( )

    % Read in the source image.
    im_warped = imread( 'Sudoku_Morphed_v040.jpg' );

    % Figure for input image:  
    figure('Position',[ 400  5  1001  792] );
    imagesc( im_warped );
    colormap( gray );
    axis image;

    xs_target_points_to_get_to  = [   230       233     1143    1140 ] - (230-1);
    ys_target_points_to_get_to  = [   980       170      176     988 ] - (170-1);


    % Sub-sample by a factor of two:
    xs_target_points_to_get_to  = xs_target_points_to_get_to / 2;
    ys_target_points_to_get_to  = ys_target_points_to_get_to / 2;
    xy_target_points_to_get_to  = [ xs_target_points_to_get_to ;
                                    ys_target_points_to_get_to ;
                                    ones( 1, size(xs_target_points_to_get_to,2) ) ]; 
    
    % These are the original corner points
    xy_source_points_to_move      = [  119   362   605   556 ;
                                       491   138   204   611 ;
                                         1     1     1     1 ];

    %
    %  Form the matlab transformation:
    %
    fit_xform   = fitgeotrans( xy_source_points_to_move(1:2,:).', ...
                               xy_target_points_to_get_to(1:2,:).', ...
                               'projective' );
    
    % **********************************************************
    %
    % Print out what the Matlab version of the matrix is.
    %
    % Look at it, and see what it is doing:
    matlab_xform = fit_xform.T

    %  Warp the image:
    im_unmorphed  = imwarp( im_warped, fit_xform );
    
    
    
    % Display the image:
    figure('Position',[ 460  5  1001  792 ] );
    imagesc( im_unmorphed );
    colormap( gray );
    hold on;
    axis image;

end



