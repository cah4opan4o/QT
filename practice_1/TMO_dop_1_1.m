p = [0.05,0.1,0.2,0.3,0.2,0.1,0.05];
k = [4,5,6,7,8,9,10];


N = 1000;


sample = randsample(k, N, true, p);


asymmetry = skewness(sample);


excess = kurtosis(sample);


fprintf('Коэффициент асимметрии: %.4f\n', asymmetry);
fprintf('Коэффициент эксцесса: %.4f\n', excess);