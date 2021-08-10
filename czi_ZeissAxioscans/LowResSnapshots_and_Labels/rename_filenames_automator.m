% Automator: rename files (replace parts or filename

folderMFCKR = 'E:\anatomy_temp\20210412';
str2Replace = '2021-04-12_label_';
newString = 'mouse992243_CAVCre_Exp002_';
 

%%
filenames = uipickfiles('FilterSpec', fullfile(folderMFCKR, sprintf('%s*',str2Replace))); %there is a bug with output as a structure.
for i = 1:length(filenames)
    movefile(filenames{i}, strrep(filenames{i}, str2Replace, newString))
end
disp('last file:')
disp(filenames{i})

