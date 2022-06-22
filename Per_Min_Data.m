%Author: Rabin Dhakal, MSc, May 2022. 
% Contact: Email:Rabin.Dhakal@ttu.edu/rbndhakal@gmail.com

%This is a Matlab script which is a part of analysing wind
%speed data from meterological station which consists of 200m tower
%containing 10 different sensors at different heights.

%INSTRUCTIONS: To use this code following two things should be done: 
% 1.  The code file "Per_Min_Data.m" should be copied to the
%folder consisting of the files which is to be analyzed to get per minute
%data
% 2. A folder with name Together "PerMinData" Should be made in the same
%directory where there are those files to be analyzed


tic; %calculating time to run the code 
%user selects input file
[filename,path] = uigetfile('*.csv', 'Select File');

%reading only selected columns

opts = detectImportOptions(filename);
data = readtable(filename, opts);
W = width(data);
H = height(data);
%creating empty column if the data doesnot contain 120 columns 
if W <= 120
    missing_data_array = NaN(H,120-W);
    missing_data_table = array2table(missing_data_array);
    complete_data= [data missing_data_table];
else
    complete_data = data; 
end

%Selecting only desired column form input file
selected_data= complete_data(:,[5,6,7,12,13,14,19,20,21,26,27,28,33,34,35,40,41,42,47,48,49,54,55,56,61,62,63,68,69,70,74,75,79,80,84,85,89,90,94,95,99,100,104,105,109,110,114,115,116,117,118,119,120]);

%Changing the header of each selected column
header = {'TT-1', 'TRH-1', 'TBP-1','TT-2', 'TRH-2', 'TBP-2', 'TT-4', 'TRH-4', 'TBP-4', 'TT-10', 'TRH-10', 'TBP-10', 'TT-17', 'TRH-17', 'TBP-17', 'TT-47', 'TRH-47', 'TBP-47', 'TT-75', 'TRH-75', 'TBP-75', 'TT-116', 'TRH-116', 'TBP-116', 'TT-158', 'TRH-158', 'TBP-158', 'TT-200', 'TRH-200', 'TBP-200', 'TS-WS-1', 'TS-WD-1', 'TS-WS-2', 'TS-WD-2', 'TS-WS-4', 'TS-WD-4', 'TS-WS-10', 'TS-WD-10', 'TS-WS-17', 'TS-WD-17', 'TS-WS-47', 'TS-WD-47', 'TS-WS-75', 'TS-WD-75', 'TS-WS-116', 'TS-WD-116', 'TS-WS-158', 'TS-WD-158', 'TSN-TRANS-200', 'TSNW-TRANS-200', 'TSV-TRANS-200', 'TS-WS-200', 'TS-WD-200'};
selected_data.Properties.VariableNames = header;

%Getting information of date and time from the file to generate date and
%time column
Year = filename(21:24); Month = filename(25:26); Day = filename(27:28); Hour = filename(31:32); Min = filename(33:34);
Datetime = strcat(Year,'-',Month,'-',Day);
Hours = strcat(Hour,':',Min, ':00');
Time = strcat(Datetime, " ", Hours);
Time_final = datetime(Time,'InputFormat','yyyy-MM-dd HH:mm:ss', 'Format', 'dd MMM yyyy HH:mm:ss')
DateTimeColumn = (Time_final + minutes(0:29))';

%Working over all the date i.e each column and each rows using nested loop
for Var = 1:53
    for i = 1:30
        sum_data = 0; 
        count = 0;
        for j = (3000*(i-1)+1):(3000*i)
            if strcmp(selected_data{j,Var}, {''}) == 1
                break;
            elseif j < height(selected_data)
                if isnan(selected_data{j,Var})
                    count = count; 
                else
                    sum_data = sum_data + selected_data{j,Var};
                    count = count + 1;
                end
            else j == height(selected_data)
                if isnan(selected_data{j,Var})
                    break; 
                else
                    sum_data = sum_data + selected_data{j,Var}; 
                    break;
                end
            end 
        end
            if Var == 1 
                avg_data = sum_data/count;
                min_data{i,Var} = avg_data;
                min_data{i,Var+1} = count;
               
            else
                avg_data = sum_data/count;
                min_data{i,(2*Var)-1} = avg_data;
                min_data{i,2*Var} = count;
            end   
    
    end
end

Table_datetime = array2table(DateTimeColumn);
Table_min_data = cell2table(min_data);
Final_Table = [Table_datetime, Table_min_data];

%Defining header for count as well
final_header = {'DateTime', 'TT-1', 'Count-TT-1', 'TRH-1', 'Count-TRH-1', 'TBP-1', 'Count-TBP-1', 'TT-2', 'Count-TT-2', 'TRH-2', 'Count-TRH-2', 'TBP-2', 'Count-TBP-2', 'TT-4','Count-TT-4',  'TRH-4','Count-TRH-4',  'TBP-4','Count-TBP-4',  'TT-10','Count-TT-10',  'TRH-10', 'Count-TRH-10', 'TBP-10','Count-TBP-10',  'TT-17','Count-TT-17',  'TRH-17','Count-TRH-17',  'TBP-17', 'Count-TBP-17', 'TT-47','Count-TT-47',  'TRH-47','Count-TRH-47', 'TBP-47','Count-TBP-47',  'TT-75','Count-TT-75',  'TRH-75', 'Count-TRH-75', 'TBP-75', 'Count-RBP-75', 'TT-116', 'Count-TT-116',  'TRH-116', 'Count-TRH-116',  'TBP-116', 'Count-TBP-116',  'TT-158', 'Count-TT-158',  'TRH-158','Count-TRH-158',  'TBP-158', 'Count-TBP-158', 'TT-200', 'Count-TT-200', 'TRH-200', 'Count-TRH-200', 'TBP-200','Count-TBP-200',  'TS-WS-1','Count-TS-WS-1',  'TS-WD-1', 'Count-TS-WD-1', 'TS-WS-2','Count-TS-WS-2',  'TS-WD-2', 'Count-TS-WD-2', 'TS-WS-4', 'Count-TS-WS-4', 'TS-WD-4', 'Count-TS-WD-4', 'TS-WS-10', 'Count-TS-WS-10', 'TS-WD-10','Count-TS-WD-10',  'TS-WS-17', 'Count-TS-WS-17', 'TS-WD-17', 'Count-TS-WD-17', 'TS-WS-47', 'Count-TS-WS-47',  'TS-WD-47', 'Count-TS-WD-47',  'TS-WS-75', 'Count-TS-WS-75', 'TS-WD-75', 'Count-TS-WD-75', 'TS-WS-116', 'Count-TS-WS-116', 'TS-WD-116', 'Count-TS-WD-116', 'TS-WS-158','Count-TS-WS-158', 'TS-WD-158','Count-TS-WD-158', 'TSN-TRANS-200', 'Count-TSN-TRANS-200', 'TSNW-TRANS-200', 'Count-TSNW-TRANS-200', 'TSV-TRANS-200', 'Count-TSV-TRANS-200', 'TS-WS-200', 'Count-TS-WS-200', 'TS-WD-200', 'Count-TS-WD-200'};
Final_Table.Properties.VariableNames = final_header;

%creating output file name and directory
filenameBreakdownArr = split(filename, '.');
outfname = sprintf('%s_CountAvgPerMin.%s', filenameBreakdownArr{1}, filenameBreakdownArr{2});
current_folder = pwd;
destination_directory = '\PerMinData';
output_directory = strcat(current_folder,destination_directory);
Table_path_format = [output_directory filesep, outfname];

%Writing to the specific folder inside the folder of input file
writetable(Final_Table, Table_path_format);

toc;  %end calculating run time 
