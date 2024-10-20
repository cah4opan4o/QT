function [prob_stay, prob_first, shortest_path, mean_len, var_len] = MarkovCalculations(P, N, s, eps)
    E = zeros(1, N);  % Инициализируем вектор траектории
    E(1) = s;  % Начальное состояние

    [~, S] = size(P);  % Получаем количество состояний (узлов)

    % Преобразование вероятностей переходов (накопительные суммы)
    for i = 1:S
        for j = 2:S
            P(i, j) = P(i, j) + P(i, j - 1);
        end
    end

    % Инициализация переменных для расчетов
    prob_stay = zeros(S, N);  % Вероятность пребывания
    prob_first = zeros(S, N);  % Вероятность первого перехода
    shortest_path = Inf(S, S);  % Длина кратчайшего пути
    path_length = zeros(1, N);  % Длины путей

    % Основной цикл для вычисления траектории
    for i = 2:N
        r = rand(1);  % Генерация случайного числа от 0 до 1
        E(i) = S;  % Инициализация состояния
        found = false;

        for j = 1:S-1
            if r < P(E(i-1), j)
                E(i) = j;
                found = true;
                break;
            end
        end
        
        if ~found
            E(i) = S;  % Если не найдено, остаемся на последнем узле
        end
        
        % Рассчитываем вероятность пребывания в узле j после i коммутаций
        prob_stay(E(i), i) = prob_stay(E(i), i) + 1;

        % Если это первый раз, когда достигли узла, записываем как первый переход
        if prob_first(E(i), i) == 0
            prob_first(E(i), i) = 1;
        end

        % Обновляем длину кратчайшего пути, если обнаружен более короткий путь
        if shortest_path(E(i-1), E(i)) > i
            shortest_path(E(i-1), E(i)) = i;
        end

        % Обновляем общую длину пути
        path_length(i) = path_length(i-1) + 1;
    end

    % Рассчитываем математическое ожидание и дисперсию длины пути
    mean_len = mean(path_length);
    var_len = var(path_length);

    % Нормализуем вероятности пребывания
    prob_stay = prob_stay / N;

    % Выводим результаты
    fprintf('Средняя длина пути: %.2f\n', mean_len);
    fprintf('Дисперсия длины пути: %.2f\n', var_len);
end

P = [0.1, 0.3, 0.6;
     0.2, 0.4, 0.4;
     0.3, 0.3, 0.4];
N = 100;  % Длина траектории
s = 1;  % Начальное состояние
eps = 1e-6;  % Точность

[prob_stay, prob_first, shortest_path, mean_len, var_len] = MarkovCalculations(P, N, s, eps);

% Построение графиков
figure;
plot(1:N, prob_stay);
title('Вероятности пребывания пакета в узлах');
xlabel('Количество коммутаций');
ylabel('Вероятность пребывания');
legend('Узел 1', 'Узел 2', 'Узел 3');

figure;
plot(1:N, prob_first);
title('Вероятности первого перехода пакета');
xlabel('Количество коммутаций');
ylabel('Вероятность первого перехода');
legend('Узел 1', 'Узел 2', 'Узел 3');
