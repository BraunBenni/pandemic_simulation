clear; clc; close all;

%% Initialising agents with random positions in max_xy square
n_agents = 10;
max_xy = 10;
agents = agent.empty(0,0);
for i = n_agents:-1:1
    agents(i).position = randi([0,max_xy],[2,1]);
end

%% Infection
infection_rate = 0.1; %starting infection rate
n_infected_agents = infection_rate * n_agents;
infections = 1;
while infections <= n_infected_agents
    index = randi([1,n_agents]);
    if agents(index).infected == 0 %not infected yet
        agents(index).infected = 1;
        infections = infections + 1;
    end
end



%% Moving agents
timestep = 0.1;
vel_scaling = 2;
steps = 100;
for j = 1:steps
    for i = 1:n_agents
        direction = randi(360);
        vel = rand() * vel_scaling;
        move = agents(i).position + timestep * vel * [cosd(direction);sind(direction)]; %new position after move
        %check whether new position is in square
        if (move(1) < 0 || move(1) > 10) || (move(2) < 0 || move(2) > 10)
            %outside square:
            move = agents(i).position; %don't perform move and generate new step in next timestep
        end
        agents(i).position = move;
    end
    
    hold on
    for i = 1:n_agents
        if agents(i).infected == 1
            plot(agents(i).position(1), agents(i).position(2),'ro')
        else
            plot(agents(i).position(1), agents(i).position(2),'ko')
        end
    end
    xlim([-0.3,10.3])
    ylim([-0.3,10.3])
    hold off
end
%% Plotting curves
% hold on
% for i = 1:n
%     plot(agents(i).position(1), agents(i).position(2),'o')
% end
% xlim([0.7,10.3])
% ylim([0.7,10.3])
% hold off