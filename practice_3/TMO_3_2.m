function states = simulate_markov_chain(P_cum,iterations)
    states = zeros(1, iterations);
    states(1)=1;
    for t=1:iterations
        r = rand();
        z_t = states(t);
        next_state = find(r <= P_cum(z_t,:),1);
        states(t+1) = next_state;
    end
end

function P_obs = calculate_transition_matrix(states, num_states)
    P_obs = zeros(num_states, num_states);
    for t = 1:(length(states) - 1)
        z_t = states(t);
        z_t1 = states(t+1);
        P_obs(z_t,z_t1) = P_obs(z_t,z_t1) + 1;
    end
end

function P_norm = normalize_matrix(P)
    P_norm = P ./ sum(P, 2);  % Нормировка по строкам
end

lyamda = 20; % интенсивность поступления заявок
mu = 20; % интенсивность потока обслуживания
n = 4; % число каналов
m = 10; % длина очереди

P = [0 3 3 3;
     3 0 2 1;
     3 2 0 1;
     3 2 1 0]; % матрица переходов

stateNames = ["Healthy" "Unwell" "Sick" "Very sick"];
MC = dtmc(P,'StateNames',stateNames);

disp('Матрциа переходов:');
disp(MC.P);

rowSums = sum(MC.P, 2); % параметр 1 - по столбцам, 2 - по строкам
disp('Сумма по строкам:');
disp(rowSums);

P = P ./ sum(P, 2);

save('transition_matrix.mat','P');

figure;
graphplot(MC,'ColorEdges', true);
title('Визуализация цепей Маркова');
colormap(jet);
colorbar;

P_cum = cumsum(P,2);
disp('кумулятивная матрица:')
disp(P_cum);

N_array = [200,1000,10000];
for i=1:length(N_array)
    N = N_array(i);
    states = zeros(1,N);
    states(1) = 1;
    for t=1:(N-1)
        r = rand();
        z_t = states(t);
        next_state = find(r <= P_cum(z_t,:),1);
        states(t+1) = next_state;
    end
    figure;
    plot(1:N, states, '-o');
    xlabel('Номер итерации');
    ylabel('Состояние');
    title(['Моделирование цепи Маркова: ',N]);
    grid on;
end

num_states = size(P,1);

for num_iteratioins = N_array
    states = simulate_markov_chain(P_cum, num_iteratioins);
    P_obs = calculate_transition_matrix(states, num_states);
    P_obs_norm = normalize_matrix(P_obs);

    MC_obs = dtmc(P_obs_norm, 'StateNames', stateNames);
    
    % Построение графа
    figure;
    graphplot(MC_obs, 'ColorEdges', true);
    colormap(jet);
    colorbar;
end