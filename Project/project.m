function project()
    clc
    close all;
    addpath( '../TEST_IMAGES' );
    addpath( '../../TEST_IMAGES' );
    addpath( 'TEST_IMAGES/' );
    directories_on_path = split(path, ":");
    for index = 1:length(directories_on_path)
        if contains(directories_on_path(index),"TEST_IMAGES")
            show_all_files_in_dir(directories_on_path(index));
        end
    end
end

function show_all_files_in_dir(my_path)
    disp(my_path);
%     files = dir(string(my_path) + '/*.JPG');   
    files = ["/Users/kushalkale/Kushal/CSCI631/TEST_IMAGES/IMG_3155.JPG"];
    numberOfFiles = length(files); 
    for i = 1:numberOfFiles                                                     % For each image
%         currentFile = files(i).name;
        currentFile = files(i);
        im = imresize(rgb2gray(im2double(imread(currentFile))), [1000 1000]);   % resize to 1000 x 1000
        im_contrast = max(im(:)) - min(im(:));
        if im_contrast < 0.9700                                                 % enhance contrast if necessary
            im = adapthisteq(im);
        end
        threshold = graythresh(im);
        binary = imbinarize(im,threshold);
        imshow(binary);
%         imshow(edge(im, "sobel"));
    end
end