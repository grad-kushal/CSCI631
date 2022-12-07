function feature_mat = get_features_SKELETON( im_cleaned )
    clc
    close all;
    addpath('out/');
    directories_on_path = split(path, ":");
    for index = 1:length(directories_on_path)
        if contains(directories_on_path(index),"out")
        %         files = show_all_files_in_dir(directories_on_path(index));
            patterns = ["/segmented_IVY*.png" "/segmented_*2000_x_3000*.png"];
            files = dir(directories_on_path(index) + patterns(1));
        end
        numberOfFiles = length(files);
        for i = 1:numberOfFiles                                             % For each image
            currentFile = files(i).name;
            imrgb = im2double(imread(currentFile));
            figure; imshow(imrgb);
            details = regionprops('table', imrgb,{'MinorAxisLength', 'MajorAxisLength', 'Area', 'Circularity', 'Perimeter'});
            disp(details)
            for row = 1 : size( details, 1 )
                feature_mat(row,1) = details{row,1};
                feature_mat(row,2) = details{row,2};
                feature_mat(row,3) = details{row,3};
                feature_mat(row,4) = details{row,4};
                feature_mat(row,5) = details{row,5};
            end
        end
        break;
        disp(feature_mat)
    end
end

