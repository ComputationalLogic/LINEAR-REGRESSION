clear all; clc; close all;

fprintf('========================================\n');
fprintf('Hypothetical monthly data on Syrian casualties (2021-2022)\n');
fprintf('========================================\n\n');

fprintf('WARNING: Enter victim data for 2021 and 2022\n');
fprintf('============================================\n\n');

victims_2021 = [45, 52, 48, 61, 55, 49, 63, 58, 52, 46, 59, 67]; 
victims_2022 = [48, 55, 51, 64, 58, 52, 66, 61, 55, 49, 62, 70]; 

fprintf('Using sample data. Modify the variables victims_2021 and victims_2022\n');
fprintf('with your actual data before running the final analysis.\n\n');

months = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

x_values = 1:24;
y_values = [victims_2021, victims_2022];
num_observations = length(x_values);

fprintf('INPUT DATA:\n');
fprintf('Total number of observations: %d\n\n', num_observations);

fprintf('DATA TABLE:\n');
fprintf('%-4s %-12s %-4s %-4s %-8s\n', 'No.', 'Month', 'Year', 'X', 'Y');
fprintf('%-4s %-12s %-4s %-4s %-8s\n', '---', '--------', '----', '---', '--------');
for i = 1:num_observations
    year = '2021';
    month_idx = i;
    if i > 12
        year = '2022';
        month_idx = i - 12;
    end
    fprintf('%-4d %-12s %-4s %-4d %-8d\n', i, months{month_idx}, year, x_values(i), y_values(i));
end
fprintf('\n');

fprintf('STEP 1: FORMULATING THE SYSTEM OF NORMAL EQUATIONS\n');
fprintf('==================================================\n');
fprintf('For linear regression Y = α + βX, the normal equations are:\n\n');
fprintf('Σy = n·α + β·Σx     ... (Equation 1)\n');
fprintf('Σxy = α·Σx + β·Σx²  ... (Equation 2)\n\n');

fprintf('STEP 2: CALCULATING SUMMATIONS\n');
fprintf('==============================\n');

sum_x = sum(x_values);
sum_y = sum(y_values);
sum_x2 = x_values * x_values';
sum_xy = x_values * y_values';

fprintf('n = %d\n', num_observations);
fprintf('Σx = %.0f\n', sum_x);
fprintf('Σy = %.0f\n', sum_y);
fprintf('Σx² = %.0f\n', sum_x2);
fprintf('Σxy = %.0f\n\n', sum_xy);

fprintf('STEP 3: FORMING THE MATRIX SYSTEM\n');
fprintf('=================================\n');

A = [num_observations, sum_x; sum_x, sum_x2];
B = [sum_y; sum_xy];

fprintf('Matrix A (coefficients):\n');
disp(A);
fprintf('Vector B (independent terms):\n');
disp(B);

fprintf('STEP 4: CHECKING INVERTIBILITY\n');
fprintf('==============================\n');

if rank(A) == 2
    fprintf('Matrix A is invertible. The system can be solved.\n\n');
else
    fprintf('ERROR: Matrix A is not invertible. Cannot proceed.\n');
    return;
end

fprintf('STEP 5: SOLVING THE SYSTEM\n');
fprintf('==========================\n');
fprintf('Solution: X = A \\ B\n\n');

X = A \ B;
alpha = X(1);
beta = X(2);

fprintf('X = ┌ %10.6f ┐\n', alpha);
fprintf('    └ %10.6f ┘\n\n', beta);

fprintf('Therefore:\n');
fprintf('α = %10.6f\n', alpha);
fprintf('β = %10.6f\n\n', beta);

fprintf('STEP 6: VERIFYING THE SOLUTION\n');
fprintf('==============================\n');

verification = A * X;
fprintf('A·X =\n');
disp(verification);
fprintf('Comparing with B =\n');
disp(B);
fprintf('Absolute error:\n');
disp(abs(verification - B));

fprintf('STEP 7: REGRESSION LINE EQUATION\n');
fprintf('================================\n');
fprintf('Y = α + βX\n');
fprintf('Y = %.6f + %.6f·X\n\n', alpha, beta);

if beta > 0
    trend = 'increasing';
else
    trend = 'decreasing';
end

fprintf('Interpretation:\n');
fprintf('- The slope β = %.6f indicates an %s trend\n', beta, trend);
fprintf('- For each month that passes, the number of victims changes by %.4f units\n', beta);
