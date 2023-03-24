%% DATASET CONFIGURATION FILE (dataset_configuration.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Output directory (REQUIRED):
% Description: The output directory where the project folder structure will
% be created.

cfg.outputDirectory = '/Users/David/Desktop';

%% Subjects (REQUIRED):
% Description: Specify the number of subject's folders that will be
% created.

cfg.numberSubjects = 32;

%% Sessions (REQUIRED):
% Description: Specify the number of recording sessions per subject. If
% there is only one session, the session folder can be omited.

cfg.numberSessions = 1;
cfg.ignoreSingleSession = true;

%% Modality specific files (REQUIRED)
% Description: Please specify the required data folders that will be
% created per session. Note that each column corresponds to an individual
% session.

cfg.anatomical = [0 0];
cfg.functional = [0 0];
cfg.fieldmaps  = [0 0];
cfg.diffusion  = [0 0];

%% Include extra files:
% Description: BIDS specification recommends to add some extra files to the
% project folder. 

cfg.readmeFile  = true;
cfg.licenseFile = true;
cfg.changesFile = true;
cfg.bidsIgnore  = false; % Not implemented yet.

%% Derivatives:
% Description: Not implemented yet.
cfg.derivarives = 0;
