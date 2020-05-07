function [] = saveAllData(folderIn,fileNameIn)
% Save All Data to File 
mkdir(folderIn)
eval(strcat("save('",folderIn,"/",fileNameIn,"')"))
end
