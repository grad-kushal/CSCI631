function project()
    clc
    close all;
    addpath( '../TEST_IMAGES' );
    addpath( 'TEST_IMAGES/' );
    show_all_files_in_dir();
end

function show_all_files_in_dir()
    path = pwd + "/TEST_IMAGES/";
    disp(path);
    files = dir(path + '*.JPG');   
    numberOfFiles = length(files); 
    for i = 1:numberOfFiles
        currentFile = files(i).name;
        im = rgb2gray(im2double(imread(currentFile)));
        imshow(im);
    end
end