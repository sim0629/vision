function [moving_image] = SubtractDominantMotion(image1, image2)
% Returns a bw image that represents the moving part between two consecutive images.
% Finds the dominant motion from image1 to image2 and subtract it from image2.

% normalize pixel values in [0, 1]
if max(max(image1)) > 1
    image1 = image1 / 255;
    image2 = image2 / 255;
end

p = FindDominantMotion(image1, image2);
image1_moved = Warp(image1, p);
image1_moved(image1_moved == 0) = NaN;
image_diff = image2 - image1_moved;
moving_image = hysthresh(image_diff, 0.5, 0.25);
se = strel('square', 5);
moving_image = imdilate(moving_image, se);

end

function [p] = FindDominantMotion(image1, image2)
% Apply Lukas-Kanade

% Set initial parameter
p = [0; 0; 0; 0; 0; 0];

% pre-calculate gradient
[Ix, Iy] = gradient(image1);
[Y, X] = size(image1);
Ix = Ix * X; Iy = Iy * Y;

% iterate
prev_norm = Inf;
MAX_ITER = 30;
for iter = 1 : MAX_ITER
    image1_warped = Warp(image1, p);
    error_image = image2 - image1_warped;
    gIx = Warp(Ix, p); gIy = Warp(Iy, p);

    Updates = zeros(6, 1);
    Hessian = zeros(6, 6);
    for x = 1 : X
        for y = 1 : Y
            if image1_warped(y, x) == 0
                continue
            end

            gI = [gIx(y, x), gIy(y, x)];
            jb = [x/X, 0, y/Y, 0, 1, 0;
                  0, x/X, 0, y/Y, 0, 1];
            sdit = gI * jb;
            sdi = sdit';

            Updates = Updates + sdi * error_image(y, x);
            Hessian = Hessian + sdi * sdit;
        end
    end

    dp = Hessian \ Updates;
    curr_norm = norm(dp);
    if curr_norm > prev_norm
        break;
    end
    prev_norm = curr_norm;

    p = p + dp;
    if curr_norm < 1e-3
        break
    end
end

end

function [image] = Warp(image, p)
[Y, X] = size(image);
A = [1+p(1), p(3), p(5)*X;
     p(2), 1+p(4), p(6)*Y;
     0, 0, 1];
image = imwarp(image, affine2d(A'), 'OutputView', imref2d([Y, X]));
end
