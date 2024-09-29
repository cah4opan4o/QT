N_array = [50, 200, 1000];
a = 0;
b = 10;


x_values = linspace(a, b, 100);  % Значения x для теоретической CDF
theoretical_cdf_values = (x_values.^2) / 9;  % Теоретические значения CDF
cdf_matrix = [x_values(:), theoretical_cdf_values(:)];  % Матрица для CDF


alpha_levels = [0.9, 0.95, 0.99];


for i = 1:length(N_array)
    n = N_array(i);
    fprintf('--- Размер выборки n = %d ---\n', n);


    U = rand(n, 1);
    X = sqrt(9 * U);


    for j = 1:length(alpha_levels)
        alpha = alpha_levels(j);
        [h, p] = kstest(X, 'CDF', cdf_matrix, 'Alpha', alpha);
        fprintf('Уровень значимости %.2f: h = %d, p = %f\n', alpha, h, p);
    end


    figure;
    hold on;
    cdfplot(X);
    fplot(@(x) (1) / (x * log(10)), [a b], 'r');
    legend('Эмпирическая CDF', 'Теоретическая CDF');
    xlabel('x');
    ylabel('F(x)');
    title(sprintf('Сравнение эмпирической и теоретической CDF (n = %d)', n));
    hold off;
end
