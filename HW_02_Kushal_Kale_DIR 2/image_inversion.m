function image_inversion( )
    im_db = im2double( imread('cameraman.tif' ) );
    imagesc( im_db );
    colormap( gray(256) );
    axis image;
    imwrite(im_db, "outputImages/outputoriginal.jpeg");
    imagesc( 1 - im_db ) ;
    axis image;
    imwrite(1 - im_db, "outputImages/outputnegative.jpeg");
    imshowpair(im_db, 1 - im_db,'montage');
end
