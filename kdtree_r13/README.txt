As mentioned by the author of this library (in the AUTHOR_NOTES.txt),
there are pre-compiled version of the library available for the mentioned 
operating systems and matlab version. However, I recommend that you 
compile the library again for your system and use the .dll, .mexglx, or .mexmac 
files for your own system.

Instructions to compile the library.
1) "cd" into that directory (~/kdtree/src) from within matlab.
2) Type: "edit kdtree_common.h"
3) Depending on your operating system, you need to un-comment/comment the 
   appropriate lines in the includes at the top of the file.
   ***********Code Extract from "kdtree_common.h"***********
   // Uncomment one of these includes depending on your architecture.
   // Your installation location may vary.
   //
   //
   // For Linux use this line:
   //
   //#include "/usr/local/matlab/extern/include/mex.h"
   //
   //
   // For Windows systems use this line:
   //
   //#include "c:\matlab6p5\extern\include\mex.h"
   //
   //
   // For Mac Os X systems use this line :
   //
   //#include "/Applications/MATLAB6p5p1/extern/include/mex.h"
   //
   //
   *********************************************************
4) Ensure that the line that you un-commented is for your operating system
   and that it correctly refers to the "mex.h" file that it requires.
   You can find the location of this file by simply using the "file search" 
   options in mac and windows. And in linux you can use the command "locate mex.h", 
   to find the location of the file.
   Please contact your TA (Junhyug - jh.noh@vision.snu.ac.kr) if you need help with this.
5) Once you have properly modified the file, you need to now setup the mex compiler
   within matlab. To do this, type the command "mex -setup" in matlab's command window.
6) Select any one of the listed compilers (gcc, lcc, MS Visual C++, etc...)
   (If asked "Would you like mex to locate installed compilers [y]/n?"... type "y")
7) Once you have selected a compiler type the below commands to compile the kdtree library.
   - "mex -v -g -O -argcheck kdtree.cpp"
   - "mex -v -g -O -argcheck kdtreeidx.cpp"
   - "mex -v -g -O -argcheck kdrangequery.cpp"
   Note, if these commands fail, try using the below commands (Thanks Ted Square for this info.):
   - "mex -DARGCHECK -v -g kdtree.cpp"
   - "mex -DARGCHECK -v -g kdtreeidx.cpp"
   - "mex -DARGCHECK -v -g kdrangequery.cpp"
8) If there are no errors during compile, it means that the library is ready for use.
9) If you open a shell/window and look at directory "~/kdtree_r13/src/", you will observe that
   there will be new files created in there with the extensions .dll, .mexglx, or .mexmac
   (depending on the operating system). You now need to copy these files into the directory 
   which contains your code for the assignment (call this the "current_working_dir").
10)You will also need to copy all the m-files from the "~/kdtree_r13/" directory into the 
   "current_working_dir" also. These files include: (kdtree.m, kdtreeidx.m, kdtreeidx2.m,
   kdrangequery.m, kdtree_demo.m, and kdrange_demo.m).
11)Once you have copied the files into the "current_working_dir", you can then "cd" into the 
   directory within matlab and call "help" for these files to see their usage. To test the 
   kdtree library, I suggest you try the command "kdtree_demo". This tests all parts of the 
   library that is necessary for this assignment (kdtreeidx2.m, which calls kdtreeidx.m).
12)Now you can pat yourself in the back for successfully compiling the kdtree library. 

Good Luck with the rest of the assignment! :)
