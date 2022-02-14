%% DATASET DESCRIPTION FILE (dataset_description_json.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

% Please edit this file before gererate the final dataset structure. The
% file dataset_description.json will be created based on the information
% provided. 

% Information extracted from the oficial BIDS specification website.

%% Name (REQUIRED) [type: string]
% Description: Name of the dataset.

datasetDescription.Name = 'demo_dataset_fmri';

%% BIDSVersion (REQUIRED) [type: string]
% Description: The version of the BIDS standard that was used.

datasetDescription.BIDSVersion = '1.0.2';

%% DatasetType (RECOMMENDED) [type: string]
% Description: The interpretation of the dataset. MUST be one of "raw" or 
% "derivative". For backwards compatibility, the default value is "raw".

datasetDescription.DatasetType = 'raw';

%% License (RECOMMENDED) [type: string]
% Description: The license for the dataset. The use of license name 
% abbreviations is RECOMMENDED for specifying a license (see Appendix II). 
% The corresponding full license text MAY be specified in an additional 
% LICENSE file.

% List of included licenses and abbreviations:

% CCBY - Creative Commons Attribution 4.0 International: This license lets 
%        others distribute, remix, adapt, and build upon your work, even 
%        commercially, as long as they credit you for the original creation. 
%        Recommended for maximum dissemination and use of licensed
%        materials.

% CC0  - Creative Commons Zero 1.0 Universal: Use this if you are a holder 
%        of copyright or database rights, and you wish to waive all your 
%        interests in your work worldwide.

% Please note that this list only serves to provide some examples for 
% possible licenses. The terms of any license should be consistent with the 
% informed consent obtained from participants and any institutional 
% limitations on distribution.

% Plase, feel free to add more license files to tamplates/licenses folder. 

datasetDescription.License = 'CCBY';

%% Authors (OPTIONAL) [type: array of strings]
% Description: List of individuals who contributed to the creation/curation 
% of the dataset.

datasetDescription.Authors = {
    '';
    ''
    };

%% Acknowledgements (OPTIONAL) [type: string]
% Description: Text acknowledging contributions of individuals or 
% institutions beyond those listed in Authors or Funding.

datasetDescription.Acknowledgements = '';

%% HowToAcknowledge (OPTIONAL) [type: string]
% Description: Text containing instructions on how researchers using this 
% dataset should acknowledge the original authors. This field can also be 
% used to define a publication that should be cited in publications that 
% use the dataset.

datasetDescription.HowToAcknowledge = '';

%% Founding (OPTIONAL) [type: array of strings]
% Description: List of sources of funding (grant numbers).

datasetDescription.Founding = {
    '';
    ''
    };

%% EthicsApprovals (OPTIONAL) [type: array of strings]
% Description: List of ethics committee approvals of the research protocols 
% and/or protocol identifiers.

datasetDescription.EthicsApprovals = {
    '';
    ''
    };

%% ReferencesAndLinks (OPTIONAL) [type: array of strings]
% Description: List of references to publications that contain information 
% on the dataset. A reference may be textual or a URI.

datasetDescription.ReferencesAndLinks = {
    '';
    ''
    };

%% DatasetDOI (OPTIONAL) [type: string]
% Description: The Digital Object Identifier of the dataset (not the 
% corresponding paper). DOIs SHOULD be expressed as a valid URI; bare DOIs 
% such as 10.0.2.3/dfjj.10 are DEPRECATED.

datasetDescription.DatasetDOI = '';
