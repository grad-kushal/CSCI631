function HW06_Kale_Kushal()
    addpath( '../TEST_IMAGES' );
    %addpath( '../../TEST_IMAGES' );
    %addpath( 'TEST_IMAGES' );
    gf = fspecial('gaussian',5,2);

    cf = [ 8  4  3 ;
            6  2  3 ;
            1  9  4 ] ;

    cf2 = [-1  -2  -1 ;
            0  0  0  ;
            1  2  1  ] / 8;

    counter = 0;

    mat = ceil( rand(5,7)*9);
%     for var = mat
%         fprintf( '%d, ', var );
%          fprintf('\n');
%         counter = counter + 1;
%         disp(counter)
%     end
% %  
%     a = magic(5)
%     disp(a(2, 4));
% %     disp(pwd);
%     a = "TEST_IMAGES/";
%     file_list = dir(a + "*.jpg");
%     
%         im = rgb2gray( im2double(imread( "gg.jpeg" ) ));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Gaussian    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        og = imfilter(cf, cf2);
%         cust = HW06_Kale_Kushal_Filter(im, gf);
        disp(og)
%         figure;
%         imshow(og);
%         figure;
%         imshow(cust);
%         diff = imabsdiff(og, cust);
%         figure;
%         imshow(diff);
end

function output_image = HW06_Kale_Kushal_Filter( input_image, given_filter )
    output              = zeros( size(input_image) );   % Make the output the same SIZE by default.
    
    image_dimensions    = size( input_image );                % Get the image dimentons
    filter_dimensions         = size( given_filter );         % Get the filter size ()

    margin = floor(filter_dimensions(1)/2);                   % Either dimention of the filter can be used to get the margin as the filter is symmetric.
    for row = (1+margin) : (image_dimensions(1)-margin)       % Iterate till the last valid row.
        for col = (1+margin) : (image_dimensions(2)-margin)   % Iterate till the last valid column.
            output_pixel_value = Calculate_Output_Pixel_Value(row, col, input_image, given_filter, margin);
            output(row,col) = output_pixel_value;       % Set the output value
        end
    end
    output_image = output;
end

function op_value = Calculate_Output_Pixel_Value(row, col, input_image, given_filter, margin)
%     disp(size( given_filter ));
%     disp(size(input_image));
    filter_dimensions         = size( given_filter ); 
    sum = 0;
    image_row_index = row - margin;    

    for i = 1 : filter_dimensions(1)
        image_column_index = col - margin;
        for j = 1 : filter_dimensions(2)
            sum = sum + input_image(image_row_index, image_column_index) * given_filter(i, j);  % Calculate the value for this pixel
            image_column_index = image_column_index + 1;
%             fprintf("r: " + image_row_index + "\t c: " + image_column_index + "\n");
        end
        image_row_index = image_row_index + 1;
    end
    op_value = sum;
end