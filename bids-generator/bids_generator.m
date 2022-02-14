%% GENERATE BIDS DATASET (bids_generator.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

% This script generates a BIDS-validated folder structure. Plese check and 
% edit the following configuration scripts before execute bids_generator.m:
% 
% - cfg/dataset_configuration.m
% - cfg/dataset_description.m

clc
clear all

%% Import dataset description and configuration:

run cfg/dataset_description_json;
run cfg/dataset_configuration;

%% Generate main folder:

mainFolder = [cfg.outputDirectory filesep datasetDescription.Name];

if ~exist(mainFolder, 'dir')
    [status,msg] = mkdir(mainFolder);
else
    error('BIDS-GENERATOR ERROR: This folder already exist.');
end

%% Generate and save the dataset description in a JSON file:

if verLessThan('matlab','9.10')
    data = jsonencode(datasetDescription);
else
    data = jsonencode(datasetDescription,'PrettyPrint',true);
end
        
fid = fopen([mainFolder filesep 'dataset_description.json'], 'w');
if fid == -1, error('Cannot create JSON file'); end
fwrite(fid, data, 'char');
fclose(fid);

%% Import LICENSE file:

if cfg.licenseFile
    if ~isempty(datasetDescription.License)
        file = ['templates/licenses/' datasetDescription.License];
        copyfile(file, [mainFolder filesep 'LICENSE']);
        disp(['> License file ' ...
            datasetDescription.License ...
            ' has been added to the project folder.'])
    end
end

%% Import README file:

if cfg.readmeFile
    file = 'templates/README';
    copyfile(file, [mainFolder filesep 'README']);
    disp('> Warning: Please, remember to edit the generated README file.')
end

%% Generate initial CHANGES file:

if cfg.changesFile
    changesLog = [date ' - Project creation.'];
    fid = fopen([mainFolder filesep 'CHANGES'], 'w');
    if fid == -1, error('Cannot create CHANGES file'); end
    fwrite(fid, changesLog, 'char');
    fclose(fid);
    disp('> Warning: Please, remember to edit the generated CHANGES file.')
end

%% Generate subject/session/data folders

for i = 1 : cfg.numberSubjects
    
    subjectFolder = [mainFolder filesep 'sub-' num2str(i,'%.3d')];
    mkdir(subjectFolder);
    
    for j = 1 : cfg.numberSessions
        
        if (cfg.numberSessions == 1) && (j == 1) && cfg.ignoreSingleSession 
            sessionFolder = subjectFolder;
        else
            sessionFolder = [subjectFolder filesep 'ses-' num2str(j,'%.3d')];
            mkdir(sessionFolder);
        end
        
        if cfg.anatomical(j), mkdir([sessionFolder filesep 'anat']); end
        if cfg.functional(j), mkdir([sessionFolder filesep 'func']); end
        if cfg.fieldmaps(j),  mkdir([sessionFolder filesep 'fmap']); end
        if cfg.diffusion(j),  mkdir([sessionFolder filesep 'dwi']);  end
        
    end
end

fprintf('<strong>> Done! </strong>\n');
