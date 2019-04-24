function [cs,time] = searchWithBoundingSpheres(dk,numT, triangleIndices,vertices)
%This function does the search with bounding spheres
%Input - dk
%        numT: number of triangles
%        triangleIndices: matrix store triangle indices
%        vertices: matrix store vertices
%Output - cs: ck values
%
%Written by Tian Xie

P = zeros(numT,3);
Q = zeros(numT,3);
R = zeros(numT,3);
%Coordinate of the three vertices of the triangles
for i = 1:numT
    vertexNum1 = triangleIndices(i,1)+1;
    vertexNum2 = triangleIndices(i,2)+1;
    vertexNum3 = triangleIndices(i,3)+1;
    P(i,:) = vertices(vertexNum1,:);
    Q(i,:) = vertices(vertexNum2,:);
    R(i,:) = vertices(vertexNum3,:);
end

%construct the spheres as the BoundingSphere object
spheres(numT,1) = BoundingSphere();
for i = 1:numT
    spheres(i) = BoundingSphere(P(i,:),Q(i,:),R(i,:));
end

numPts = size(dk,1);
cs = zeros(numPts,3);
% Find the closest point on the triangle
tic;
for j =1:numPts
    bound = 1000;
    for i = 1:numT
        if norm(spheres(i).sphereCenter-dk(j,:))-spheres(i).sphereRadius <= bound
            T = spheres(i).triangle;
            h = findClosestPoint(dk(j,:),T(1,:),T(2,:),T(3,:));
            if norm(h-dk(j,:)) < bound
                ck = h;
                bound = norm(h-dk(j,:));
            end
        end
    end
    cs(j,:) = ck;
end
time = toc;
end
