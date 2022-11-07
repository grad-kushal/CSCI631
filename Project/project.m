function project()
    clc
    close all;
    addpath( '../TEST_IMAGES' );
    addpath( '../../TEST_IMAGES' );
    addpath( 'TEST_IMAGES/' );
    directories_on_path = split(path, ":");
    for index = 1:length(directories_on_path)
        if contains(directories_on_path(index),"TEST_IMAGES")
        %         files = show_all_files_in_dir(directories_on_path(index));
            patterns = ["/*3108*.JPG"];
            files = dir(directories_on_path(index) + patterns(1));
        end
        numberOfFiles = length(files);
        for i = 1:numberOfFiles                                             % For each image
            currentFile = files(i).name;
            imrgb = im2double(imread(currentFile));
            segment_and_get_edges(imrgb);
            clc
%             close all;
        end
        break;
    end
end

function segment_and_get_edges(im)
    color_comp = segment(im);
    color_comp = 1 - imbinarize(im2double(color_comp(:, :, 1)));
    color_comp = imerode(color_comp, strel("disk", 5));
    figure; imshow(color_comp);
    figure; imshow(edge(color_comp, "canny"));
%     fltr_dIdy = [ -1 -2 -1; 0 0 0 ; +1 +2 +1 ] / 8;
%     fltr_dIdx = [ -1 0 +1; -2 0 +2 ; -1 0 +1 ] / 8;
%     dIdy = imfilter( rgb2gray(im), fltr_dIdy);
%     dIdx = imfilter( rgb2gray(im), fltr_dIdx);
%     dImag = sqrt( dIdy.^2 + dIdx.^2 );
%     figure; imshow(1-dImag);
%     cutoff_value = prctile(dImag,90,"all");
%     disp("Cutoff Value: " + cutoff_value);
%     newmat = zeros(size(dImag));
%     newmat = 1 - newmat;
%     k = size(newmat);
%     newmat = dImag > cutoff_value;
%     newmat = 1 - newmat;
%     figure; imshow(newmat);
%     result = ones(k);
%     for row =  1:k(1)        % Iterate till the last valid row.
%         for col =  1:k(2)
%             if newmat(row, col) == color_comp(row, col)
%                 result(row, col) = newmat(row, col);
%             end
%         end
%     end
%     figure; imshow(result);
end


function b_is_fg = segment( im )

    im_contrast = max(im(:)) - min(im(:));
    if im_contrast < 0.9700                                                 % enhance contrast if necessary
        im = adapthisteq(im);
    end
    GET_USER_INPUT = true;
    imagesc( im );
    axis image;
    if ( GET_USER_INPUT )
        fprintf('Click on the Leaf\n');
        beep();
        [rxs,rys] = ginput();
        fprintf('Click on the Background\n');
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