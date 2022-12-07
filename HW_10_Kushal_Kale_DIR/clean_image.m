function im_cleaned = clean_image( im_gray )
    
%     figure; imshow(im_gray);
%     threshold = graythresh(im_gray);
%     disp(threshold);
%     im_gray = adapthisteq(im_gray);
    bin = imbinarize(im_gray, 0.25);
    bin = bwareaopen(bin, 900);
    im_cleaned  = bin;
end

