% Параметры системы
lyamda = 20;  % интенсивность поступления заявок
mu = 20;  % интенсивность обслуживания
n = 4;  % число каналов
m = 10;  % максимальная длина очереди

% Шаг 1: Расчет P0
rho = lyamda / mu;  % коэффициент загрузки одного канала
sum_part1 = sum((rho .^ (0:(n-1))) ./ factorial(0:(n-1)));
sum_part2 = (rho ^ n / factorial(n)) * sum((rho / n) .^ (1:m));
P0 = 1 / (sum_part1 + sum_part2);

% Шаг 2: Вероятности для остальных состояний
P = zeros(1, n + m);  % массив вероятностей
for k = 0:(n-1)
    P(k+1) = (rho ^ k / factorial(k)) * P0;
end
for k = 1:m
    P(n+k) = (rho ^ n / factorial(n)) * ((rho / n) ^ k) * P0;
end

% Шаг 3: Расчет показателей
P_otkaz = P(n+m);  % вероятность отказа (длина очереди полная)
L_busy = sum((0:(n-1)) .* P(1:n)) + sum(n * P((n+1):(n+m)));  % занятые каналы
L_queue = sum((1:m) .* P((n+1):(n+m)));  % средняя длина очереди
L_system = L_busy + L_queue;  % среднее число заявок в системе
W_queue = L_queue / lyamda;  % среднее время ожидания в очереди
W_system = L_system / lyamda;  % среднее время пребывания в системе

% Шаг 4: Вывод результатов в таблицу
results_table = table(["Вероятность отказа"; "Занятые каналы"; "Средняя длина очереди"; 
                       "Среднее число заявок в системе"; "Среднее время ожидания в очереди"; 
                       "Среднее время пребывания в системе"], ...
                       [P_otkaz; L_busy; L_queue; L_system; W_queue; W_system], ...
                       'VariableNames', {'Показатель', 'Значение'});

disp(results_table);

% Сохранение таблицы
writetable(results_table, 'smo_efficiency_metrics.csv');

