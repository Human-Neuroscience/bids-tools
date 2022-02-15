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
    
    % - Generate the output folder and filename:
    
    if strcmp(dataType,'func') && ischar(experrun)
        
        fileName = [cfg.subjectId '_' cfg.taskName '_' experrun '_' modality];
        
    elseif strcmp(dataType,'fmap')
        
        fileName = cfg.subjectId;
        
    else
        
        fileName = [cfg.subjectId '_' modality];
        
    end
    
    outFolder = [cfg.outputDirectory filesep cfg.subjectId filesep dataType];
    
    % - Match DICOM folder:
    
    dcmFolder = dir(dcmFolder);
    
    for f = 1 : length(dcmFolder)
        
        inFolder = [dcmFolder(f).folder filesep dcmFolder(f).name];
    
        % - DICOM to NIFTI conversion:
    
        dicm2nii(inFolder, outFolder, cfg.dataFormat);
        
    end
    
    % - Rename converted files for BIDS compatibility. For field maps more
    %   than one files must be renamed.
    
    headerFile = [outFolder '/dcmHeaders.mat'];
    load(headerFile);
    fn = fieldnames(h);
    
    for f = 1 : length(fn)
        
        if endsWith(fn{f},'_e1')
            fn_ = [fileName '_magnitude1'];
        elseif endsWith(fn{f},'_e2')
            fn_ = [fileName '_magnitude2'];
        elseif endsWith(fn{f},'_phase')
            fn_ = [fileName '_phasediff'];
        else
            fn_ = fileName;
        end
        
        fname  = [outFolder filesep fn{f}];
        fname_ = [outFolder filesep fn_];

        movefile([fname cfg.dataFormat], [fname_ cfg.dataFormat]);
        movefile([fname '.json'], [fname_ '.json']);
        
    end

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