classdef agent

    properties
        position
        infected = 0
        quarantine  = 0
    end

    methods
        function obj = agent(pos)
            %Construct an instance of this class
            if nargin ~= 0
                obj.position = pos;
            end
        end

        function obj = move(obj, vel_scaling, max_xy, timestep)
            %Function to move agent in square
            %   Makes sure, that agents doesn't leave it
            if obj.quarantine == 0
                direction = randi(360);
                vel = rand() * vel_scaling;
                move = obj.position + timestep * vel * [cosd(direction);sind(direction)];
                %check whether new position is in square
                if (move(1) < 0 || move(1) > max_xy) || (move(2) < 0 || move(2) > max_xy)
                    %outside square:
                    move = obj.position; %don't perform move and generate new step in next timestep
                end
                obj.position = move;
            end
        end

    end

end