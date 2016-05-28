function m = getConfusionMatrix(numClasses, actualLabels, predictedLabels)
  m = zeros(numClasses, numClasses);
  n = length(actualLabels);
  for i = 1:n
    x = m(actualLabels(i), predictedLabels(i));
    m(actualLabels(i), predictedLabels(i)) = x + 1;
  end
end
