clear; clc; close all;

%% Initialising agents with random positions in max_xy square
n_agents = 40;
max_xy = 10;
agents = agent.empty(0,0);
for i = n_agents:-1:1
    agents(i).position = randi([0,max_xy],[2,1]);
end

%% Infection
starting_infection_rate = 0.1; %starting infection rate
starting_n_infected_agents = starting_infection_rate * n_agents;
infections = 1;
while infections <= starting_n_infected_agents
    index = randi([1,n_agents]);
    if agents(index).infected == 0 %not infected yet
        agents(index).infected = 1;
        infections = infections + 1;
    end
end

risk_of_infection = 0.2; %risk of infection if in contact with infected person
infection_radius = 1;

%% Quarantine
quarantine_prob = 0.8; %probability that infections get's detected and agent is put in quarantine
quarantine_pos = [100;100]; %position for quarantine area

%% Simulation
timestep = 0.1;
vel_scaling = 3;
steps = 100;
step = 0;
n_infected_agents = starting_n_infected_agents;
infection_data = [];
while step <= steps
    %Moving
    for i = 1:n_agents
        if agents(i).quarantine == 0 %only move agents which are not in quarantine
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
    end

    %Infection?
    for i = 1:n_agents %Iterating over every agent
        if agents(i).infected == 0 %only if not infected yet
            for j = 1:n_agents  %Iterating over every agent 
                if j ~=i  && agents(j).quarantine == 0  %except the "active one" (j~=i) & the ones in qurantine
                    if abs(agents(i).position - agents(j).position) < infection_radius %in critical radius?
                        if (rand() < risk_of_infection)     %infection?
                            agents(i).infected = 1;
                            n_infected_agents = n_infected_agents + 1;
                            if (rand() < quarantine_prob)    %quarantine?
                                agents(i).quarantine = 1;
                                agents(i).position = quarantine_pos;
                            end
                        end
                    end
                end
            end
        end
    end
    
%     %Plot of agents
%     figure(1)
%     hold on
%     for i = 1:n_agents
%         if agents(i).infected == 1
%             plot(agents(i).position(1), agents(i).position(2),'ro')
%         else
%             plot(agents(i).position(1), agents(i).position(2),'ko')
%         end
%     end
%     xlim([-0.3,max_xy + 0.3])
%     ylim([-0.3,max_xy + 0.3])
%     hold off

    %Plot for analytics
    figure(2)
    infection_data = [infection_data; n_infected_agents n_agents-n_infected_agents];
    bar(infection_data,'stacked');
    legend('infected','healthy')
    

    %Increase simulation step
    step = step + 1;
    %Pause
    pause(0.1);
end

