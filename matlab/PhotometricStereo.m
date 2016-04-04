function [] = PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere)

    function [Y, X] = GetImageSize(ImageName)
        [Y, X, ~] = size(imread(sprintf('%s1.png', ImageName)));
    end

    function [RefNormal] = GetSphereRefNormal(ImageName)
        mask = imread(sprintf('%smask.png', ImageName));
        fg = mask >= 64;
        R = max(sum(fg)) / 2;
        s = regionprops(fg, 'centroid');
        cx = s.Centroid(1);
        cy = s.Centroid(2);
        [Y, X] = size(fg);
        sqn = zeros(Y, X, 3);
        for x = 1 : X
            for y = 1 : Y
                if fg(y, x)
                    v = [x-cx, y-cy, sqrt(R^2 - (x-cx)^2 - (y-cy)^2)];
                    sqn(y, x, :) = v / norm(v);
                else
                    sqn(y, x, :) = [0, 0, 0];
                end
            end
        end
        RefNormal = reshape(sqn, Y * X, 3);
        RefNormal = RefNormal(fg, :);
    end

    function [RefNormal] = GetCylinderRefNormal(ImageName)
        mask = imread(sprintf('%smask.png', ImageName));
        fg = mask >= 64;
        R = max(sum(fg, 2)) / 2;
        s = regionprops(fg, 'centroid');
        cx = s.Centroid(1);
        [Y, X] = size(fg);
        sqn = zeros(Y, X, 3);
        for x = 1 : X
            for y = 1 : Y
                if fg(y, x)
                    v = [x-cx, 0, sqrt(R^2 - (x-cx)^2)];
                    sqn(y, x, :) = v / norm(v);
                else
                    sqn(y, x, :) = [0, 0, 0];
                end
            end
        end
        RefNormal = reshape(sqn, Y * X, 3);
        RefNormal = RefNormal(fg, :);
    end

    function [OV] = MaskedCombinedOV(ImageName, NumberOfImages, fillNaN)
        mask = imread(sprintf('%smask.png', ImageName));
        mask = double(mask(:)');
        bg = mask < 64;
        OVr = createObjectVectors(ImageName, NumberOfImages, 1);
        OVg = createObjectVectors(ImageName, NumberOfImages, 2);
        OVb = createObjectVectors(ImageName, NumberOfImages, 3);
        OV = [OVr; OVg; OVb];
        if fillNaN
            OV(:, bg) = NaN;
        else
            OV = OV(:, ~bg);
        end
    end

    function [Normal] = MatchNormal(TargetOV, TY, TX, RefOV, RefNormal)
        IDX = kdtreeidx2(RefOV, TargetOV);

        Normal = zeros(TY, TX, 3);
        i = 0;
        for x = 1 : TX
            for y = 1 : TY
                i = i + 1;
                idx = IDX(i);
                if idx == 0
                    Normal(y, x, :) = [0, 0, 0];
                else
                    Normal(y, x, :) = RefNormal(idx, :);
                end
            end
        end
    end

    function [Z] = WipeBgOut(Z, ImageName)
        mask = imread(sprintf('%smask.png', ImageName));
        mask = double(mask);
        bg = mask < 64;
        Z(bg) = NaN;
    end

    if isRefASphere
        RefNormal = GetSphereRefNormal(RefImageName);
    else
        RefNormal = GetCylinderRefNormal(RefImageName);
    end

    [TY, TX] = GetImageSize(TargetImageName);

    TargetOV = MaskedCombinedOV(TargetImageName, NumberOfImages, true);
    RefOV = MaskedCombinedOV(RefImageName, NumberOfImages, false);

    Normal = MatchNormal(TargetOV, TY, TX, RefOV, RefNormal);
    [~, Z] = integrability2(Normal, [], 2^nextpow2(TY), 2^nextpow2(TX));
    Z = WipeBgOut(Z, TargetImageName);

    figure('Position', [100, 100, 800, 600]);
    surf(Z);
    axis equal;
    colormap jet;
    saveas(gcf, sprintf('../result/%s.fig', TargetImageName));
end
