dir_car = '../data/frames';

%input parameter
sigma = 10;
num_frames = 713;

test_motion(dir_car,num_frames);
trackTemplate(dir_car,sigma);