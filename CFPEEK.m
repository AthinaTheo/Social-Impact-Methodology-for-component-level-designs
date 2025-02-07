clear
clc

% Social Life Cycle Analysis - Threshold methodology (50%)  
% Social Hotspot Count - CF/PEEK

%% Structural Aircraft Component


% Life phases
mat1=["JPN" "CHN" "KOR" "GBR" "GER"];
mat2=["AUS" "JPN" "KSA" "BUL" "SIN"];
man1=["FRA" "USA" "CHN" "GER" "ISR"];
eol=["FRA" "GBR" "BEL"];

% DOE 
doe_sLCA = fullfact ([5 5 5 3]);     % the size is different depending on how many the countries are in each life stage
sLCA_list=strings(length(doe_sLCA),4); % the second number changes depending on the life stages



for i=1: length(doe_sLCA)

    sLCA_list(i,:) = [mat1(doe_sLCA(i,1)) , ...
                        mat2(doe_sLCA(i,2)), ...
                        man1(doe_sLCA(i,3)), ...
                        eol(doe_sLCA(i,4)) ];

end

% Define the mapping of country codes to numerical arrays (for social hotspot count per stakeholder)
country_map = containers.Map({'CHN', 'GUI','RUS','GUY','CAN','MAD','RSA','MOZ', 'BRA','GBR','USA','GER','JPN', ...
                                'KOR','AUS','CHI','PER','MON','CON','IND','TUR','KAZ','MAR','ESP','NED','KSA' ...
                                'BUL','SIN','PHI','POL','ICE','SUI','INA','ISR','FIN','FRA','THA', 'UAE', 'NOR', 'BEL'}, ...
                             {[2 3 7 1 1], [3 3 8 2 2],[2 4 6 3 2],[1 3 4 1 1],[0 2 3 1 0],[3 3 7 2 2],[3 2 6 1 0],[3 3 7 3 2],[3 3 4 2 2], ...
                             [0 1 3 1 0],[1 0 3 1 0],[0 1 3 0 0],[1 2 3 0 0],[1 1 3 0 0],[0 1 3 0 0],[3 2 4 1 1],[3 3 4 2 1],[2 3 5 3 1], ...
                             [5 4 7 3 2],[6 2 6 4 2],[4 4 6 2 1],[3 4 6 2 1],[4 2 8 1 1],[1 2 3 1 0],[0 1 3 1 0],[3 2 6 1 2],[2 3 4 2 0], ...
                             [1 2 4 0 0],[5 3 7 2 2],[1 1 3 1 0],[0 1 3 1 0],[0 1 3 0 0],[4 3 5 2 1],[1 1 4 1 0],[0 1 3 0 0],[0 1 3 1 0],[4 2 6 2 1],[3 1 5 2 1], [0 1 3 1 0], [0 1 3 0 0]});

% Initialize an empty matrix to hold the numerical arrays
num_matrix = [];

%%
% Loop through each row and column of the character matrix
for i = 1:size(sLCA_list, 1)
    row = [];
    for j = 1:size(sLCA_list, 2)
        % Append the numerical array for the current country code
        row = [row; country_map(sLCA_list(i, j))];
    end
    % Append the current row to the num_matrix
    num_matrix = [num_matrix; row];
end

% Define the weights for the weighted sum (equal weights)
weights = [0.2, 0.2, 0.2, 0.2, 0.2];  % 1. workers, 2. consumers, 3. local community, 4. society, 5. other value chain factors

% Initialize a result matrix to hold the weighted sums
result_matrix = [];

% Perform the weighted sum for every n rows (n depending on the life stages)
for i = 1:4:size(num_matrix, 1)
    if i+2 <= size(num_matrix, 1)
        % Extract the chunk of n rows
        chunk = num_matrix(i:i+3, :);
        % Calculate the weighted sum for each column
        weighted_sum = sum(chunk .* weights);
        % Append the weighted sum to the result matrix
        result_matrix = [result_matrix; weighted_sum];
    end
end

for i=1:length(result_matrix)
    scores=sum(result_matrix,2);
end

% Find the minimum and the maximum value in the specified column and its row index

[best_scenario, rowIndex] = min(scores(:));
[worst_scenario,row2Index] = max(scores(:));

fprintf('The best-case scenario is: \n Raw Material 1 (Carbon Fiber): %s \n Raw Material 2 (PEEK): %s \n Component Manufacturing: %s \n End of Life: %s\n\n', sLCA_list(rowIndex,1:4));

fprintf('The worst-case scenario is: \n Raw Material 1 (Carbon Fiber): %s \n Raw Material 2 (PEEK): %s \n Component Manufacturing: %s \n End of Life: %s\n\n', sLCA_list(row2Index,1:4));

