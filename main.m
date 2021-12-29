clear; clc; close all;
%% Parameters
n_agents = 100;
starting_infection_rate = 0.01;  
risk_of_infection = 0.1;
infection_radius = 0.7;
quarantine_prob = 0.5;
live_visualisation = 1;
max_xy = 10;

%% Initialising agents with random positions in max_xy square
agents = agent.empty(0,0);
for i = n_agents:-1:1
    agents(i).position = randi([0,max_xy],[2,1]);
    agents(i) = agents(i).savePos();
end

%% Infection
starting_n_infected_agents = starting_infection_rate * n_agents;
infections = 0;
while infections <= starting_n_infected_agents
    index = randi([1,n_agents]);
    if agents(index).infected == 0 %not infected yet
        agents(index).infected = 1;
        infections = infections + 1;
    end
end


%% Quarantine
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
        agents(i) = agents(i).move(vel_scaling, max_xy, timestep);
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
                            if (rand() < quarantine_prob)
                                agents(i).quarantine = 1;
                                agents(i).position = quarantine_pos;
                            end
                        end
                    end
                end
            end
        else %agent already infected
            if (rand() <= quarantine_prob && agents(i).quarantine ~=1)    %quarantine?
                agents(i).quarantine = 1;
                agents(i).position = quarantine_pos;
            end
        end
        agents(i) = agents(i).saveInfectionStatus();
        agents(i) = agents(i).saveQuarantineStatus();
    end
    
    %Save analytics
    infection_data = [infection_data; n_infected_agents n_agents-n_infected_agents];

    %Increase simulation step
    step = step + 1;
end

if live_visualisation ~= 1
    figure(1) 
    bar(infection_data,'stacked');
    legend('infected','healthy');
end

%% Visualisation of precomputed data
step = 1;
clear_intervall = 3;
iter_clear = 1;
pos1 = [0.05 0.2 0.4 0.6];
pos2 = [0.6 0.2 0.4 0.6];

if live_visualisation == 1
    figure1 = subplot('Position',pos1);
    figure2 = subplot('Position',pos2);
    figure1;
    xlim([-0.3, max_xy + 0.3]);
    ylim([-0.3, max_xy + 0.3]);

    %Pause
    pause(2) %to open up window

    while step <= steps
        
        %Plot of persons
        subplot('Position',pos1)
        hold on
        for i = 1:n_agents
            if agents(i).old_infection_status(step) == 1
                if agents(i).old_quarantine_status(step) == 1
                    plot(agents(i).old_positions(1,step), agents(i).old_positions(2,step), 'go') %infected person in qurantine --> green
                else
                    plot(agents(i).old_positions(1,step), agents(i).old_positions(2,step), 'ro') %infected person not in quarantine --> red
                end
            else
                plot(agents(i).old_positions(1,step), agents(i).old_positions(2,step), 'ko') %not infected person --> black
            end
        end
        hold off

        %Plot of analytics
        subplot('Position',pos2)
        bar(infection_data(1:step,:),'stacked');
        legend('infected','healthy');

        %Pause
        pause(0.01)

        %increasing step
        step = step + 1;
        iter_clear = iter_clear + 1;
        if iter_clear == clear_intervall
            subplot('Position', pos1)
            clf reset
            subplot('Position',pos1)
            xlim([-0.3, max_xy + 0.3]);
            ylim([-0.3, max_xy + 0.3]);
            iter_clear = 0;
        end
    end
end













