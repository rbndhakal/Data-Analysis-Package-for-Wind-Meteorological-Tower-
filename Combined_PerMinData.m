input_path = '/Users/rbndhakal/Documents/Wind Data/PerMinData'; % location of .csv files
output_file = 'PerMinData_May.csv'; % name of file containing combined data
% read each .csv file into a table stored in a cell array of tables 
% called 'all_data':
file_info = dir(fullfile(input_path,'*.csv'));
full_file_names = fullfile(input_path,{file_info.name});
n_files = numel(file_info);
all_data = cell(1,n_files);
for ii = 1:n_files
    all_data{ii} = readtable(full_file_names{ii});
end

% concatenate all the tables into one big table, and write it to
% output_file:
writetable(cat(1,all_data{:}),output_file);

