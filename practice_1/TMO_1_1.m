% Плотность распределения: 1/(x*ln10)
% Интервал распределения: [0.1;10]
% Обратная функция: x = 10^(u*(log10(10)-log10(0.1)) + log10(0.1))
N_array = [50, 200, 1000];
means = zeros(1, 3);
disp = zeros(1, 3);
sko = zeros(1, 3);
for i = 1:length(N_array)
    N = N_array(i);
    u = rand(N, 1);  % Генерация u на интервале [0, 1]
    x = 10.^(u * (log10(10) - log10(0.1)) + log10(0.1));  % Пересчет x на интервале [0.1, 10]
    
    means(i) = mean(x);
    disp(i) = var(x);
    sko(i) = std(x);
    
    % Количество интервалов для гистограммы
    k = ceil(1 + 3.2 * log(N));
    
    % Построение гистограммы
    figure;
    histogram(x, k, 'Normalization', 'pdf');
    hold on;
    
    % Теоретическая плотность вероятности 1/(x*ln(10))
    fplot(@(x) 1 ./ (x * log(10)), [0.1, 10], 'r', 'LineWidth', 2);
    
    xlabel('x');
    ylabel('Плотность вероятности');
    title(['Гистограмма выборки N = ', num2str(N)]);
    legend('Гистограмма выборки', 'Теоретическая плотность');
    hold off;
end

alpha_values = [0.1, 0.05, 0.01];
interval_means = zeros(3, 3, 2);
interval_disp = zeros(3, 3, 2);
for i = 1:length(N_array)
    N = N_array(i);
    means_x = means(i);
    disp_x = disp(i);
    sko_x = sko(i);
    
    for j = 1:length(alpha_values)
        alpha = alpha_values(j);
        t_val = tinv(1 - alpha / 2, N - 1);
        margin_mean = t_val * sko_x / sqrt(N);
        
        interval_means(i, j, :) = [means_x - margin_mean, means_x + margin_mean];
        
        chi2_low = chi2inv(alpha / 2, N - 1);
        chi2_high = chi2inv(1 - alpha / 2, N - 1);
        
        interval_disp(i, j, :) = [(N - 1) * disp_x / chi2_high, (N - 1) * disp_x / chi2_low];
    end    
end

% Таблицы с точечными оценками
point_estimates_data = table(N_array', means', disp', sko', ...
                     'VariableNames', {'N', 'Mean', 'Variance', 'SKO'});
figure('Name', 'Точечные оценки', 'NumberTitle', 'off');
uitable('Data', point_estimates_data{:,:}, 'ColumnName', point_estimates_data.Properties.VariableNames, ...
    'RowName', [], 'Position', [20 20 400 150]);

% Интервальные оценки
for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    
    % Интервалы для среднего
    mean_intervals_data = table(N_array', squeeze(interval_means(:, i, 1)), squeeze(interval_means(:, i, 2)), ...
                             'VariableNames', {'N', 'Нижняя граница', 'Верхняя граница'});
    figure('Name', ['Интервальные оценки среднего для alpha = ', num2str(alpha)], 'NumberTitle', 'off');
    uitable('Data', mean_intervals_data{:,:}, 'ColumnName', mean_intervals_data.Properties.VariableNames, ...
        'RowName', [], 'Position', [20 20 650 150]);
    
    % Интервалы для дисперсии
    var_intervals_data = table(N_array', squeeze(interval_disp(:, i, 1)), squeeze(interval_disp(:, i, 2)), ...
                            'VariableNames', {'N', 'Нижняя граница', 'Верхняя граница'});
    figure('Name', ['Интервальные оценки дисперсии для alpha = ', num2str(alpha)], 'NumberTitle', 'off');
    uitable('Data', var_intervals_data{:,:}, 'ColumnName', var_intervals_data.Properties.VariableNames, ...
        'RowName', [], 'Position', [20 20 650 150]);
end

% Плотность и функция распределения
x_values = linspace(0.1, 3, 100);
pdf_values = x_values / 4.5;
cdf_values = (x_values .^ 2) / 9;
figure;
yyaxis left;
plot(x_values, pdf_values, 'r', 'LineWidth', 2);
ylabel('Плотность вероятности');
yyaxis right;
plot(x_values, cdf_values, 'b', 'LineWidth', 2);
ylabel('Функция распределения');
xlabel('x');
title('Теоретическая плотность и функция распределения вероятности');
legend('Плотность вероятности', 'Функция распределения');
grid on;
