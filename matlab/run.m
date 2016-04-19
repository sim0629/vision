% It assumes:
%   The current directory is 'matlab/'.
%   There must be 'points.mat' in the current directory.
%   There must be 'cc[12].mat', 'crop[12].jpg', 'wdc[12].jpg' in 'data/'.
%   There exists 'result/' directory.

wdc1 = imread('../data/wdc1.jpg');
wdc2 = imread('../data/wdc2.jpg');
points_wdc = load('points.mat');
H_wdc = computeH(points_wdc.points1', points_wdc.points2');
[wdc1_warped, wdc_merged] = warpImage(wdc1, wdc2, H_wdc);
imwrite(wdc1_warped, '../result/wdc1_warped.jpg');
imwrite(wdc_merged, '../result/wdc_merged.jpg');

crop1 = imread('../data/crop1.jpg');
crop2 = imread('../data/crop2.jpg');
points_cc1 = load('../data/cc1.mat');
points_cc2 = load('../data/cc2.mat');
H_crop = computeH(points_cc1.cc1, points_cc2.cc2);
[crop1_warped, crop_merged] = warpImage(crop1, crop2, H_crop);
imwrite(crop1_warped, '../result/crop1_warped.jpg');
imwrite(crop_merged, '../result/crop_merged.jpg');
