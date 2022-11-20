function HW09_Kale_Kushal( )

    close all;

    % Read in the source image.
    im_warped = imread( 'IMG_20221015_TO_RECTIFY_2221.jpg' );

    % Crop the image to focus on only the sign
    im_warped = imcrop(im_warped, [1500, 600, 1000, 1000]);


    % Figure for cropped input image:  
    figure('Position',[ 400  5  1001  792] );
    imagesc( im_warped );
    colormap( gray );
    axis image;


    % Target points
    xs_target_points_to_get_to  = [   0       0     size(im_warped,1)    size(im_warped,1) ];
    ys_target_points_to_get_to  = [   size(im_warped,2)      0      0     size(im_warped,2) ];
    xy_target_points_to_get_to  = [ xs_target_points_to_get_to ;
                                    ys_target_points_to_get_to ;
                                    ones( 1, size(xs_target_points_to_get_to,2) ) ]; 

    
    % Moving points
    xy_source_points_to_move      = [  284   280   730   699 ;
                                       737   164   229   866 ;
                                         1     1     1     1 ];


    %  Form the matlab transformation: This creates a projective transform 
    fit_xform   = fitgeotrans( xy_source_points_to_move(1:2,:).', ...
                               xy_target_points_to_get_to(1:2,:).', ...
                               'projective' );
    
    % Display the tranformation matrix
    disp(fit_xform.T);
   

    %  Warp the image:
    im_unmorphed  = imwarp( im_warped, fit_xform );
    
    
    % Display the image:
    figure('Position',[ 460  5  1001  792 ] );
    imagesc(im_unmorphed);
    colormap( gray );
    hold on;
    axis image;

end



