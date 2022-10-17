function HW_00_Kale_Kushal( filename_in, filename_other )
    % read image
    image_in = imread(filename_in);
    figure;
    imshow(image_in);

    % convert to grayscale
    greyscale = rgb2gray(image_in);
    figure;
    imshow(greyscale);
    imwrite(greyscale, "greyscale.jpg", 'Quality', 95);
    
    disp(size(image_in));
    % resize to 1/4th size
    resized = imresize(image_in, 0.25);
    figure;
    imshow(resized);
    disp(size(resized));
    imwrite(resized, "resized.jpg", 'Quality', 95);
    
    % swap the red channel with green
    rgswapped = resized(:,:,[2 1 3]);
    figure;
    imshow(rgswapped);
    imwrite(rgswapped, "rgswapped.jpg", 'Quality', 95);
    
    % invert the image 
    inverted = 255 - resized;
    %figure;
    %imshow(inverted);
    imwrite(inverted, "inverted.jpg", 'Quality', 95);

    % crop out a part of the image and invert it
    cropped = 255 - imcrop(resized,[125 250 250 250]);
    %figure;
    %imshow(imcomplement(resized));
    %255 - resized(125:375, 125:375);
    %figure;
    %imshow(cropped)

    % replace the cropped part area with the inverted cropped image
    fused = resized;
    fused(250:500, 125:375, :) = cropped;
    figure;
    imshow(fused);
    imwrite(fused, "fused.jpg", 'Quality', 95);

    %write images to file with different quality.
    figure;
    imwrite(fused, 'temp1.jpg', 'Quality', 95);
    imshow(imread('temp1.jpg'));
    figure;
    imwrite(fused, "temp2.jpg", 'Quality', 5);
    imshow(imread('temp2.jpg'));

    oneInverted = resized;
    invertedRedChannel = 255 - oneInverted(:,:,1);
    oneInverted(:,:,1) = invertedRedChannel;
    figure;
    imshow(oneInverted);
    imwrite(oneInverted, "oneInverted.jpg", 'Quality', 95);

    image_other = imread(filename_other);
    disp(size(image_other))
    cropped_other = imcrop(image_other,[0 0 2050 2050]);
    %figure;
    %imshow(cropped_other);
    doubleIm1 = im2double(image_in);
    doubleIm2 = im2double(cropped_other);
    figure;
    imagesc(doubleIm1 - doubleIm2);
    imwrite(doubleIm1 - doubleIm2, "difference.jpg", 'Quality', 95);

    hsv = rgb2hsv(resized);
    figure;
    imshow(hsv);
    im_hue_only = hsv(:,:,1);
    imagesc( im_hue_only );
    imwrite(im_hue_only, "im_hue_only.jpg", 'Quality', 95);

    im_small = imrotate( image_in( 2:3:end, 2:3:end, : ), 0 );
    im_up_right = zeros( size(im_small) );
    im_up_right(:,:,1) = im_small(:,:,1);
    im_down_left = zeros( size(im_small) );
    im_down_left(:,:,2) = im_small(:,:,2);
    im_down_right = zeros( size(im_small));
    im_down_right(:,:,3) = im_small(:,:,3);
    im_composite = [ im_small , im_up_right ;
    im_down_left , im_down_right ];
    figure;
    imagesc( im_composite );
    imwrite(im_composite, "composite.jpg", 'Quality', 95);


end