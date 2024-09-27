%Вариант 4
% N=400 K=800 m=8 o=2
N = 400; % строк
K = 800; % столбцов
Mu = 8;
sigma = 2;

X = Mu + sigma * randn(K,N);
mean_X = mean(X, 1);  % Среднее по строкам (по каждой реализации)
% Усреднение по каждой реализации
mean_realizations = mean(X, 2);  % Среднее по колонкам (усреднение по каждой реализации)

% Построение графиков
figure;
hold on;
plot(mean_X, 'LineWidth', 2, 'DisplayName', 'Среднее по ансамблю');
plot(mean_realizations, 'o-', 'DisplayName', 'Среднее по каждой реализации');
xlabel('n');
ylabel('Среднее значение');
title('Среднее по ансамблю и усреднение по каждой реализации');
legend show;
grid on;
hold off;

n = 100; % Количество точек
xi1 = randn(n, 1); % Первый набор данных
xj1 = 2 * xi1  + randn(n, 1) * 0.5; % Коррелированный набор данных
xi2 = randn(n, 1); % Второй набор данных
xj2 = 0.5 * xi2 + randn(n, 1) * 0.5; % Слабо коррелированный набор данных
xi3 = randn(n, 1); % Третий набор данных
xj3 = randn(n, 1); % Независимый набор данных

% Рассчет корреляции
r1 = corr(xi1, xj1);
r2 = corr(xi2, xj2);
r3 = corr(xi3, xj3);

% Построение графиков
figure;

subplot(3, 1, 1);
scatter(xi1, xj1);
title(['График 1: r = ' num2str(r1)]);
xlabel('\xi_i');
ylabel('\xi_j');
grid on;

subplot(3, 1, 2);
scatter(xi2, xj2);
title(['График 2: r = ' num2str(r2)]);
xlabel('\xi_i');
ylabel('\xi_j');
grid on;

subplot(3, 1, 3);
scatter(xi3, xj3);
title(['График 3: r = ' num2str(r3)]);
xlabel('\xi_i');
ylabel('\xi_j');
grid on;

% Отображение полученных корреляций в отчете
disp(['Корреляция между xi1 и xj1: ' num2str(r1)]);
disp(['Корреляция между xi2 и xj2: ' num2str(r2)]);
disp(['Корреляция между xi3 и xj3: ' num2str(r3)]);