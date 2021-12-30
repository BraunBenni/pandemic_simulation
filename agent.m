classdef agent

    properties
        position
        infected = 0
        quarantine  = 0
        old_positions = []
        old_infection_status = []
        old_quarantine_status = []
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
            %   Makes sure, that agents doesn't leave the square defined by
            %   max_xy
            %   Saves position in property old_positions
            
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

        function obj = savePos(obj)
            %Function to save current position in old_position array
            obj.old_positions = [obj.old_positions, obj.position];
        end

        function obj = saveInfectionStatus(obj)
            %Function to save current infection status in old_infections_status array
            obj.old_infection_status = [obj.old_infection_status, obj.infected];
            
        end

        function obj = saveQuarantineStatus(obj)
            %Function to save current quarantine stauts in old_quarantine_status array
            obj.old_quarantine_status = [obj.old_quarantine_status, obj.quarantine];
        end

    end

end