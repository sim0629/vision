% this scripts assumes that you are in the YOURCODE directory.
% and there is TextureLibrary.mat in the same directory.

load('TextureLibrary.mat');
[N, ~] = size(TextonLibrary);

classes = cellstr(['Canvas'; 'Chips '; 'Grass '; 'Seeds '; 'Straw ']);
for i = 1 : length(classes)
    class = char(classes{i});
    dirname = sprintf('../train%s', class);
    d = dir(dirname);
    his = zeros(N, 1);
    for j = 1 : length(d)
        filename = d(j).name;
        [~, ~, ext] = fileparts(filename);
        if strcmp(ext, '.bmp') || strcmp(ext, '.tiff')
            img = imread(sprintf('%s/%s', dirname, filename));
            vectors = extractResponseVectors(img);
            dists = zeros(size(vectors, 1), N);
            for k = 1 : N
                texton = TextonLibrary(k, :);
                diff = bsxfun(@minus, vectors, texton);
                dists(:, k) = sum(diff .^ 2, 2);
            end
            [~, I] = min(dists, [], 2);
            for k = 1 : N
                his(k) = his(k) + sum(I == k);
            end
        end
    end
    his = his ./ sum(his);
    varname = sprintf('%s_histogram', class);
    eval([varname '= his;']);
end

save('Histograms.mat', 'Canvas_histogram', 'Chips_histogram', 'Grass_histogram', 'Seeds_histogram', 'Straw_histogram');
