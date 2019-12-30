%% clear the prompt
clear
clc

%% load the data
% Download the stock price information from this website
% https://www.asxhistoricaldata.com/
% locate the folder that stores the data
folder = fullfile('c:\','Users','user-name','Desktop','2018july-dec','2018july-dec', '*.txt');
filemat = dir(folder);
filecount = numel(filemat);

% load the files to data matrix
for i = 1:filecount
    data{i} = readtable(filemat(i).name);
end

%% only keey the company data that available in 129 companies
% 1. create the list
% ceate the company name list which all the names are available in data set
namelist = data{1,1}.(1);

% data deleted
global deletenum;
deletenum = 0;
% ifile is index of the 129 files
for ifiles = 2:filecount
    % the first test company names in 2 / 129 files
    nametest = data{ifiles}.(1);
    % inames is the index of the namelist
    for inames = 1:numel(namelist)
        % compare with the available value
        if ~isnumeric(namelist{inames})
            % itest is the test company name in the rest of the 128 files
            for itest = 1:numel(nametest)
               if strcmp(namelist{inames},nametest{itest})
                   break
               end
               % last on can not find mark as delete
               if itest == numel(nametest)
                   namelist{inames} = -1;
                   deletenum = deletenum + 1;
               end
            end
        end
    end
    % display process
    clc
    fprintf("%d / %d\r\n", ifiles, filecount)
    % print file deleted
    fprintf("%d data delete\r\n", deletenum)
end

for i = 1:numel(namelist)
    for j = 1:numel(namelist)
        if isnumeric(namelist{j})
            namelist(j) = [];
            break
        end
    end
end
 
%% only keey the company data that available in 129 companies
% 2. delete the stock data that is not common

% the length of the listname data 
listlength = numel(namelist);
% ifile is index of the 129 files
for ifiles = 1:filecount
    for ilist = 1:listlength
        while ~strcmp(data{ifiles}(ilist,1).(1),namelist(ilist))
            data{ifiles}(ilist,:)=[];
        end
    end
    % display process
    clc
    fprintf("%d / %d\r\n", ifiles, filecount)
    % print file deleted
    fprintf("fix the data to same length\r\n")
end

%% start machine learning
%% or statistic prediction