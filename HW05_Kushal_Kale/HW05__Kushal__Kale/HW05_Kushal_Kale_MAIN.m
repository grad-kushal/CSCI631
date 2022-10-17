function HW05_Kushal_Kale_MAIN()
    clc
    close all;
    addpath( '../TEST_IMAGES' );
    show_all_files_in_dir();
end

function show_all_files_in_dir(  )
    p_arr = ["TEST_IMAGES/Set_01_A/", "TEST_IMAGES/set_23/"];
    folder_path = dir("TEST_IMAGES/Set_01_A/");
    for y = 1:length(p_arr)
%         fname = prr(i);
%         disp(fname)
%         if fname == "Set_01_A" || fname == "set_23"
        file_list = dir(p_arr(y) + "*.jpg");
        for counter = 1 : length( file_list )
            file = file_list(counter).name;
            im = imread(p_arr(y) + file);
            im = im2double(im);
            im_size = size(im);

%   %   %   %   %   %   %   Rotate if Necessary %   %   %   %   %

            if im_size(1) > im_size(2)
                im = imrotate(im, -90);
            end

%   %   %   %   %   %   %   Convert to Binary %   %   %   %   %     %

            im = imbinarize(im(:,:, 1));
            im_dice = im;
            im_spots = im;

%   %   %   %   %   %   %   Morphology to close and erode %   %   %   %   %     %
            se = strel('disk',30);
            im_dice = imclose(im_dice, se);
            se = strel('disk',5);
            im_dice = imerode(im_dice, se);

%   %   %   %   %   %   %   Get number and labels %   %   %   %   %     %
        
            [~, numberOfDice] = bwlabel(im_dice, 8);

            arr = 1:6;
            for z = 1:length(arr)
                arr(z) = 0;
            end

            [boundary_pixels, ~] = bwboundaries(im_dice,'noholes');
            figure;
            imshow(imerode(im, strel('disk',4)));
%   %   %   %   %   %   %   Draw Boundary %   %   %   %   %     %
            hold on
            for i = 1:length(boundary_pixels)
                boundary = boundary_pixels{i};
                plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 2);
            end

        
            se = strel('disk',3);                       % structure element and erode to make spots more clear
            im_spots = imopen(im_spots, se);
            im_spots = imerode(im_spots, strel('disk',5));
            im_spots = imerode(im_spots, strel('line',10, 90));
            im_spots_op = bwareaopen(im_spots,800);         % remove small noise from the image
            cc = bwconncomp(im_spots_op);                   % get connected components
            cc_labs = labelmatrix(cc);
            for i = 1:cc.NumObjects
                curr = cc_labs==i;
                thisDots = bwareaopen(imfill(curr,'holes') & ~curr, 50);
                dotsCC = bwconncomp(thisDots);              %get dots
%                 disp(dotsCC.NumObjects)
                if dotsCC.NumObjects < 7 && dotsCC.NumObjects >0            %check if connected components are not dots
                    arr(dotsCC.NumObjects) = arr(dotsCC.NumObjects) + 1;    %keep count of die dots
                end
            end


            fprintf("INPUT Filename: \t" + file + "  \nNumber of Dice: \t" + numberOfDice + "  \n");
            sum = 0;
            for z = 1:length(arr)
                fprintf("Number of " + z + "\'s: \t\t" + arr(z) + "\n");    
                sum = sum + arr(z);                                      % Calculate total
            end
            fprintf("Total of all dots: \t" + sum);
            fprintf("\n\n");
            
        end
    end
end