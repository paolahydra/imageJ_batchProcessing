% Automator: move files for confocal stitching

rootfolderOrigin = 'M:\patepaol\confocal\FV10_Paola_210503_0003';
newCommonFolder = 'E:\anatomy_temp\confocalTest\Mosaic_4';
nTilesX = 8;
nTilesY = 7;
i_start = 68;
i_end = i_start+nTilesX*nTilesY-1;

%overlap 25%
%%
for i = i_start:i_end
    foldername = fullfile(rootfolderOrigin, sprintf('Track%02d',i)); 
    d = dir(fullfile(foldername, '*.oib'));
    file2move = fullfile(foldername, d.name);
    copyfile(fullfile(foldername, d.name), fullfile(newCommonFolder, sprintf('Image_%02d.oib',i-i_start+1)))
end
disp('Done.')

%%
% overlap is either 12.5% (if considering one side only), or 25% if
% considering both sides