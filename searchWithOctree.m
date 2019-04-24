function [c] = searchWithOctree(dk,treenodes,initialBound)
%This function does the search with bounding spheres
%Input - dk
%        treenodes: the Octree
%        initialBound: the initial bound for search
%Output - c: ck values
%
%Written by Tian Xie
% ========================================================================
numPts = size(dk,1);
% treenodes = BoundingBoxTreeNode(spheres,numT);
c = zeros(numPts,3);
bound = numHandle(0);
ck = numHandle([0,0,0]);

for j = 1:numPts
    bound.value =initialBound(j);
    ck.value=[0,0,0];
    treenodes.FindClosestPoint(dk(j,:),bound,ck);
    
    c(j,:) = ck.value;
    
end
