function project()
    clc
    close all;
    addpath('out/');
    addpath( '../TEST_IMAGES' );
    addpath( '../../TEST_IMAGES' );
    addpath( 'TEST_IMAGES/' );

    directories_on_path = split(path, ":");
    for index = 1:length(directories_on_path)
        if contains(directories_on_path(index),"TEST_IMAGES")
        %         files = show_all_files_in_dir(directories_on_path(index));
            input_dir      = 'out';
            classes                   = '10';
            patterns = ["/segmented_IVY*.png" "/segmented_*2000_x_3000*.png"];

            initialize_the_feature_table    = true;

            for class_id = 1:length(classes)

                this_cls_pattern = patterns(class_id);
                disp(this_cls_pattern);
                training_files  = dir( this_cls_pattern );

                for idx = 1 : length( training_files )
                    currentFile       = sprintf('%s%c%s', input_dir, filesep(), training_files(idx).name );
                    fprintf('%s\n', fn_in );
                    imrgb = im2double(imread(currentFile));
                    imrgb = imcrop(imrgb, [450 450 5500 3300]);                                         % Cropping out the irrelevant part
                    mat_list = [mat_list; segment_and_get_edges(imrgb, currentFile)];
                end
            end
              patterns = ["/*3155.JPG"];
            files = dir(directories_on_path(index) + patterns(1));
        end
        mat_list = []
        numberOfFiles = length(files);
        for i = 1:numberOfFiles                                                                 % For each image
            currentFile = files(i).name;
                               % Calling the function to segment the image and get edge details
            close all;
        end
        break;
    end
end

function feature_mat = segment_and_get_edges(im, currentFile)
    color_comp = segment(im);
    color_comp = bwareaopen(color_comp, 10000, 8);                              % Remove smaller objects which are not of concern (grass, dead leaves, etc.)
    color_comp = imfill(color_comp,'holes');                                    % Remove holes from the leaf
    figure; imshow(color_comp);                                                 % Disply segmented image
    writefile = "out/segmented_" + currentFile + ".png";
    imwrite(color_comp, writefile);
    details = regionprops('table', color_comp,{'MinorAxisLength', 'MajorAxisLength', 'Area', 'Circularity', 'Perimeter'});
    disp(details)
    for row = 1 : size( details, 1 )
        feature_mat(row,1) = details{row,1};
        feature_mat(row,2) = details{row,2};
        feature_mat(row,3) = details{row,3};
        feature_mat(row,4) = details{row,4};
        feature_mat(row,5) = details{row,5};
    end
    disp(feature_mat);
    edges = edge(color_comp, "canny");
    figure; imshow(edges);
    writefile = "out/edges_" + currentFile + ".png";
    imwrite(edges, writefile)
    fltr_dIdy = [ -1 -2 -1; 0 0 0 ; +1 +2 +1 ] / 8;
    fltr_dIdx = [ -1 0 +1; -2 0 +2 ; -1 0 +1 ] / 8;
    dIdy = imfilter( rgb2gray(im), fltr_dIdy);
    dIdx = imfilter( rgb2gray(im), fltr_dIdx);
    dImag = sqrt( dIdy.^2 + dIdx.^2 );
    figure; imshow(1-dImag);
    writefile = "out/edge_mags_" + currentFile + ".png";
    imwrite(dImag, writefile);
    threshold = prctile(dImag,45,"all");                                        % Get edge magnitude stronger than a threshold to get the details like veins
    disp("Threshold value: " + threshold);
%     newmat = zeros(size(dImag));
%     newmat = 1 - newmat;
    k = size(dImag);
    newmat = dImag > threshold;                                                 % Create a new image with only the edges stronger than the threshold
%     figure; imshow(newmat);
    result = ones(k);
    for row =  1:k(1)        % Iterate till the last valid row.
        for col =  1:k(2)
            if newmat(row, col) ~= color_comp(row, col)                                 
                result(row, col) = newmat(row, col);                            % Map the strong edges from the image only inside the leaf
            end
        end
    end
%     figure; imshow(1-result);
    writefile = "out/segmented_details_" + currentFile + ".png";
    imwrite(1-result, writefile);
    greenresult = cat(3, zeros(k) , 1-result, zeros(k));
    figure; imshow(greenresult);                                                % Show the leaf with details in green
    currentFile = "out/output_" + currentFile + ".png";
    imwrite(greenresult, currentFile)
end

function get_feature_mat()
    
end

function b_is_fg = segment( im )
    disp(size(im))
    im_contrast = max(im) - min(im);
    if im_contrast < 0.9700                                                 % enhance contrast if necessary
        im_lab = rgb2lab(im);
        max_luminosity = 100;
        L = im_lab(:,:,1)/max_luminosity;
        im_adapthisteq = im_lab;
        im_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
        im = lab2rgb(im_adapthisteq);
    end
    GET_USER_INPUT = true;
    figure;
    imagesc( im );
    axis image;
    if ( GET_USER_INPUT )
        fprintf('Click on the Leaf at least at 7-10 different points\n');
        beep();
        [rxs,rys] = ginput();
        fprintf('Click on the Background at least at 7-10 different points\n');
        beep();
        [bgxs,bgys] = ginput();
        save temp_matrix.mat rxs rys bgxs bgys;
    end
                                                                            %  Get color values -- samples - of the leaf.
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
    
                                                                            %  For each input pixel, figure out distance to the leaf colors.
    [im_red, im_grn, im_blu] = imsplit( im );    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    b_is_fg = fg_dist < bg_dist;   
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );   
end