classdef BoundingBoxTreeNode < handle
%Class: BoundingBoxTreeNode
%
%Nov 15, 2018
%Written by Tian Xie, Austin Shin
%==========================================================================
    properties
        Center;
        UpperBound;
        LowerBound;
        HaveSubtrees;
        nSpheres;
        Spheres;
        MaxRadius;
        SubTree1; %Eight subtrees
        SubTree2;
        SubTree3;
        SubTree4;
        SubTree5;
        SubTree6;
        SubTree7;
        SubTree8;
    end
    
    methods
        % Constructor
        function obj = BoundingBoxTreeNode(BS, nS)
            if nargin > 0
                obj.Spheres = BS;
                obj.nSpheres = nS;
                FindMaxRadius(obj);
                FindCentroidnMaxnMin(obj);
                ConstructSubtrees(obj);
            end
        end
        %Split spheres into 8 subtrees
        function [subtreeSphereIndex,nnn,npn,npp,nnp,pnn,ppn,ppp,pnp] = SplitSort(obj)
            splitPt = obj.Center;
            spheres = obj.Spheres;
            num = obj.nSpheres;
            subtreeSphereIndex = zeros(8,num);
            nnn = 0; 
            npn = 0; 
            npp = 0; 
            nnp = 0; 
            pnn = 0; 
            ppn = 0;
            ppp = 0;
            pnp = 0;
            for i = 1: num
                %nnn
                if spheres(i).sphereCenter(1) < splitPt(1)&& ...
                        spheres(i).sphereCenter(2) < splitPt(2)&& ...
                        spheres(i).sphereCenter(3) < splitPt(3)
                    subtreeSphereIndex(1,nnn+1) = i;
                    nnn = nnn+1;
                end
                %npn
                if spheres(i).sphereCenter(1) < splitPt(1)&& ...
                        spheres(i).sphereCenter(2) > splitPt(2)&& ...
                        spheres(i).sphereCenter(3) < splitPt(3)
                    subtreeSphereIndex(2,npn+1) = i;
                    npn = npn+1;
                end
                %npp
                if spheres(i).sphereCenter(1) < splitPt(1)&& ...
                        spheres(i).sphereCenter(2) > splitPt(2)&& ...
                        spheres(i).sphereCenter(3) > splitPt(3)
                    subtreeSphereIndex(3,npp+1) = i;
                    npp = npp+1;
                end
                %nnp
                if spheres(i).sphereCenter(1) < splitPt(1)&& ...
                        spheres(i).sphereCenter(2) < splitPt(2)&& ...
                        spheres(i).sphereCenter(3) > splitPt(3)
                    subtreeSphereIndex(4,nnp+1) = i;
                    nnp = nnp+1;
                end
                %pnn
                if spheres(i).sphereCenter(1) > splitPt(1)&& ...
                        spheres(i).sphereCenter(2) < splitPt(2)&& ...
                        spheres(i).sphereCenter(3) < splitPt(3)
                    subtreeSphereIndex(5,pnn+1) = i;
                    pnn = pnn+1;
                end
                %ppn
                if spheres(i).sphereCenter(1) > splitPt(1)&& ...
                        spheres(i).sphereCenter(2) > splitPt(2)&& ...
                        spheres(i).sphereCenter(3) < splitPt(3)
                    subtreeSphereIndex(6,ppn+1) = i;
                    ppn = ppn+1;
                end
                %ppp
                if spheres(i).sphereCenter(1) > splitPt(1)&& ...
                        spheres(i).sphereCenter(2) > splitPt(2)&& ...
                        spheres(i).sphereCenter(3) > splitPt(3)
                    subtreeSphereIndex(7,ppp+1) = i;
                    ppp = ppp+1;
                end
                %pnp
                if spheres(i).sphereCenter(1) > splitPt(1)&& ...
                        spheres(i).sphereCenter(2) < splitPt(2)&& ...
                        spheres(i).sphereCenter(3) > splitPt(3)
                    subtreeSphereIndex(8,pnp+1) = i;
                    pnp = pnp+1;
                end
            end  
        end
        %Construct subtrees
        function [obj] = ConstructSubtrees(obj)
            %min num spheres:75(?) and min bound length:20(?)
            if (obj.nSpheres <= 25 || norm(obj.UpperBound-obj.LowerBound) <= 25)
                obj.HaveSubtrees = false;
                return;
            end
            obj.HaveSubtrees = true;
            [subtreeSphereIndex,nnn,npn,npp,nnp,pnn,ppn,ppp,pnp] = SplitSort(obj);
            nnnSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(1,:)));
            npnSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(2,:)));
            nppSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(3,:)));
            nnpSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(4,:)));
            pnnSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(5,:)));
            ppnSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(6,:)));
            pppSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(7,:)));
            pnpSpheres = obj.Spheres(nonzeros(subtreeSphereIndex(8,:)));
            obj.SubTree1 = BoundingBoxTreeNode(nnnSpheres,nnn);
            obj.SubTree2 = BoundingBoxTreeNode(npnSpheres,npn);
            obj.SubTree3 = BoundingBoxTreeNode(nppSpheres,npp);
            obj.SubTree4 = BoundingBoxTreeNode(nnpSpheres,nnp);
            obj.SubTree5 = BoundingBoxTreeNode(pnnSpheres,pnn);
            obj.SubTree6 = BoundingBoxTreeNode(ppnSpheres,ppn);
            obj.SubTree7 = BoundingBoxTreeNode(pppSpheres,ppp);
            obj.SubTree8 = BoundingBoxTreeNode(pnpSpheres,pnp);  
        end
        
    end
    
    methods (Access = private)
        %set maximum radius      
        function [obj] = FindMaxRadius(obj)
            BS = obj.Spheres;
            nS = obj.nSpheres;
            r = zeros(nS,1);
            for i = 1:nS
                r(i) = BS(i).sphereRadius;
            end 
            obj.MaxRadius = max(r);
        end
        %set the center, max and min coordinates
        function [obj] = FindCentroidnMaxnMin(obj)
            BS = obj.Spheres;
            nS = obj.nSpheres;
            centers = zeros(nS,3);
            for i =1:nS
                centers(i,:) = BS(i).sphereCenter;
            end
            obj.Center = mean(centers,1);
            if obj.nSpheres == 1
                obj.UpperBound = obj.Center;
                obj.LowerBound = obj.Center;
            else
                obj.UpperBound = max(centers);
                obj.LowerBound = min(centers);
            end 
            
        end
                 
    end
    
    methods 
        %Find the closest point
        function [] = FindClosestPoint(obj,v,bound,closest)
            if obj.nSpheres == 0
                return;
            end
            if (v(1) + bound.value < obj.LowerBound(1) - obj.MaxRadius) || ...
                    (v(1) - bound.value > obj.UpperBound(1) + obj.MaxRadius) || ...
                    (v(2) + bound.value < obj.LowerBound(2) - obj.MaxRadius) || ...
                    (v(2) - bound.value > obj.UpperBound(2) + obj.MaxRadius)|| ...
                    (v(3) + bound.value < obj.LowerBound(3) - obj.MaxRadius) || ...
                    (v(3) - bound.value > obj.UpperBound(3) + obj.MaxRadius)
                return;
            end
            if obj.HaveSubtrees
                obj.SubTree1.FindClosestPoint( v, bound, closest);
                obj.SubTree2.FindClosestPoint( v, bound, closest);
                obj.SubTree3.FindClosestPoint( v, bound, closest);
                obj.SubTree4.FindClosestPoint( v, bound, closest);
                obj.SubTree5.FindClosestPoint( v, bound, closest);
                obj.SubTree6.FindClosestPoint( v, bound, closest);
                obj.SubTree7.FindClosestPoint( v, bound, closest);
                obj.SubTree8.FindClosestPoint( v, bound, closest);
            else
                UpdateClosest(obj, v, bound, closest);
                
            end
            
        end
        %Update the closest point, here bound and closest are passed by
        %handle
        function [] = UpdateClosest(obj, v, bound, closest)
                for i = 1:obj.nSpheres
                    dist = norm(obj.Spheres(i).sphereCenter - v);
                    if dist - bound.value <= obj.Spheres(i).sphereRadius
                        t = obj.Spheres(i).triangle;
                        cp = findClosestPoint(v,t(1,:),t(2,:),t(3,:));
                        if norm(cp - v) < bound.value
                            closest.value = cp;
                            bound.value = norm(cp-v);
                        end
                    end
                end
              
        end
                
    end         
                    
            
end