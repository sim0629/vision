function pooledFeatures = cnnPool(poolDim, convolvedFeatures)
%cnnPool Pools the given convolved features
%
% Parameters:
%  poolDim - dimension of pooling region
%  convolvedFeatures - convolved features to pool (as given by cnnConvolve)
%                      convolvedFeatures(featureNum, imageNum, imageRow, imageCol)
%
% Returns:
%  pooledFeatures - matrix of pooled features in the form
%                   pooledFeatures(featureNum, imageNum, poolRow, poolCol)
%     

numImages = size(convolvedFeatures, 2);
numFeatures = size(convolvedFeatures, 1);
convolvedDim = size(convolvedFeatures, 3);

pooledFeatures = zeros(numFeatures, numImages, ceil(convolvedDim / poolDim), ceil(convolvedDim / poolDim));

% -------------------- YOUR CODE HERE --------------------
% Instructions:
%   Now pool the convolved features in regions of poolDim x poolDim,
%   to obtain the 
%   numFeatures x numImages x (convolvedDim/poolDim) x (convolvedDim/poolDim) 
%   matrix pooledFeatures, such that
%   pooledFeatures(featureNum, imageNum, poolRow, poolCol) is the 
%   value of the featureNum feature for the imageNum image pooled over the
%   corresponding (poolRow, poolCol) pooling region 
%   (see http://ufldl/wiki/index.php/Pooling )
%   
%   Use mean pooling here.
for imageNum = 1:numImages
  for featureNum = 1:numFeatures
    for r = 1:poolDim:convolvedDim
      for c = 1:poolDim:convolvedDim
        region = convolvedFeatures(featureNum, imageNum, r:min(r+poolDim-1,convolvedDim), c:min(c+poolDim-1,convolvedDim));
        average = mean(region(:));
        pooledFeatures(featureNum, imageNum, (r-1)/poolDim+1, (c-1)/poolDim+1) = average;
      end
    end
  end
end
% -------------------- YOUR CODE HERE --------------------

end

