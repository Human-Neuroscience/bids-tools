%% BIDS IMPORTER (bids_importer.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

% This script converts the selected DICOMs to NIFTI files according to BIDS
% standard. For the conversion this script uses the dicm2nii package:
%
% - https://github.com/xiangruili/dicm2nii (REQUIRED)
%
% Please download & add the downloaded folder to your MATLAB path. Note
% that "Save json file" checkbox must be manually enabled using the GUI
% the first time you run this script. The preference change stays in effect
% until it is changed next time.

clc
clear all

%% Import configuration:

run cfg/import_configuration;

%% DICOM to NIFTI.
% Conversion routine:

for i = 1 : length (dcm)
    
    % - Extract information of the actual DICOM folder:
    
    dcmFolder = dcm{i}.folder;
    dataType  = dcm{i}.dataType;
    modality  = dcm{i}.modality;
    experrun  = dcm{i}.run;
    
    % - Match folder:
    
    dcmFolder = dir(dcmFolder);
    dcmFolder = [dcmFolder.folder filesep dcmFolder.name];
    
    % - Generate the output folder and filename:
    
    if strcmp(dataType,'func') && ischar(experrun)
        fileName = [cfg.subjectId '_' cfg.taskName '_' experrun '_' modality];
    else
        fileName = [cfg.subjectId '_' modality];
    end
    
    outFolder = [cfg.outputDirectory filesep cfg.subjectId filesep dataType];
    
    % - DICOM to NIFTI conversion:
    
    dicm2nii(dcmFolder, outFolder, cfg.dataFormat);
    
    % - Rename converted files for BIDS compatibility:
    
    headerFile = [outFolder '/dcmHeaders.mat'];
    load(headerFile);
    fn = fieldnames(h);
    
    fname  = [outFolder filesep fn{1}];
    fname_ = [outFolder filesep fileName];
    
    movefile([fname cfg.dataFormat], [fname_ cfg.dataFormat]);
    movefile([fname '.json'], [fname_ '.json']);

    delete([outFolder '/dcmHeaders.mat']); 
    
    % - Fix TaskName problem:
    
    if strcmp(dataType,'func')
        
        % Open side-car JSON file:
        
        str = fileread([fname_ '.json']);
        data = jsondecode(str);
        
        % Update side-car JSON file:
        
        data.TaskName = cfg.taskName;
        
        if verLessThan('matlab','9.10')
            data = jsonencode(data);
        else
            data = jsonencode(data,'PrettyPrint',true);
        end
    
        % Save side-car JSON file:
        
        fid = fopen([fname_ '.json'], 'w');
        if fid == -1, error('Cannot create JSON file'); end
        fwrite(fid, data, 'char');
        fclose(fid);
        
    end
end