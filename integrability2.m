function [Ni,Z,Xi]=integrability2(N,X,nrows,ncols)
%INTEGRABILITY2  Integrable surface for rectangular window
%  INTEGRABILITY2(N) takes an PxQx3 field of normal vectors (the third
%  dimension is [x y z]) and returns an integrable set of
%  normal vectors (the same size as N).
%
%  [Ni,Z]=INTEGRABILITY2(N) also returns the PxQ surface depth values.
%
%  [Ni,Z,Xi]=INTEGRABILITY2(N,X) uses the surface defined by the PxQx3 array X
%  to obtain the DC component of the Fourier transform (otherwise this
%  is set to 0).  Also, the integrated surface is returned as the array Xi.
%
%
%  [Ni,Z,Xi]=INTEGRABILITY2(N,X,nrows,ncols) or 
%
%  [Ni,Z,Xi]=INTEGRABILITY2(N,[],nrows,ncols) pads the surface slopes with zeros
%
%  so that it has nrows rows and ncols columns before performing the 
%
%  fourier expansion.
%
%
%  Remarks
%  -------
%    This is a faster implementation than INTEGRABILITY.  Note that P, Q
%    must be EVEN if you are not padding the slopes.
%
%  See also INTEGRABILITY
%
%  Todd Zickler, Yale University, November 2001

if nargin < 2
  X=[];
end
if nargin<3

   nrows=[]; ncols=[];

end


[h,w]=size(N(:,:,1));

% make sure x and y sampling rates are uniform (This is only used when input

% X is defined.  When X is not defined, the spacing between samples of the

% normal field is assumed to be 1 in both dimensions.)

if ~isempty(X)
   TOL = 1e-12;    % tolerance for equality
   if sum(abs((column(X(:,2:end,1)-X(:,1:end-1,1)))-(X(1,2,1)-X(1,1,1)))>TOL)|...
         sum(abs((column(X(2:end,:,1)-X(1:end-1,:,1)))-(X(2,1,1)-X(1,1,1)))> ...
         TOL)
      disp('WARNING: (x,y) components of X may not be uniform grid');
   end

end

% get surface slopes from normals; ignore points where normal is [0 0 0]
% If X is defined, use it to determine spacing between samples of the

% normal field.

if ~isempty(X)

   x_sample=abs(X(1,2,1)-X(1,1,1));
   y_sample=abs(X(2,1,2)-X(1,1,2));
else

   x_sample=1;

   y_sample=1;

end

zx=-x_sample*(sum(N,3)~=0).*N(:,:,1)./(N(:,:,3)+(N(:,:,3)==0));
zy=-y_sample*(sum(N,3)~=0).*N(:,:,2)./(N(:,:,3)+(N(:,:,3)==0));   

   
% compute Fourier coefficients
if isempty(nrows)

   Zx=fft2(zx);
   Zy=fft2(zy);

   h2=h;w2=w;
else

   Zx=fft2(zx,nrows,ncols);
   Zy=fft2(zy,nrows,ncols);

   h2=nrows; w2=ncols;
end

Zx=Zx(:); Zy=Zy(:);


% compute repeated frequency vectors (See Chellapa paper)
Wy=repmat(2*pi/h2*[0:(h2/2), (-(h2/2)+1):(-1)]',w2,1);
Wx=kron(2*pi/w2*[0:(w2/2), (-(w2/2)+1):(-1)]',ones(h2,1));

% compute transform of least squares closest integrable surface
%    remove first column because it's all zeros (then add C(0)=0)
C=(-j*Wx(2:end).*Zx(2:end)-j*Wy(2:end).*Zy(2:end))./...
  (Wx(2:end).^2+Wy(2:end).^2);

% set DC component of C
if isempty(X)
  C=[0;C];
else
  Cx=fft2(X(:,:,3));
  C=[Cx(1,1); C];
end

% invert transform to get depth of integrable surface
Z=real(ifft2(reshape(C,h2,w2)));

% invert transform of derivatives to get corresponding slopes of integrable

% surface. (simply given as: Sx=ifft2(2*j*pi*u/w*C(u,v))
Sx=real(ifft2(reshape(C.*kron(2*j*pi*[0:(w2/2), (-w2/2+1):(-1)]'./w2,...
			      ones(h2,1)),h2,w2)));
Sy=real(ifft2(reshape(C.*repmat(2*j*pi*[0:(h2/2), (-h2/2+1):(-1)]'./h2,...
				w2,1),h2,w2)));
         

         

% compensate for x/y sampling in estimated slopes

Sx=Sx./x_sample; Sy=Sy./y_sample;

         

% crop output if there was padding         

if ~isempty(nrows)

   Z=Z(1:h,1:w);

   Sx=Sx(1:h,1:w);

   Sy=Sy(1:h,1:w);

end   

         
% convert surface slopes to unit normal vectors
Ni(:,:,1)=-Sx./sqrt(Sx.^2+Sy.^2+ones(h,w));
Ni(:,:,2)=-Sy./sqrt(Sx.^2+Sy.^2+ones(h,w));
Ni(:,:,3)=1./sqrt(Sx.^2+Sy.^2+ones(h,w));

% save integrated surface as a mesh
if ~isempty(X)
  Xi=X;
  Xi(:,:,3)=Z;
else

   [x y]=meshgrid(1:w,1:h);

   Xi=x; Xi(:,:,2)=y; Xi(:,:,3)=Z;

end







