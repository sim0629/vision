function trackTemplate(path_to_car_sequence, sigma)

function [image] = ReadImage(index)
fname = sprintf('%s/%d.jpg', path_to_car_sequence, index);
image = double(imread(fname)) / 255;
end

function [image] = GaussImage(image)
image = imgaussfilt(image, sigma);
image = imresize(imresize(image, 1/sigma), sigma);
end

numimages = 713;
mkdir('./output/');

T = ReadImage(0);
Tg = GaussImage(T);

% Select the region of interest
figure; imshow(T);
title('first input image');
[tempX, tempY] = ginput(2);  % get two points from the user
close;
DrawRectangle(T, tempX(1), tempY(1), tempX(2)-tempX(1), tempY(2)-tempY(1));

% not on whole image:
[Y, X] = size(T);
roi = zeros(Y, X);
roi(tempY(1):tempY(2), tempX(1):tempX(2)) = 1;
inds = find(roi)';

u = 0; v = 0;
for i = 1 : numimages
    fprintf('image #%d\n', i);
    I = ReadImage(i);
    Ig = GaussImage(I);
    Is = Translate(Ig, u, v);

    [du, dv, lost] = OpticalFlow(Tg, Is, inds);
    if lost
        disp('Template lost');
        close;
        return;
    end

    u = u + du; v = v + dv;
    Tg = Translate(Ig, u, v);

    I = DrawRectangle(I, tempX(1)-u*X, tempY(1)-v*Y, tempX(2)-tempX(1), tempY(2)-tempY(1));
    fn = sprintf('./output/%d.jpg', i);
    imwrite(I, fn);
end

end

function [u, v, lost] = OpticalFlow(T, I, inds)

count = 0;
maxIterations = 10; % maximum number of iterations
eps = 0.001;        % accuracty desired in terms of pixel-width

u = 0; v = 0;
uv = [1; 1]; %initialize to dummy values

% stopping criterion for the Newton-Raphson like iteration:
% either the norm of the frame shift is less than 'eps'
% or maxIterations have been done
while (norm(uv) > eps && count < maxIterations)
    count = count + 1;

    J = Translate(I, u, v);
    [Ix, Iy] = gradient(J);
    Ix = Ix * size(I, 2);
    Iy = Iy * size(I, 1);
    H = zeros(2, 2); E = zeros(2, 1);
    for ind = inds
        Ixy = [Ix(ind); Iy(ind)];
        H = H + Ixy * Ixy';
        E = E + Ixy * (J(ind) - T(ind));
    end
    uv = H \ E;
    %disp([count, norm(uv)]);
    du = uv(1); dv = uv(2);
    u = u + du; v = v + dv;
end

lost = (count >= maxIterations);

end

function [image] = Translate(image, u, v)
[Y, X] = size(image);
A = [1, 0, 0;
     0, 1, 0;
     u*X, v*Y, 1];
image = imwarp(image, affine2d(A), 'OutputView', imref2d(size(image)));
end

function [I] = DrawRectangle(I, X, Y, W, H)
I = repmat(I, [1, 1, 3]);
X = uint32(X); Y = uint32(Y); W = uint32(W); H = uint32(H);
for w = 0 : W
    I(Y, X + w, :) = [1, 0, 0];
    I(Y + H, X + w, :) = [1, 0, 0];
end
for h = 0 : H
    I(Y + h, X, :) = [1, 0, 0];
    I(Y + h, X + W, :) = [1, 0, 0];
end
end
