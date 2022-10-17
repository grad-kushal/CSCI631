function k_means_on_g()
    im_orig = imread('gg.jpeg');
    im_rgb = im_orig;
    im_lab = rgb2lab( im_rgb );
    %%%%%%%%%%%%%%%%%%%%%%%% get edges %%%%%%%%%%%%%%%%%%%%%%%%
    edges_canny = edge(rgb2gray(im_rgb), 'Canny');
    edges_sobel = 1 - edge(rgb2gray(im_rgb), 'Sobel');
    figure;
    imshow(edges_sobel);
    figure;
    imshow(edges_canny);

    dims        = size( im_rgb );
    disp(dims)
    
    %%%%%%%%%%%%%%%%%%%%%%%% extract attributes %%%%%%%%%%%%%%%%%%%%%%%%
    [xs, ys]     = meshgrid( 1:dims(2), 1:dims(1) );
    
    reds        = im_rgb(:,:,1);
    grns        = im_rgb(:,:,2);
    blus        = im_rgb(:,:,3);

    lums        = im_lab(:,:,1);
    aStr        = im_lab(:,:,2);
    bStr        = im_lab(:,:,3);
    %%%%%%%%%%%%%%%%%%%%%%%% kmeans using the attributes on RGB and LAB %%%%%%%%%%%%%%%%%%%%%%%%
    dst_wts = [ 1/4 ];
    for wt = dst_wts 
        for k = [ 12 ]
            attributes  = [ xs(:)*wt, ys(:)*wt, double(reds(:)), double(grns(:)), double(blus(:)) ];
            tic;
            cluster_id  = kmeans( attributes, k, 'Distance', 'sqeuclidean', 'Replicates', 3, 'MaxIter', 250, "Start",'cluster' );
            toc
            im_new = reshape( cluster_id, dims(1), dims(2) );
            figure;
            imagesc( im_new );
            colormap( jet );
            title( sprintf('k = %d,  distance wt = %8.5f ', k, wt), 'FontSize', 24 );
            drawnow;

            
         end
     end
 
     dst_wts = [ 1/10 ];
     for wt = dst_wts
         for k = [ 12 ]
             attributes  = [ xs(:)*wt, ys(:)*wt, double(lums(:)), double(aStr(:)), double(bStr(:)) ];
             tic;
             cluster_id  = kmeans( attributes, k, 'Dist', 'sqeuclidean', 'Replicate', 3, 'MaxIter', 250 );
             toc
             
             im_new      = reshape( cluster_id, dims(1), dims(2) );
 
             figure;
             imagesc( im_new );
             colormap( jet );
             title( sprintf('k = %d,  distance wt = %8.5f ', k, wt), 'FontSize', 24 );
             drawnow;
             
          end
     end

%%%%%%%%%%%%%%%%%%%%%%%% kmeans on each channel %%%%%%%%%%%%%%%%%%%%%%%% 

    im_greesha     = imread('gg.jpeg');
    im_lab      = rgb2lab( im_greesha );
    im_double = im2double(im_greesha);
    
    disp(size(im_double, 1))
    disp(size(im_double, 2))

    [l2r, c2r] = kmeans(im_double(:, :,1), 50, "Distance","sqeuclidean", "Replicates",3);
    [l2g, c2g] = kmeans(im_double(:, :,2), 50, "Distance","sqeuclidean", "Replicates",3);
    [l2b, c2b] = kmeans(im_double(:, :,3), 50, "Distance","sqeuclidean", "Replicates",3);
    maskr = zeros(size(im_double, 1), size(im_double, 2));
    maskg = zeros(size(im_double, 1), size(im_double, 2));
    maskb = zeros(size(im_double, 1), size(im_double, 2));
    for i = 1: size(maskr, 1)
        maskr(i, :) = c2r(l2r(i), :);
    end
    for i = 1: size(maskg, 1)
        maskg(i, :) = c2g(l2g(i), :);
    end
    for i = 1: size(maskb, 1)
        maskb(i, :) = c2b(l2b(i), :);
    end
    new_im = cat(3, maskr, maskg, maskb);
    figure;
    imshow(new_im);

%%%%%%%%%%%%%%%%%%%%%%%% kmeans on a 2d version of the image %%%%%%%%%%%%%%%%%%%%%%%%

    im_2d = reshape(im_double, 407682, 3);
    [l1, c1] = kmeans(im_2d, 10, "Distance","sqeuclidean", "Start","cluster", "Replicates",3);
    mask = zeros(size(im_double, 1) * size(im_double, 2), 3);
    for j = 1: size(mask, 1)
        mask(j, :) = c1(l1(j), :);
    end
    mask = reshape(mask, size(im_double, 1), size(im_double, 2), 3);
    figure;
    imshow(mask);

    figure; 
    imshow(imoverlay(mask, edges_canny, 'black'));
end
