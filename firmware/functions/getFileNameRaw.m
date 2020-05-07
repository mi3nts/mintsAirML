function [fileNameRaw,rawStatus] = getFileNameRaw(nodeDataFiles,fileIndex)
    
    fileNameRaw = strcat(nodeDataFiles(fileIndex).folder,"/",nodeDataFiles(fileIndex).name);
    rawStatus = ~contains(fileNameRaw,"daily",'IgnoreCase',true) ;
    
end

