function [Iwarp, Imerge] = warpImage(Iin, Iref, H)
    Iin = double(Iin); Iref = double(Iref);
    [szY, szX, C] = size(Iin);

    function [i] = peek(x, y)
        if x < 1 || x > szX || y < 1 || y > szY
            i = [NaN; NaN; NaN];
        else
            i = Iin(y, x, :);
            i = i(:);
        end
    end

    tl = H * [0; 0; 1];                 tl = tl ./ tl(3);
    tr = H * [szX + 0.5; 0; 1];         tr = tr ./ tr(3);
    bl = H * [0; szY + 0.5; 1];         bl = bl ./ bl(3);
    br = H * [szX + 0.5; szY + 0.5; 1]; br = br ./ br(3);

    minX = floor(min([tl(1), tr(1), bl(1), br(1)]));
    maxX = ceil (max([tl(1), tr(1), bl(1), br(1)]));
    minY = floor(min([tl(2), tr(2), bl(2), br(2)]));
    maxY = ceil (max([tl(2), tr(2), bl(2), br(2)]));

    Width = maxX - minX + 1;
    Height = maxY - minY + 1;

    function [i] = bilinear(x, y)
        x0 = floor(x); x1 = x0 + 1;
        y0 = floor(y); y1 = y0 + 1;
        tx = x - x0; ty = y - y0;
        i = (1 - tx) * (1 - ty) * peek(x0, y0) + ...
            (1 - tx) * ty       * peek(x0, y1) + ...
            tx       * (1 - ty) * peek(x1, y0) + ...
            tx       * ty       * peek(x1, y1);
    end

    Iwar = zeros(Height, Width, C);
    for x = 1 : Width
        for y = 1 : Height
            v = [x - 0.5 + minX; y - 0.5 + minY; 1];
            v = H \ v;
            v = v ./ v(3);
            Iwar(y, x, :) = bilinear(v(1), v(2));
        end
    end
    Iwarp = uint8(Iwar);

    % merge
    if minX < 1
        Iref = padarray(Iref, [0, 1 - minX], NaN, 'pre');
    elseif minX > 1
        Iwar = padarray(Iwar, [0, minX - 1], NaN, 'pre');
    end
    if minY < 1
        Iref = padarray(Iref, [1 - minY, 0], NaN, 'pre');
    elseif minY > 1
        Iwar = padarray(Iwar, [minY - 1, 0], NaN, 'pre');
    end
    [heightR, widthR, ~] = size(Iref);
    [heightW, widthW, ~] = size(Iwar);
    if widthR < widthW
        Iref = padarray(Iref, [0, widthW - widthR], NaN, 'post');
    elseif widthR > widthW
        Iwar = padarray(Iwar, [0, widthR - widthW], NaN, 'post');
    end
    if heightR < heightW
        Iref = padarray(Iref, [heightW - heightR, 0], NaN, 'post');
    elseif heightR > heightW
        Iwar = padarray(Iwar, [heightR - heightW, 0], NaN, 'post');
    end
    [Y, X, C] = size(Iref);
    Imerge = zeros(Y, X, C);
    for y = 1 : Y
        for x = 1 : X
            Vref = Iref(y, x, :);
            Vwarp = Iwar(y, x, :);
            if any(isnan(Vref))
                Imerge(y, x, :) = Vwarp;
            elseif any(isnan(Vwarp))
                Imerge(y, x, :) = Vref;
            else
                Imerge(y, x, :) = (Vref + Vwarp) / 2;
            end
        end
    end
    Imerge = uint8(Imerge);
end
