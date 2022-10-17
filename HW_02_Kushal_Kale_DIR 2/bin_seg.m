function bin_seg()
    im = imread("HW_IMAGES_and_FILES/IMG_2742_Virginia_Creeper.jpg")
    im_gray = im2double( im( 2:2:end, 2:2:end, 2) );
    imshow(im_gray)
    figure;
    disp(graythresh(im_gray));
    bin = imbinarize(im_gray, 0.4900);
    imshowpair(im_gray,bin,'montage');
end