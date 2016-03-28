%
% KDTREEIDX2 Find closest points using a k-D tree.
% 
%  IDX = KDTREEIDX2( REF_OBJVEC, MODEL_OBJVEC ) finds the closest points in
%  REF_OBJVEC for each point in MODEL_OBJVEC. The search is performed in an
%  efficient manner by building a k-D tree from the datapoints in
%  REF_OBJVEC, and querying the tree for each datapoint in
%  MODEL_OBJVEC.
%
%  Input :
%    REF_OBJVEC is an DxN matrix, where each row is a D-dimensional
%    point. MODEL_OBJVEC is an DxM matrix, where each row is a D-dimensional
%    query point. 
%
%  Output:
%    IDX is a vector of length M. The i-th value of IDX is the row
%    index into the matrix REF_OBJVEC, which is the closest point to
%    the i-th row (point) of MODEL_OBJVEC. The "closest"  metric is
%    defined as the D-dimensional Euclidean (2-norm) distance.
%    The closest point values can be found by: CP = REF_OBJVEC(IDX,:)
%
%  
%  This Function simply calls the "kdtreeidx" with the transpose of the input
%  variables provided. That is, this function executes the call:
%    IDX = KDTREEIDX( REF_OBJVEC', MODEL_OBJVEC' )
%  Since the original "kdtreeidx" function uses the transposed version of the 
%  reference and model sets.
%

function idx = kdtreeidx2( ref_objvec, model_objvec )

idx = kdtreeidx( ref_objvec', model_objvec' );
