% Kushal Kale - midterm code - CSCI631

function midterm()
    q_41("IMG_2861_ON_BOWL_RUFFLES.JPG");
end

function q_41(filename)
    im = imread(filename);
    im = im2double(im);
    im = im(:, :, 2);
    figure; imshow(im);
    vert_filt = [ -1 -2 -1; 0 0 0 ; +1 +2 +1 ] / 8;
    hori_filt = [ -1 0 +1; -2 0 +2 ; -1 0 +1 ] / 8;
    v_edges = imfilter( im, vert_filt);
    h_edges = imfilter( im, hori_filt);
    mags = sqrt( v_edges.^2 + h_edges.^2 );
    figure; imshow(mags);
    mag_at_95 = prctile(mags,95,"all");
    disp("95th percentile: " + mag_at_95);
    newmat = zeros(size(mags));
%     newmat = 1 - newmat;
    newmat = mags > mag_at_95;
%     newmat = 1 - newmat;
    se = strel('disk',1);
    newmat = imerode(newmat, se);
    figure; imshow(newmat);
end