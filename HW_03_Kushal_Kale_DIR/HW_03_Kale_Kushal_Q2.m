function HW_03_Last_name_first_name_Q2()
    im = imread("IMAGES_for_Computer_Vision_HW_03/IMG_20220828_Apples.jpg");
    hsv = rgb2hsv(im);
    gray1 = hsv(:,:,3);
    gray2 = im(:,:,1);
    histequllized1 = histeq(gray1);
    histequllized2 = histeq(gray2);
    adapthistequallized1 = adapthisteq(gray1);
    adapthistequallized2 = adapthisteq(gray2);
    figure;
    imshow(histequllized1);
    figure;
    imshow(histequllized2);
    figure;
    imshow(adapthistequallized1);
    figure;
    imshow(adapthistequallized2);

    mrs_kinsman = imread("IMAGES_for_Computer_Vision_HW_03/IMG_2523_Matilda_STROOP_EFFECT.JPG");
    figure;
    imshow(mrs_kinsman);
    info = imfinfo("IMAGES_for_Computer_Vision_HW_03/IMG_2523_Matilda_STROOP_EFFECT.JPG");
    disp(info.DateTime);
    disp(info.DigitalCamera.FNumber);
    disp(info.DigitalCamera.ISOSpeedRatings);
    disp(info.DigitalCamera.ComponentsConfiguration);
    disp(info.DigitalCamera.ColorSpace);
    disp(info.DigitalCamera.Flash);
    disp(info.DigitalCamera);

    figure;
    Show_Color_Separations_rgby(mrs_kinsman);
    figure;
    Show_Color_Separations_rgby(imread("IMAGES_for_Computer_Vision_HW_03/IMG_Four_Balls_input.jpg"));
    
end

function Show_Color_Separations_rgby(input_digital_image)
    imr = input_digital_image(:,:,1); 
    img = input_digital_image(:,:,2);
    imb = input_digital_image(:,:,3);
    im_db = im2double( input_digital_image );
    imy = (im_db(:,:,1) + im_db(:,:,2) - 2 * im_db(:,:,3 )) / 2;
    %imy = max(imy, 0);
    ax1 = subplot(2,2,1);
    imshow(imr);
    ax2 = subplot(2,2,2);
    imshow(img);
    ax3 = subplot(2,2,3);
    imshow(imb);
    ax4 = subplot(2,2,4);
    imshow(imy);
end