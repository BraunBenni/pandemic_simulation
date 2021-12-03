classdef agent
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        position
    end

    methods
        function obj = agent(pos)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.position = pos;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end