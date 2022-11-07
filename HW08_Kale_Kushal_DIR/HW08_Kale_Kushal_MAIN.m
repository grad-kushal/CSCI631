function HW08_Kale_Kushal_MAIN()
clc
close all;
addpath( '../TEST_IMAGES' );
addpath( '../../TEST_IMAGES' );
addpath( 'TEST_IMAGES/' );
directories_on_path = split(path, ":");
for index = 1:length(directories_on_path)
    if contains(directories_on_path(index),"TEST_IMAGES")
        process_all_files_in_dir(directories_on_path(index));
    end
end
end

function HW08_Kale_Kushal_Part_A(im)
    h_edges = edge(imadjust(rgb2gray(im)), 'sobel', 0.09099, 'horizontal');
    [H, thetaV, rhoV] = hough(h_edges, 'thetaRes', 0.1);
    figure, imshow(imadjust(mat2gray(H)), 'XData', thetaV, 'YData', rhoV, 'Border', 'loose')
    daspect auto
    axis on
    xlabel('\theta')
    ylabel('\rho')
    

    peaks = houghpeaks(H, 18);
    hold on
    plot(round(thetaV(peaks(:, 2))), rhoV(peaks(:, 1)),'LineStyle','none', 'LineWidth', 3, 'Marker', 's','MarkerSize', 14, 'color', 'y');
    hold off
    pause(1)

    lines = houghlines(rgb2gray(im), thetaV, rhoV, peaks, 'FillGap',2);  
    disp(length(lines));
    figure, imshow(rgb2gray(im));
    hold on
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        if abs(xy(2,2) - xy(1,2)) > 500
            continue;
        else
            plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'y');
        end
    end
    hold off
end

function HW08_Kale_Kushal_Part_B(im)
%     h_edges = edge(rgb2gray(im), 'sobel', 'horizontal');
%     v_edges = edge(rgb2gray(im), "sobel", "vertical");
%     figure; imshow(h_edges);
%     figure; imshow(v_edges);
    color_comp = HW07_Kale_Kushal_Helper(im);
    color_comp = 1 - imbinarize(im2double(color_comp(:, :, 1)));
    color_comp = imerode(color_comp, strel("disk", 2));
    figure; imshow(color_comp);
    disp(size(color_comp));
    fltr_dIdy = [ -1 -2 -1; 0 0 0 ; +1 +2 +1 ] / 8;
    fltr_dIdx = [ -1 0 +1; -2 0 +2 ; -1 0 +1 ] / 8;
%     disp(fltr_dIdx);
%     disp(fltr_dIdy);
    dIdy = imfilter( rgb2gray(im), fltr_dIdy);
    dIdx = imfilter( rgb2gray(im), fltr_dIdx);
    dImag = sqrt( dIdy.^2 + dIdx.^2 );
    figure; imshow(dImag);
%     ne = imopen(dImag, strel("disk", 1));
% %     figure; imshow(ne);
%     thr = graythresh(dImag);
%     b = imbinarize(dImag, thr);
%     figure; imshow(imerode(imclose(b, strel("disk", 1)), strel("disk", 1)));
    figure;
    histogram(dImag);
    cutoff_value = prctile(dImag,90,"all");
    disp("Cutoff Value: " + cutoff_value);
    newmat = zeros(size(dImag));
    newmat = 1 - newmat;
    k = size(newmat);
    newmat = dImag > cutoff_value;
    newmat = 1 - newmat;
    figure; imshow(newmat);
    result = ones(k);
    for row =  1:k(1)        % Iterate till the last valid row.
        for col =  1:k(2)
            if newmat(row, col) == color_comp(row, col)
                result(row, col) = newmat(row, col);
            end
        end
    end
    figure; imshow(result);
end

function process_all_files_in_dir(my_path)
    patterns = ["/*.JPG" "/*House_Side*"];
    files = dir(string(my_path) + patterns(2));
    numberOfFiles = length(files);
    for i = 1:numberOfFiles                                                 % For each image
        currentFile = files(i).name;
        imrgb = im2double(imread(currentFile));
        HW08_Kale_Kushal_Part_A(imrgb);
    end

    files = dir(string(my_path) + patterns(1));
    numberOfFiles = length(files);
    for i = 1:numberOfFiles                                                 % For each image
        currentFile = files(i).name;
        imrgb = im2double(imread(currentFile));
        HW08_Kale_Kushal_Part_B(imrgb);
    end
end

function b_is_fg = HW07_Kale_Kushal_Helper( im )

    GET_USER_INPUT = true;
%     im = im2double( imread( fn_in ) ) ;
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
    %
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
    
    disp('break here');
    % 
    %  For each input pixel, figure out distance to the raspberry colors.
    [im_red, im_grn, im_blu] = imsplit( im );    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    b_is_fg = fg_dist < bg_dist;   
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );   
%     imagesc( b_is_fg );
end