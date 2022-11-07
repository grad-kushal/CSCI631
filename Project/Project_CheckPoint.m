
Leaf_Classification("/Users/swetna/Documents/MATLAB/Project_Images/IMG_3158.jpeg")



function Leaf_Classification( fn_in )


%
GET_USER_INPUT = false;
    
    if nargin < 1
        fn_in = fn_in ;
    end
    
    im = im2double( imread( fn_in ) ) ;
    
    im  = im( 1:4:end, 1:4:end, : );
    
%     zoom_figure( );
    
    imagesc( im );
    axis image;
    
  
        %  Get location of leaves from the user.
        fprintf('Click on the Leaves\n');
        beep();
        [rxs,rys] = ginput();


        %  Get location of other pixels from the user.
        fprintf('Click on the NON-Leaves\n');
        beep();
        [bgxs,bgys] = ginput();
   

        
        
    
    %
    %  Get color values 
    rxs = round( rxs );
    rys = round( rys );
    for leaf_idx = 1 : length( rxs )
        fg_color( leaf_idx, 1:3 ) = im( rys(leaf_idx), rxs(leaf_idx), : );
    end
    
    %  Get other background color values.
    bgxs = round( bgxs );
    bgys = round( bgys );
    for background_idx = 1 : length( bgxs )
        bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
    end
    
    disp('break here');
    
    % 
    %  For each input pixel, figure out distance to the leaves colors.
    [im_red, im_grn, im_blu] = imsplit( im );
    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];
    
    
    
    %  For each input pixel, find   distance to the background colors.
    %  If a pixel is closer to the leaf color than to a the other,
    %       classify it as a leaf
    %  else
    %       call it a background pixel.
    %
   
   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    
    b_is_fg = fg_dist < bg_dist;
    
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );
    
   figure, imshow( b_is_fg );
    figure, imagesc( b_is_fg );
   
    

end
