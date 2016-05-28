function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);

numCases = size(data, 2);

groundTruth = full(sparse(labels, 1:numCases, 1));

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.

% note that if we subtract off after taking the exponent, as in the
% text, we get NaN

tx = theta * data;
tx = bsxfun(@minus, tx, max(tx)); % prevent overflow
etx = exp(tx);
pred = bsxfun(@rdivide, etx, sum(etx));

thetagrad = (-1/numCases) * (groundTruth - pred) * data' + lambda * theta;
cost = (-1/numCases) * sum(sum(groundTruth .* log(pred))) + lambda / 2 * sum(sum(theta.^2));

% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = thetagrad(:);
end

