% this scripts assumes that you are in the directory where the test images
% and the training images are.
cd('./YOURCODE');
dirname = '../testImages';
d = dir(dirname);

test_cnt = 0;
true_cnt = 0;

for i = 3:length(d)
    
        if strcmp(d(i).name,'Thumbs.db') ~= 1
            fname = sprintf('%s\\%s',dirname,d(i).name);
            im = imread(fname);

            class = classify(im);
            display(sprintf('%s : %s',fname,class));
            
            if( isempty(strfind(lower(fname),lower(class))) == 0 )
                true_cnt = true_cnt + 1;
            end
            test_cnt = test_cnt + 1;

            %input('next image')
        end
end
display(sprintf('%s : %0.2f','Accuracy',true_cnt/test_cnt));

cd('..');
