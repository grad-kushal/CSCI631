function temp()
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
    files = ["/Users/kushalkale/Kushal/CSCI631/TEST_IMAGES/IMG_3155.JPG"];
    numberOfFiles = length(files); 
    for i = 1:numberOfFiles                                                     % For each image
%         currentFile = files(i).name;
        currentFile = files(i);
        im = im2double(imread(currentFile)); 
        R = im(:,:,1);
        G = im(:,:,2);
        B = im(:,:,3);
        Z = [R(:) G(:) B(:)];
        k = 3;
        [L, C] = kmeans(Z, k);
        fseg = zeros(size(f, 1), size(f, 2));
        for j = 1:k
            fseg( L == j) = j;
        end
        fseg = intensityScaling(fseg);
        figure, imshow(fseg)
        fseg = imcomplement(fseg);
        figure, imshow(fseg)
    end
end