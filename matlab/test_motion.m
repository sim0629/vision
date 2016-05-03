function test_motion(path_to_images, numimages)


fname = sprintf('%s/%d.jpg',path_to_images,0);
img1 = double(imread(fname));
% create movie object
mov=VideoWriter('motion.avi','Motion JPEG AVI');
open(mov);

for frame = 1:numimages
    %Reads next image in sequence
    
    fname = sprintf('%s/%d.jpg',path_to_images,frame);
    img2 = double(imread(fname));
    
    % Runs the function to estimate dominant motion
    disp(['Processing pair of image ' num2str(frame-1) ' and ' num2str(frame)]);
    [motion_img] = SubtractDominantMotion(img1, img2);
    
    % Superimposes the binary image on img2, and adds it to the movie
    temp=uint8(img2);
    currframe=repmat(temp, [1, 1, 3]);
    temp(motion_img==1)=255;
    currframe(:,:,1)=temp;
    temp(motion_img==1)=0;
    currframe(:,:,2)=temp;
    currframe(:,:,3)=temp;
    
    hold off;
    imshow(currframe);
    hold on;
    drawnow;
    
    writeVideo(mov,currframe);
    
    img1 = img2;
end
close(mov);


% Success!
disp('Done! Showing movie (motion.avi)...');
movobj=VideoReader('motion.avi');
vidWidth = movobj.Width;
vidHeight = movobj.Height;
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
while hasFrame(movobj)
    mov(k).cdata = readFrame(movobj);
    k = k+1;
end
hf = figure;
movie(hf,mov,1,movobj.FrameRate);

%movie(mov,1,1);
