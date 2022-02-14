%% IMPORT CONFIGURATION FILE (import_configuration.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% OUTPUT directory:
% Description: Main directory of your BIDS compatible project.

cfg.outputDirectory = '/Users/David/Desktop/pruebabids/demo_dataset_fmri';

%% Task name:
% Description: Task name. According to BIDS specification this identifier 
% must include the prefix 'task-' followed by the name of the task.

cfg.taskName = 'task-attexp';

%% Subject ID:
% Description: Subject identifier. According to BIDS specification this
% identifier must include the prefix 'sub-' followed by a number.

cfg.subjectId = 'sub-001';

%% DICOM folder list:
% Description: Cell array of folders containing the dcm files to convert.
% Please note that you must specify the following information for each
% set of DICOM files:
%
% - FOLDER: Location of a set of dcm files to convert.
% - DATA_TYPE: A functional group of different types of data. Examples: 
%               - 'anat': Anatomical data.
%               - 'func': Functional data.
%               - 'fmap': Field mapping data.
%               - 'dwi':  Diffusion data.
%               - 'beh':  Behavioral data.
% - MODALITY: The category of brain data recorded by a file. Examples:
%               - 'T1w':  T1-weighted data.
%               - 'T2w':  T2-weighted data.
%               - 'bold': Functional data.
%               - 'dwi':  Diffusion data.
% - RUN: An uninterrupted repetition of data acquisition that has the same 
%        acquisition parameters and task. Example:
%               - 'run-1': Files corresponding to the first run.
%
%  (*) When applicable, the modality is indicated in the suffix


dcm{1}.folder = '/Users/David/Desktop/S01/Mruz_Chema/GIfMI_T1_MPRAGE_39';
dcm{1}.dataType = 'anat';   
dcm{1}.modality = 'T1w';
dcm{1}.run = 0; 

dcm{2}.folder = '/Users/David/Desktop/S01/Mruz_Chema/t2_tse_tra_448_p2_3mm_medico_5';
dcm{2}.dataType = 'anat';   
dcm{2}.modality = 'T2w';
dcm{2}.run = 0; 

dcm{3}.folder = '/Users/David/Desktop/S01/Mruz_Chema/ep2d_bold_RUN_1_13';
dcm{3}.dataType = 'func';   
dcm{3}.modality = 'bold'; 
dcm{3}.run = 'run-1'; 

dcm{4}.folder = '/Users/David/Desktop/S01/Mruz_Chema/ep2d_bold_RUN_2_18';
dcm{4}.dataType = 'func';   
dcm{4}.modality = 'bold'; 
dcm{4}.run = 'run-2'; 

dcm{5}.folder = '/Users/David/Desktop/S01/Mruz_Chema/ep2d_bold_RUN_3_23';
dcm{5}.dataType = 'func';   
dcm{5}.modality = 'bold'; 
dcm{5}.run = 'run-3';

dcm{6}.folder = '/Users/David/Desktop/S01/Mruz_Chema/ep2d_bold_RUN_4_28';
dcm{6}.dataType = 'func';   
dcm{6}.modality = 'bold'; 
dcm{6}.run = 'run-4';

dcm{7}.folder = '/Users/David/Desktop/S01/Mruz_Chema/ep2d_bold_RUN_5_33';
dcm{7}.dataType = 'func';   
dcm{7}.modality = 'bold'; 
dcm{7}.run = 'run-5';

% Special cases for field mapping not yet implemented.
% dcm{8}.folder = '/Users/David/Desktop/S01/Mruz_Chema/gre_field_mapping_2.5mm_10';
% dcm{8}.dataType = 'fmap';   
% dcm{8}.modality = 'fieldmap';
% dcm{8}.run = 0; 


%% Data format:
% Description: There are several data formats that can be selected in the 
% dicm2nii package:
%
% - 0 or '.nii'     for single nii uncompressed.
% - 1 or '.nii.gz'  for single nii compressed.
% - etc ...

cfg.dataFormat = '.nii';
