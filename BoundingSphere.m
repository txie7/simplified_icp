classdef BoundingSphere
%Class: BoundingSphere
%
%Nov 14, 2018
%Written by Tian Xie
%==========================================================================
    properties
       sphereCenter; %1x3 matrix: center
       sphereRadius; %radius
       triangle;     %3x3 matrix: corresponding triangle 
                     %(Each row presents one vertex.)
    end
    
    methods
        function obj = BoundingSphere(a0,b0,c0)
            if nargin > 0
                obj.triangle = [a0;b0;c0];
                %Find bounding sphere:
                %1. Find the longest edge
                e1 = norm(a0-b0);
                e2 = norm(c0-a0);
                e3 = norm(b0-c0);
                [~,longest] = max([e1,e2,e3]); 
                a = a0; b = b0; c = c0;
                if longest == 2
                    b = c0; c = b0;
                end
                if longest == 3
                    a = c0; c = a0;
                end
                %2. Find center and radius      
                f = (a+b)/2;
                u = a-f;
                v = c-f;
                d = cross(cross(u,v),v);
                gamma = (v*v'-u*u')/(2*d*(v-u)');
                lambda = max([0,gamma]);
                obj.sphereCenter = f+lambda*d;
                obj.sphereRadius = norm(obj.sphereCenter-a);
            end
        end
    end

end
       