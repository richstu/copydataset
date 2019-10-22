# copydataset

Tools to copy datasets. Focused on copying nanoaods to ucsb.

## Setup

Run the below command to setup the git repository.

    git clone --recurse-submodules https://github.com/richstu/copydataset

Run the below command to setup the environment.
    
    source set_env.sh

## (Short) Steps for copying datasets

Edit the files in the `meta` directory and run the below commands

    make_datasets_jsons.py
    filter_datasets_jsons.py
    select_multiple_datasets_jsons.py
    write_datasets.py
    make_dataset_files_jsons.py
    write_dataset_files.py
    convert_dataset_files_to_cl.py mc DOWNLOAD_DIRECTORY ./results/cl_mc_dataset_files_info.py
    convert_dataset_files_to_cl.py data DOWNLOAD_DIRECTORY ./results/cl_data_dataset_files_info.py
    convert_dataset_files_to_cl.py SIGNAL_NAME DOWNLOAD_DIRECTORY ./results/cl_data_dataset_files_info.py

## Steps for copying datasets

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
The structure of the downlaod folders will be like DOWNLOAD_DIRECTORY/AOD_TAG/Nano/YEAR/DATA_TYPE,
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

## Test

One can run ./modules/datasets/test/get_datasets/get_datasets.sh to test the scripts.

# Lets make clean structure.
TODO Do data

source set_env.sh

Example
make_datasets_jsons.py -d nanoaod or update_datasets_jsons.py -d nanoaod
filter_datasets_jsons.py -d nanoaod
select_multiple_datasets_jsons.py -d nanoaod
write_datasets.py -d nanoaod
make_dataset_files_jsons.py or update_dataset_files_jsons.py
OPTIONAL write_dataset_files.py
make_disk_files_jsons.py
convert_dataset_files_to_cl.py mc /mnt/hadoop/jbkim/Download ./results/cl_dataset_files_info.py

convert_cl_to_jobs_info.py ./results/cl_dataset_files_info.py ./jsons/mc_jobs_info.json
submit_jobs.py jsons/mc_jobs_info.json -n cms1
check_jobs.py jsons/submitted_mc_jobs_info.json -c copy_aods_check_entries.py
select_resubmit_jobs.py jsons/checked_submitted_mc_jobs_info.json -c copy_aods_check_entries.py

auto_submit_jobs.py jsons/submitted_mc_jobs_info.json -c copy_aods_check_entries.py -n cms1

#  write list of files

#./make_datasets_jsons.py -d nanoaod -t mc or ./update_datasets_jsons.py -d nanoaod -t mc
# 
#./filter_datasets_jsons.py -d nanoaod -t mc
#./select_multiple_datasets_jsons.py -d nanoaod -t mc
#./write_datasets.py -d nanoaod -t mc
#./make_dataset_files_jsons.py -t mc or update_dataset_files_jsons.py -t mc
#./convert_dataset_files_to_cl.py ./jsons/mc_dataset_files_info.json /mnt/hadoop/jbkim/Download ./results/cl_dataset_files_info.py
#
#./convert_cl_to_jobs_info.py ./results/cl_dataset_files_info.py ./jsons/mc_jobs_info.json
#./submit_jobs.py jsons/mc_jobs_info.json -n cms1
#./check_jobs.py jsons/submitted_mc_jobs_info.json -c ./copy_aods_check_entries.py
#./select_resubmit_jobs.py jsons/checked_submitted_mc_jobs_info.json -c ./copy_aods_check_entries.py


#or ./auto_submit_jobs.py jsons/submitted_mc_jobs_info.json -c ./copy_aods_check_entries.py -n cms1

./make_datasets_jsons.py or ./update_datasets_jsons.py
./filter_datasets_jsons.py
./select_multiple_datasets_jsons.py
./write_datasets.py
./make_dataset_files_jsons.py
./convert_dataset_files_to_cl.py DATASET_FILES_JSON TARGET_DIRECTORY CL_DATASET_FILES_INFO

./convert_cl_to_jobs_info.py CL_DATASET_FILES_INFO JOBS_INFO
./submit_jobs JOBS_INFO -n cms1
# NEED to run in folder that has ./setcmsenv
./submit_jobs.py jsons/cl_dataset_files_info.py -n cms1
or
./auto_submit_jobs.py jsons/cl_dataset_files_info.py -c ./copy_aods_check_entries.py -n cms1

./check_jobs.py jsons/auto_cl_dataset_files_info.py -c ./copy_aods_check_entries.py
./select_resubmit_jobs.py jsons/checked_auto_cl_dataset_files_info.py -c ./copy_aods_check_entries.py
