classdef agent
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        position
        infected = 0
    end

    methods
        function obj = agent(pos)
            %Construct an instance of this class
            if nargin ~= 0
                obj.position = pos;
            end
        end

%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end