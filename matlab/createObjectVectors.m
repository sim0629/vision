function [ObjVec] = createObjectVectors(ImageName, NumberOfImages, ColorIndex)
    for i = 1 : NumberOfImages
        img = imread(sprintf('%s%d.png', ImageName, i));
        aChannel = img(:, :, ColorIndex);
        if i == 1
            [mSize, nSize] = size(aChannel);
            ObjVec = zeros(NumberOfImages, mSize * nSize);
        end
        ObjVec(i, :) = aChannel(:)';
    end
end
