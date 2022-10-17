function contrast_enh()
    im = imread("HW_IMAGES_and_FILES/IMG_2548__Needs_Contrast_Enhancement.jpg");
    im_gray = im2double( im( 2:2:end, 2:2:end, 2) );
    figure;
    imshow(im_gray);
    figure;
    imhist(im_gray);
    imadjusted = imadjust(im_gray);
    figure;
    imshow(imadjusted);
    histequllized = histeq(im_gray);
    figure;
    imshow(histequllized);
    adapthistequallized = adapthisteq(im_gray);
    figure;
    imshow(adapthistequallized);
%     montage({im_gray,imadjusted,histequllized,adapthistequallized},"Size",[1 4])
%     title("Original Image and Contrast Enhanced Images using imadjust, histeq, and adapthisteq respectively")
end