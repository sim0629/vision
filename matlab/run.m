addpath('kdtree_bin');
addpath('..');

addpath('../bottle');
PhotometricStereo('bottle', 'sphere', 8, true);
rmpath('../bottle');

addpath('../velvet');
PhotometricStereo('velvet', 'vcylinder', 14, false);
rmpath('../velvet');

addpath('../wavy');
PhotometricStereo('wavy', 'wcylinder', 14, false);
rmpath('../wavy');

rmpath('..');
rmpath('kdtree_bin');
