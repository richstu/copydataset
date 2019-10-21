# copydataset

Tools to copy datasets. Focused on copying nanoaods to ucsb.

## Setup

Run the below command to setup the git repository.

    git clone --recurse-submodules https://github.com/richstu/copydataset

Run the below command to setup the environment.
    
    source set_env.sh

## Steps for copying datasets

* Setup meta files.
The datasets you want to download should be written in the files located in meta.
For data datasets, edit `data_tag_meta`. For mc and signal datasets, edit `mc_dataset_*`

* Get information about datasets using dasgoclient.
    make_datasets_jsons.py
The above command uses the meta files to get information about the datasets.
The information is stored in json files.
One can customize the input and output files using arguments, which can be seen with the argument -h.
Input files:
  meta/mc_dataset_common_names
  meta/mc_dataset_2016_names
  meta/mc_dataset_2017_names
  meta/mc_dataset_2018_names
  meta/mc_tag_meta
  meta/data_tag_meta
Output files:
  jsons/mc_datasets.json
  jsons/data_datasets.json


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
