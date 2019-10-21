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
