# copydataset

Tools to copy datasets. Focused on copying nanoaods to ucsb.

## Setup

Run the below command to setup the git repository.

    git clone --recurse-submodules https://github.com/richstu/copydataset

Run the below command to setup the environment.
    
    source set_env.sh

## (Short) Steps for copying datasets

Edit the files in the `meta` directory and run the below commands to get information about the datasets to download.

    make_datasets_jsons.py
    filter_datasets_jsons.py
    select_multiple_datasets_jsons.py
    write_datasets.py
    make_dataset_files_jsons.py
    write_dataset_files.py
    convert_dataset_files_to_cl.py mc DOWNLOAD_DIRECTORY ./results/cl_mc_dataset_files.py
    convert_dataset_files_to_cl.py data DOWNLOAD_DIRECTORY ./results/cl_data_dataset_files.py
    convert_dataset_files_to_cl.py SIGNAL_NAME DOWNLOAD_DIRECTORY ./results/cl_SIGNAL_NAME_dataset_files.py

Setup the cms voms_proxy. Run the below commands to submit to the ucsb job system.

    convert_cl_to_jobs_info.py ./results/cl_mc_dataset_files.py ./jsons/mc_jobs_info.json
    auto_submit_jobs.py ./jsons/mc_jobs_info.json -n cms1 -c copy_aods_check_entries.py

    convert_cl_to_jobs_info.py ./results/cl_data_dataset_files.py ./jsons/data_jobs_info.json
    auto_submit_jobs.py ./jsons/data_jobs_info.json -n cms1 -c copy_aods_check_entries.py

    convert_cl_to_jobs_info.py ./results/cl_SIGNAL_NAME_dataset_files.py ./jsons/SIGNAL_NAME_jobs_info.json
    auto_submit_jobs.py ./jsons/SIGNAL_NAME_jobs_info.json -n cms1 -c copy_aods_check_entries.py

Check reason of failed jobs and set status submit again for failed jobs.

    select_resubmit_jobs.py jsons/auto_mc_jobs_info.json -c copy_aods_check_entries.py
    select_resubmit_jobs.py jsons/auto_data_jobs_info.json -c copy_aods_check_entries.py
    select_resubmit_jobs.py jsons/auto_SIGNAL_NAME_jobs_info.json -c copy_aods_check_entries.py

Resubmit jobs if needed.

    auto_submit_jobs.py ./jsons/resubmit_auto_mc_jobs_info.json -n cms1 -c copy_aods_check_entries.py
    auto_submit_jobs.py ./jsons/resubmit_auto_data_jobs_info.json -n cms1 -c copy_aods_check_entries.py
    auto_submit_jobs.py ./jsons/resubmit_auto_SIGNAL_NAME_jobs_info.json -n cms1 -c copy_aods_check_entries.py

## (Long) Steps for copying datasets

### Setup meta files.

The datasets you want to download should be written in the files located in meta.
For data datasets, edit `meta/data_tag_meta`. For mc and signal datasets, edit `meta/mc_dataset_*`

### Get information about datasets using dasgoclient.

The below command uses the meta files to get information about the datasets.

    make_datasets_jsons.py

The information is stored in json files.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * meta/mc_dataset_common_names
  * meta/mc_dataset_2016_names
  * meta/mc_dataset_2017_names
  * meta/mc_dataset_2018_names
  * meta/mc_tag_meta
  * meta/data_tag_meta
* Output files:
  * jsons/mc_datasets.json
  * jsons/data_datasets.json

### Filter datasets that are not used.

The below command filters some of the datasets based on the name of the dataset.

    filter_datasets_jsons.py

The filtered datasets are stored in json files.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * meta/mc_dataset_common_names
  * meta/mc_dataset_2016_names
  * meta/mc_dataset_2017_names
  * meta/mc_dataset_2018_names
  * meta/mc_tag_meta
  * meta/data_tag_meta
  * jsons/mc_datasets.json
  * jsons/data_datasets.json
* Output files:
  * jsons/filtered_mc_datasets.json
  * jsons/filtered_bad_pu_mc_datasets.json
  * jsons/filtered_bad_ps_weight_mc_datasets.json
  * jsons/filtered_data_datasets.json

### Select datasets that have multiple options.

The below command is for selecting datasets that have multiple options.

    select_multiple_datasets_jsons.py

The selected datasets are stored in json files. 
The reason of the selection is stored in `jsons/selected_mc_multiple_selection.json`.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * meta/mc_dataset_common_names
  * meta/mc_dataset_2016_names
  * meta/mc_dataset_2017_names
  * meta/mc_dataset_2018_names
  * meta/mc_tag_meta
  * meta/data_tag_meta
  * jsons/filtered_mc_datasets.json
  * jsons/filtered_data_datasets.json
* Output files:
  * jsons/selected_mc_multiple_selection.json
  * jsons/selected_mc_datasets.json
  * jsons/selected_data_datasets.json

### Write dataset full names to a plain text file

The below command writes the dataset full names to a text file.
This step make it easy to go to the next step if the full dataset names are known.

    write_datasets.py

The datasets are written to a text file. 
empties are datasets that are missing.
bad_pu are datasets that have no other choice than to use bad pileup.
bad_ps_weight are datasets that have no other choice than to use ps_weight.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * meta/mc_dataset_common_names
  * meta/mc_dataset_2016_names
  * meta/mc_dataset_2017_names
  * meta/mc_dataset_2018_names
  * meta/mc_tag_meta
  * meta/data_tag_meta
  * jsons/selected_mc_datasets.json
  * jsons/selected_data_datasets.json
* Output files:
  * results/mc_dataset_paths
  * results/mc_dataset_empties
  * results/bad_pu_mc_dataset_paths
  * results/bad_ps_weight_mc_dataset_paths
  * results/data_dataset_paths
  * results/data_dataset_empties

### Get file information for the datasets

The below command gets file information about the datasets using dasgoclient.

    make_dataset_files_jsons.py

The dataset file information is stored in json files.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * results/mc_dataset_paths
  * results/data_dataset_paths
* Output files:
  * jsons/mc_dataset_files_info.json
  * jsons/data_dataset_files_info.json

### (Optional) Write dataset files to a plain text file

The below command writes dataset file paths to a text file.

    write_dataset_files.py

One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
  * jsons/mc_dataset_files_info.json
  * jsons/data_dataset_files_info.json
* Output files:
  * results/mc_dataset_files
  * results/data_dataset_files

### Convert file information to commands to download files.

The below command makes a python script that prints the command lines to download the files.

    convert_dataset_files_to_cl.py DATA_TYPE DOWNLOAD_DIRECTORY OUT_PYTHON_SCRIPT
 
DATA_TYPE can be either mc or data or the signal name. DATA_TYPE is used in setting the download folder.
DATA_TYPE should also be written in `mc_tag_meta`.
The structure of the downlaod folders will be like DOWNLOAD_DIRECTORY/AOD_TAG/nano/YEAR/DATA_TYPE,
where AOD_TAG is like NanoAODv5.

* Input files:
  * meta/mc_dataset_common_names
  * meta/mc_dataset_2016_names
  * meta/mc_dataset_2017_names
  * meta/mc_dataset_2018_names
  * meta/mc_tag_meta
  * meta/data_tag_meta
  * jsons/selected_mc_datasets.json
  * jsons/selected_data_datasets.json
* Output files:
  * OUT_PYTHON_SCRIPT

### Converting commands to queue_system format

The below command convert the printed commands to a queue_system format.

    convert_cl_to_jobs_info.py IN_PRINT_COMMAND_SCRIPT OUT_JOB_INFO.json

IN_PRINT_COMMAND_SCRIPT should print the commands to run.
OUT_JOB_INFO.json is the file which holds the information in the queue_system format

* Input files:
  * IN_PRINT_COMMAND_SCRIPT
* Output files:
  * OUT_JOB_INFO.json

### Auto-submit the jobs

The below command submits jobs and then checks if the job should be re-submitted according to a check script.
    
    auto_submit_jobs.py IN_JOB_INFO.json -n NODE_NAME -c CHECK_SCRIPT

IN_JOB_INFO.json is the file which holds the information in the queue_system format.
An output JOB_INFO json file will be produced with the prefix of 'auto_'
The CHECK_SCRIPT will receive a compressed string as a argument which holds the job_log and the job_argument.
The string can be uncompressed using the queue_system.decompress_string. 
The check script should print [For queue_system] JOB_STATUS
JOB_STATUS can be 'success', 'fail' or 'to_submit'.
Look at modules/queue_system/bin/jobscript_check.py for an example.

* Input files:
  * IN_JOB_INFO.json
* Output files:
  * auto_OUT_JOB_INFO.json

### Select jobs to resubmit between failed jobs.

The below script prints info about failed jobs and asks if one wants to resubmit.

    select_resubmit_jobs.py IN_JOB_INFO.json -c CHECK_SCRIPT 

IN_JOB_INFO.json is the file which holds the information in the queue_system format.
An output JOB_INFO json file will be produced with the prefix of 'resubmit_'
The CHECK_SCRIPT should be the check script that was used in submitting the jobs.
 
* Input files:
  * IN_JOB_INFO.json
* Output files:
  * resubmit_OUT_JOB_INFO.json

## Test

One can run cd modules/datasets/test/get_datasets;./get_datasets.sh to test the scripts.
One can run cd modules/queue_system/test/datasets;./submit_datasets.sh to test the scripts.

## Steps for git push with submodules.

After modifying submodule code, run the below commands to push changes.

    cd SUBMODULE_DIRECTORY
    git commit -am "COMMENT"
    git pull origin master
    git push origin master
