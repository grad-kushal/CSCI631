function HW_01_Kale_Kushal( filename_in, myimagefile )
    
    image_in = imread(filename_in);
     figure;
     imshow(image_in)
     [x, y] = ginput(1);
     disp([x, y]);

    figure;
    imshow(image_in(:, :, 1));
    imwrite(image_in(:, :, 1), "Jairaj_Red.jpg", 'Quality', 99);
    figure;
    imshow(image_in(:, :, 2));
    imwrite(image_in(:, :, 2), "Jairaj_Green.jpg", 'Quality', 99);
    figure;
    imshow(image_in(:, :, 3));
    imwrite(image_in(:, :, 3), "Jairaj_Blue.jpg", 'Quality', 99);

    my_image = imread(myimagefile);
    my_image_green = my_image(:, :, 2);
    figure;
    imshow(my_image_green);
    rotated = imrotate(my_image_green, -14);
    figure;
    imshow(rotated);
    imwrite(imcrop(rotated, [520, 520, 888, 888]), "HW_01_Dynamic_Kale_Kushal.jpg", 'Quality', 99);
    
    x = 0 : 1080;
    y = sin(x * (pi/180));
    plot(x, y, '-b');
    axis tight;
    xlabel('Degrees', 'FontSize', 18);
    ylabel('Sine of Theta', 'FontSize', 18);
end