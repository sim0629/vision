% this scripts assumes that you are in the YOURCODE directory.

giantFeatureMatrix = [];
numberOfClusters = 8;

dirname = '../random';
d = dir(dirname);

for i = 1 : length(d)
    filename = d(i).name;
    [~, ~, ext] = fileparts(filename);
    if strcmp(ext, '.jpg') || strcmp(ext, '.tiff')
        img = imread(sprintf('%s/%s', dirname, filename));
        vectors = extractResponseVectors(img);
        [num, ~] = size(vectors);
        sampled = datasample(vectors, ceil(num / 100));
        giantFeatureMatrix = [giantFeatureMatrix; sampled];
    end
end

[~, TextonLibrary] = kmeans(giantFeatureMatrix, numberOfClusters, 'EmptyAction', 'drop');
save('../result/TextureLibrary.mat', 'TextonLibrary')
