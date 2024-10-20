L = 15;  % Количество узлов

% Создание пустого графа и добавление узлов
G = digraph();
G = addnode(G, L);  % Добавляем L узлов

% Создание случайного направленного графа с минимум 3 исходящими путями
for i = 1:L
    while outdegree(G, i) < 3
        target = randi([1, L], 1);  % Случайное назначение цели
        if target ~= i
            G = addedge(G, i, target);
        end
    end
end

% Обеспечиваем, чтобы каждый узел имел минимум 1 входящий путь
for i = 1:L
    if indegree(G, i) == 0
        source = randi([1, L], 1);
        while source == i || outdegree(G, source) == 0
            source = randi([1, L], 1);
        end
        G = addedge(G, source, i);
    end
end

% Построение графа
plot(G);

% Задание матрицы переходов LxL
L = 15;
T = zeros(L);  % Обнуляем матрицу

% Установка примеров переходов (например, T1,4 = 0.2)
T(1, 4) = 0.2;
T(2, 5) = 0.3;
T(3, 6) = 0.4;
% и так далее, заполняем по аналогии с графом

% Обеспечиваем стохастичность
for i = 1:L
    row_sum = sum(T(i, :));
    if row_sum > 0
        T(i, :) = T(i, :) / row_sum;  % Нормируем строки, чтобы они суммировались к 1
    end
end

function is_stochastic = stochastic(matrix)
    [rows, cols] = size(matrix);
    if rows ~= cols
        error('Матрица должна быть квадратной.');
    end
    
    for i = 1:rows
        if abs(sum(matrix(i, :)) - 1) > 1e-6
            is_stochastic = false;
            return;
        end
    end
    is_stochastic = true;
end

function is_ergodic = ergodic(matrix, epsilon)
    L = size(matrix, 1);  % Размерность матрицы
    reachability = (matrix > epsilon);  % Порог для вероятностей
    
    for k = 2:L
        reachability = reachability + (matrix^k > epsilon);
    end
    
    is_ergodic = all(reachability(:) > 0);  % Если все состояния достижимы
end

is_stochastic = stochastic(T);
if is_stochastic
    disp('Матрица является стохастической.');
else
    disp('Матрица не является стохастической.');
end

epsilon = 1e-6;  % Маленькое значение для проверки вероятностей
is_ergodic = ergodic(T, epsilon);
if is_ergodic
    disp('Цепь Маркова эргодическая.');
else
    disp('Цепь Маркова не является эргодической.');
end
