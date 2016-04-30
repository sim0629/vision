function trackTemplate(path_to_car_sequence, sigma)

numimages = 700;
mkdir('./output/');

fname = sprintf('%s/%d.jpg',path_to_car_sequence,0);
F = double(imread(fname));

% Select the region of interest
figure; imshow(uint8(F));
title('first input image');
[tempX,tempY] = ginput(2);  % get two points from the user
close;
roi=zeros(size(F));
roi(tempY(1):tempY(2),tempX(1):tempX(2)) = 1 ;


for i=1:numimages
    sprintf('Image No. %d',i)
    
    % not on whole image:
    inds=find(roi);
    
    count=0;
    maxIterations = 3; % maximum number of iterations
    eps = 0.05;        % accuracty desired in terms of pixel-width
    
    u = 0; v = 0;
    du=1;dv=1;  %initialize to dummy values
    
    % stopping criterion for the Newton-Raphson like iteration:
    % either the frame shift is less than 'eps' of pixel width
    % or maxIterations have been done
    while ((abs(du) > eps | abs(dv) > eps) & count < maxIterations)
        count=count+1;
        % Implement your code
    end
    sprintf('No. of iterations: %d',count)
end
%Make your code, draw result and save in output folder.
end


