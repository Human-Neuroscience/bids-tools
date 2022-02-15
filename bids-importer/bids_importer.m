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
%  Conversion routine:

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

%% Extract TSV:
% Description: This function extracts the .tsv file from the psychtoolbox
% output data file. Be aware! This function is only valid for the specific
% data structure of our experiment.

if cfg.extractTSV
    
    % - Load behavioural files:
    
    filesInFolder = dir(rawTSV);
    
    for f = 1 : length(filesInFolder)
        if endsWith(filesInFolder(f).name, 'OUT_E.mat') || ...
                endsWith(filesInFolder(f).name, 'info.mat')
            
            load([rawTSV filesep filesInFolder(f).name]);
        end
    end
    
    % - Extract tsv:
    
    generate_tsv(OUT_E, EDATA, cfg);
    
end


%% HELPER.
%  Extract and import tsv files:
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: cgpenalver@ugr.es@ugr.es (J.M.G. Penalver)
% -------------------------------------------------------------------------

% Description: This function extracts the .tsv file from the psychtoolbox
% output data file. Be aware! This function is only valid for the specific
% data structure of our experiment.

function [] = generate_tsv(output, info, cfg)

% - Generate a .tsv file separately for each run:

for run = 1: size (output.stim,2)
    
    % - Individual filename for each .tsv file:
    
    runID = ['run-' int2str(run)];
    outFolder = [cfg.outputDirectory filesep cfg.subjectId filesep 'func'];
    fileName = [outFolder filesep cfg.subjectId '_' cfg.taskName '_' ...
        runID '_events.tsv'];
    
    % - Global zero timepoint, which corresponds with the first dummie:
    
    event = 1;
    zero = output.t.rel.Dummies(1,run);
    
    % - Dummies:
    
    for i = 1: size (output.t.rel.Dummies,1)
        
        onset(event) = output.t.rel.Dummies(i,run) - zero;
        section{event} = 'dummie';
        btype{event} = 'n/a';
        validity{event} = 'n/a';
        stim{event} = 'n/a';
        gender{event} = 'n/a';
        event = event + 1;
        
    end
    
    % - Cues:
    
    for i = 1:size (output.t.rel.cueOnset,1)
        
        onset(event) = output.t.rel.cueOnset(i,run) - zero;
        duration(event) = 0.5;
        section{event} = 'cue';
        btype{event} = output.Btype{i,run};
        validity{event} = output.validity{i,run};
        gender{event} = output.gender{i,run};
        accuracy(event) = output.ACC (i,run);
        reaction_time(event) = output.RT(i,run);
        
        % - Rename the cues and save it in stim: 
        
        if output.cue(i,run) == info.CueFace(1)
            stim{event} = 'CueFace1';
        elseif output.cue(i,run) == info.CueFace(2)
            stim{event} = 'CueFace2';
        elseif output.cue(i,run) == info.CueName(1)
            stim{event} = 'CueName1';
        else
            stim{event} = 'CueName2';
        end
        
        event = event + 1;
        
    end
    
    % Targets:
    
    for i = 1:size (output.t.rel.targetOnset,1)
        
        onset(event) = output.t.rel.targetOnset(i,run) - zero;
        duration(event) = 0.5;
        section{event} = 'target';
        btype{event} = output.Btype{i,run};
        validity{event} = output.validity{i,run};
        stim{event} = output.stimType{i,run};
        gender{event} = output.gender{i,run};
        accuracy(event) = output.ACC (i,run);
        reaction_time(event) = output.RT(i,run);
        
        event = event+1;
        
    end
    
    % - Generate, sort and save the .tsv file:
    
    onset = onset';
    duration = duration';
    section = section';
    btype = btype';
    validity = validity';
    stim = stim';
    gender = gender';
    accuracy = accuracy';
    reaction_time = reaction_time';
    
    t = table(onset, duration, section, btype, validity, stim,...
        gender, accuracy, reaction_time);
    
    t = sortrows(t, 'onset');
    
    writetable(t, fileName,'FileType', 'text','Delimiter', '\t');
    
    clear onset duration section btype validity stim gender accuracy ...
        reaction_time
    
end
end