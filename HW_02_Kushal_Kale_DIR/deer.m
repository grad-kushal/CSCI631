function deer()
    im_db = im2double( imread( "HW_IMAGES_and_FILES/IMG_2663_DEER_with_Ears_small.jpg" ) );
    figure;
    imagesc( im_db(:,:,1) );
    colormap(gray(256));
    axis image;
    figure;
    imagesc( im_db(:,:,2) );
    colormap(gray(256));
    axis image;
    figure;
    imagesc( im_db(:,:,3) );
    colormap(gray(256));
    axis image;
    im_gray = rgb2gray( im_db );
    figure;
    imagesc( im_gray );
    colormap(gray(256));
    axis image;
    im_yellow = im_db(:,:,1) + im_db(:,:,2) - 2 * im_db(:,:,3 ) / 2;
    im_whatever = im_db(:,:,1) + im_db(:,:,3) - 2 * im_db(:,:,2 ) / 2;
    im_whatever2 = im_db(:,:,2) + im_db(:,:,3) - 2 * im_db(:,:,1 ) / 2;
    figure;
    imshow(im_yellow);
    figure;
    imshow(im_whatever);
    figure;
    imshow(im_whatever2);

end