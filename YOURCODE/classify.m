function [class] = classify(img)

    function [d] = chisq(x, y)
        d = sum((x - y) .^ 2 ./ (x + y + eps)) / 2;
    end

    lib = load('TextureLibrary.mat');
    [N, ~] = size(lib.TextonLibrary);
    his = zeros(N, 1);
    vectors = extractResponseVectors(img);
    dists = zeros(size(vectors, 1), N);
    for k = 1 : N
        texton = lib.TextonLibrary(k, :);
        diff = bsxfun(@minus, vectors, texton);
        dists(:, k) = sum(diff .^ 2, 2);
    end
    [~, I] = min(dists, [], 2);
    for k = 1 : N
        his(k) = his(k) + sum(I == k);
    end
    his = his ./ sum(his);

    chisqs = zeros(5, 1);
    hist = load('Histograms.mat');
    chisqs(1) = chisq(his, hist.Canvas_histogram);
    chisqs(2) = chisq(his, hist.Chips_histogram);
    chisqs(3) = chisq(his, hist.Grass_histogram);
    chisqs(4) = chisq(his, hist.Seeds_histogram);
    chisqs(5) = chisq(his, hist.Straw_histogram);
    [~, I] = min(chisqs);
    classes = cellstr(['Canvas'; 'Chips '; 'Grass '; 'Seeds '; 'Straw ']);
    class = char(classes{I});
end
