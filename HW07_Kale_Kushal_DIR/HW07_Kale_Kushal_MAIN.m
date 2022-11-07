function HW07_Kale_Kushal_MAIN()
    close all;
    path = "ZIP_FILE_OF_IMAGES_for_SEMESTER_2221/";
    images = ["Img431_SCAN275__Secret_Mess.jpg", "Img431_SCAN285__Secret_Mess.jpg","Img431_SCAN283__Secret_Mess.jpg","Img431_SCAN284__Secret_Mess.jpg","Img431_Scan290__Secret_Mess_Exam_Hints.jpg",];
    
    for i = 1:length(images)
        HW07_Kale_Kushal_Cluster_Colors( path + images(i));
        Junk_Kmeans_Example(path + images(i));
    end
    
    HW07_Kale_Kushal_FIND_RASPBERRIES("ZIP_FILE_OF_IMAGES_for_SEMESTER_2221/Img431_Example__Raspberry_Image.jpg");
    HW07_Kale_Kushal_FIND_ORANGES("ZIP_FILE_OF_IMAGES_for_SEMESTER_2221/Orange_Tree_Image_3305.jpg");
end

function HW07_Kale_Kushal_FIND_ORANGES( fn_in )

GET_USER_INPUT = true;
    
    if nargin < 1
        fn_in = 'Img_Example__Raspberry_Image.jpg';
    end
    
    im = im2double( imread( fn_in ) ) ;
    
    im  = im( 1:4:end, 1:4:end, : );
    
    imagesc( im );
    axis image;
    
    if ( GET_USER_INPUT )
        fprintf('Click on the oranges\n');
        beep();
        [rxs,rys] = ginput();

        fprintf('Click on the NON-oranges\n');
        beep();
        [bgxs,bgys] = ginput();

        save temp_matrix.mat rxs rys bgxs bgys;
    end
    
    %
    %  Get color values -- samples - of the raspberries.
    rxs = round( rxs );
    rys = round( rys );
    for berry_idx = 1 : length( rxs )
        fg_color( berry_idx, 1:3 ) = im( rys(berry_idx), rxs(berry_idx), : );
    end
    
    %  Get other background color values.
    bgxs = round( bgxs );
    bgys = round( bgys );
    for background_idx = 1 : length( bgxs )
        bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
    end
    
    disp('break here');
    
    % 
    %  For each input pixel, figure out distance to the raspberry colors.
    [im_red, im_grn, im_blu] = imsplit( im );
    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];
   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    
    b_is_fg = fg_dist < bg_dist;
    
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );
    
    imagesc( b_is_fg );
    

end

function HW07_Kale_Kushal_FIND_RASPBERRIES( fn_in )

GET_USER_INPUT = true;
    
    if nargin < 1
        fn_in = 'Img_Example__Raspberry_Image.jpg';
    end
    
    im = im2double( imread( fn_in ) ) ;
    
    im  = im( 1:4:end, 1:4:end, : );
    
    imagesc( im );
    axis image;
    
    if ( GET_USER_INPUT )
        fprintf('Click on the raspberries\n');
        beep();
        [rxs,rys] = ginput();

        fprintf('Click on the NON-raspberries\n');
        beep();
        [bgxs,bgys] = ginput();

        save temp_matrix.mat rxs rys bgxs bgys;
    end
    
    %
    %  Get color values -- samples - of the raspberries.
    rxs = round( rxs );
    rys = round( rys );
    for berry_idx = 1 : length( rxs )
        fg_color( berry_idx, 1:3 ) = im( rys(berry_idx), rxs(berry_idx), : );
    end
    
    %  Get other background color values.
    bgxs = round( bgxs );
    bgys = round( bgys );
    for background_idx = 1 : length( bgxs )
        bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
    end
    
    disp('break here');
    
    % 
    %  For each input pixel, figure out distance to the raspberry colors.
    [im_red, im_grn, im_blu] = imsplit( im );
    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];
   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    
    b_is_fg = fg_dist < bg_dist;
    
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );
    
    imagesc( b_is_fg );
    

end

function HW07_Kale_Kushal_Cluster_Colors(imagefile)
    

    im = imread(imagefile);
    imgray = rgb2gray(im);
    imd = im2double(im);
    imdr = imd(:, :, 1);
    imdg = imd(:, :, 2);
    imdb = imd(:, :, 3);
    imlab = rgb2lab(imd);

    t = graythresh(imlab(:, :, 1));

    di = imerode(imlab(:, :, 1), strel('disk', 10));

    o = imerode(1 - di, strel('line', 3, 85));
    figure;
    imshow(o);
    s = split(imagefile, "/");
    s1 = split(s(2), ".");
    disp(s);
    imwrite(o, "output_images/" + s1(1), 'jpg');

% 
%     lums        = imlab(:,:,1);
%     aStr        = imlab(:,:,2);
%     bStr        = imlab(:,:,3);
%     dims        = size( imlab );
%     disp(dims)

    aStrbStr = imlab(:,:,2:3);
    aStrbStrSingle = im2single(1-aStrbStr);
    pixel_labels = imsegkmeans(aStrbStrSingle,5,NumAttempts=3);

    B2 = labeloverlay(im,pixel_labels);
%     figure;
%     imshow(B2)
%     title("Labeled Image a*b*")

    for j = 2:5
        mask = pixel_labels == j;
        cluster = imgray.*uint8(mask);
        t = graythresh(cluster);
        cluster = imbinarize(cluster);
        cluster = imdilate(cluster, strel('line', 4, 85));
        figure;
        imshow(cluster);
        imwrite(cluster, "output_images/" + s(2) + "_cluster_" + j, "jpg");
    end
end

%     [L,Centers] = imsegkmeans(imresize(im, 0.5),4);
%     B = labeloverlay(imresize(im, 0.5),L);
%     imshow(B)
%     title("Labeled Image")
%     disp(Centers);
   

function Junk_Kmeans_Example( fn_in )

    if ( nargin < 1 )
        fn_in = 'Img431_Scan291__Secret_Mess_Exam_Hints__300dpi.jpg';
    end
    
    im = im2double( imread( fn_in ));

    im = im( 2:2:end, 2:2:end, : );
    
    im_red  = im( :, :, 1 );
    im_grn  = im( :, :, 2 );
    im_blu  = im( :, :, 3 );
    
    data = [ im_red(:) , im_grn(:) , im_blu(:) ];
    
    % Why would Dr. K use these colors to start with??
    Seed_Pts.Color_Starting_Point = [ ...
       0.0000 0.0000 0.0000 ;   % Black
       1.0000 0.0000 0.0000 ;   % Red
       0.0000 0.9000 0.0000 ;   % Green
       0.0000 0.0000 1.0000 ;   % Blue
       1.0000 0.0000 1.0000 ;   % Magenta
       0.2000 0.4000 0.4000 ;   % Cyan
       1.0000 1.0000 0.0000 ;   % Yellow
       1.0000 1.0000 1.0000 ;   % White
       0.7000 0.7000 0.0000 ;   % Brown -- Dark Yellow
       0.7000 0.4000 0.0000 ;   % Pinkish or maybe orangish
       0.4000 0.4000 0.4000 ;   % Dark gray
       0.8000 0.8000 0.8000 ;   % Light gray
    ];
    Seed_Pts.Color_name = { 
        'Black', ...
        'Red', ...
        'Green', ...
        'Blue', ...
        'Magenta', ...
        'Cyan', ...
        'Yellow', ...
        'White', ...
        'Brown', ...
        'Pinkish', ...
        'Dark Gray', ...
        'Light Gray' };
    
    % Check for stupid mistakes:
    %
    % Assertions are checked once, and then ignored later.
    % They are used for good code development, and checks when debugging.
    %
    % The released code ignores these.
    %
    assert( length( Seed_Pts.Color_Starting_Point ) == length( Seed_Pts.Color_name ) );
    
    n_seeds     = size( Seed_Pts.Color_Starting_Point, 1 );

    % Lengths returns the longest dimension of an array, so this would work too,
    % as long as there are more then 3 seed points:
    n_seeds     = length( Seed_Pts.Color_Starting_Point );

    
    % Time the process of running kmeans:
    tic();
    [cluster_id, kmeans_center_found] = kmeans( data, n_seeds, 'start', Seed_Pts.Color_Starting_Point );
    kmeans_time = toc();
    
    fprintf('K Means Centers found:\n');
    fprintf(' [ %5.3f, %5.3f, %5.3f ]\n', kmeans_center_found.' );
    
    fprintf('K Means took %4.2f seconds\n\n', kmeans_time );
    
    %
    %  Convert the results of k-means into an image:
    % 
    image_by_id     = reshape( cluster_id, size(im,1), size(im,2) );
    
    
    % Build my own custom colormap:
    my_cmap = kmeans_center_found;
    
    % zoom_figure();
    figure('Position', [10 10 1400 1200] );
    imagesc( image_by_id );
    axis image;
    colormap( my_cmap );
    colorbar;
    
    
    pause(3);
    
    %
    % Count the number of each color found:
    %
    for cluster_number = 1 : size( kmeans_center_found, 1 )
        binary_mask = (image_by_id == cluster_number);
        
        % Count the number of pixels found of this color.
        n_pix_per_cluster(cluster_number) = sum(binary_mask(:));
    end
    
    % We really only care about the sort key here.
    % We could say:
    %
    % [~,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
    %
    [junk_variable,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
    
    
    fprintf('Here we analyze the results.\n');
    fprintf('In another iteration, we might delete some of these cluster centers.\n\n');
    fprintf('For example, white and yellow are similar.\n');
    fprintf('And you do not really care about the white pixels here.\n');
    fprintf('White is the background color.\n\n');
    
    for cluster_number = sort_key
        
        binary_mask = (image_by_id == cluster_number);
        
        figure;
        imagesc( binary_mask );
        axis image;
        colormap( gray(2) );
        
        % Count the number of pixels found of this color.
        n_pixels_found = sum(binary_mask(:));
        
        tmp_str = sprintf('Cluster %d, "%s"', cluster_number, Seed_Pts.Color_name{ cluster_number } );
        title( tmp_str, 'FontSize', 32 );
        
        fprintf('Found %6d pixels of   color number %3d, [%4.2f,%4.2f,%4.2f], "%s", \n', ...
            n_pixels_found, ...
            cluster_number, ...
            kmeans_center_found(cluster_number,:), ...
            Seed_Pts.Color_name{ cluster_number } );
        
        pause(6);
    end
    
end
