function ivy()
    im = imread("HW_IMAGES_and_FILES/IMG_2653_IVY_Against_Wild_Grape_Vines.jpg");
    figure;
    imshow(im);
    im_gray = rgb2gray(im);
    figure;
    imshow(im_gray);
    figure;
    imhist(im_gray);
    imadjusted = imadjust(im_gray);
    figure;
    imshow(imadjusted);
    disp(graythresh(imadjusted));
    bin = imbinarize(imadjusted, 0.8);
    figure;
    imshow(bin);
end