classdef numHandle < handle
%Class: numHandle
%
%Because MATLAB does not support pointer, this class handles the variables
%which should be passed by their references.
%
%Written by Tian Xie
%==========================================================================
    properties
        value;
    end
    
    methods
        function obj = numHandle(n)
            obj.value = n;
        end
    end
end
