% by Gyumin Sim
%
% To run this script:
%
% 1. The current directory should be '/matlab/'.
% 2. There should be '/result/' directory and other image directories in
%    the parent directory of the current directory.
% 3. The kdtree library should be built, and
%    the binaries and the involving '.m' files should be in
%    '/matlab/kdtree_bin/' directory.

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
