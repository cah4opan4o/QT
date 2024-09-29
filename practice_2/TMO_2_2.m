% Параметры
N = 400;     % Длина процесса
K = 800;     % Количество реализаций
mu = 0;      % Среднее белого шума
sigma = 1;   % СКО белого шума

% Генерация белого шума
omega = mu + sigma * randn(N, K);

% Инициализация процесса случайного блуждания
X = zeros(N, K);
X(1, :) = omega(1, :);  % Начальное значение

% Заполнение процесса случайного блуждания по уравнению (2.2)
for n = 2:N
    X(n, :) = X(n-1, :) + omega(n, :);
end

% Построение всех реализаций на одном полотне
figure;
plot(1:N, X);
xlabel('n');
ylabel('\xi[n]');
title('Все реализации случайного блуждания');
grid on;

% Скаттерограммы для пар (ni, nj)
ni_nj_pairs_1 = [10, 9; 50, 49; 100, 99; 200, 199];
ni_nj_pairs_2 = [50, 40; 100, 90; 200, 190];

figure;
subplot(1, 2, 1); % Первый набор пар (соседние значения)
hold on;
for pair = 1:size(ni_nj_pairs_1, 1)
    scatter(X(ni_nj_pairs_1(pair, 1), :), X(ni_nj_pairs_1(pair, 2), :));
end
hold off;
xlabel('\xi[n_i]');
ylabel('\xi[n_j]');
title('Скаттерограммы для соседних n_i и n_j');
legend('n=10,9', 'n=50,49', 'n=100,99', 'n=200,199');
grid on;

subplot(1, 2, 2); % Второй набор пар
hold on;
for pair = 1:size(ni_nj_pairs_2, 1)
    scatter(X(ni_nj_pairs_2(pair, 1), :), X(ni_nj_pairs_2(pair, 2), :));
end
hold off;
xlabel('\xi[n_i]');
ylabel('\xi[n_j]');
title('Скаттерограммы для пар (n_i, n_j)');
legend('n=50,40', 'n=100,90', 'n=200,190');
grid on;

% Рассчет выборочной автокорреляции r(n, n-1)
auto_corr_sample = zeros(N-1, 1);
for n = 2:N
    auto_corr_sample(n-1) = mean(X(n, :) .* X(n-1, :));
end

% Теоретическая автокорреляция r(n, n-1) для случайного блуждания
auto_corr_theory = (sigma^2) * (1:N-1)';

% Построение выборочной и теоретической автокорреляций
figure;
plot(1:N-1, auto_corr_sample, 'b', 'LineWidth', 2);
hold on;
plot(1:N-1, auto_corr_theory, 'r--', 'LineWidth', 2);
xlabel('n');
ylabel('r(n, n-1)');
title('Выборочная и теоретическая автокорреляции r(n, n-1)');
legend('Выборочная автокорреляция', 'Теоретическая автокорреляция');
grid on;
hold off;
