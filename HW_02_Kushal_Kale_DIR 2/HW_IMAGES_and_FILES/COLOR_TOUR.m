function COLOR_TOUR()

% Create a matrix of colors, to display:
color_values    = [     0   0   0;
                        0.5 0.5 0.5;
                        1   1   1;
                        1   0   0;
                        0   1   0;
                        0   0   1;
                        1   0   1;
                        1   1   0;
                        0   1   1;
                        1   0.80 0.80 ;
                        1   0.60 0.00 ;
                        0.5 0.30 0.00 ];

% Create a "cell array" of color names:
color_names     = {     'black', ...
                        'gray', ...
                        'white', ...
                        'red', ...
                        'green', ...
                        'blue', ...
                        'magenta', ...
                        'yellow', ...
                        'cyan', ...
                        'pink', ...
                        'orange', ...
                        'brown'  };
                   
        
                    
        %
        %  Figure out the number of colors in the list.
        %  size( variable, 1 )  returns the number of rows.
        %
        n_colors = size(color_values,1);
        
        %
        %  Create a figure to display the image in.  
        %  Make it big.
        %
        fig = figure('Position', [200 200 512 512] );
        
        for color_index = 1 : n_colors 
            im_new    = zeros( 128, 128, 3 );
            for plane_index = 1 : 3
                im_new(:,:,plane_index) = color_values( color_index, plane_index );
            end
            
            %
            %  DISPLAY THE IMAGE FORMED:
            %
            imagesc( im_new );
            title( color_names{color_index}, 'FontSize', 32 );
            
            posit       = get( gcf(), 'Position' );     %  GET THE FIGURE POSITION:
            posit(3)    = 512;                          %  Change dimensions to 512x512.
            posit(4)    = 512;
            set( gcf, 'Position', posit );              %  Actually make the dimensions change.
            
            pause(0.75);                                       %  Wait for use input...
        end

end


