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

risk_of_infection = 0.2; %risk of infection if in contact with infected person
infection_radius = 1;
%% Simulation
timestep = 0.1;
vel_scaling = 2;
steps = 100;
step = 0;
while step <= steps
    %Moving
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

    %Infection?
    for i = 1:n_agents %Iterating over every agent
        if agents(i).infected == 0 %only if not infected yet
            for j = 1:n_agents %Iterating over every agent except the active one (j~=i)
                if j ~=i
                    if abs(agents(i).position - agents(j).position) < infection_radius %Risk of infection
                        if (rand() < risk_of_infection)
                            agents(i).infected = 1;
                        end
                    end
                end
            end
        end
    end
    
    %Plot
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

    step = step + 1;
    pause(0.1);
end

