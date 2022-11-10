# copydataset

Tools to copy datasets. Focused on copying nanoaods to ucsb.

## Setup

Run the below command to setup the git repository.

    git clone --recurse-submodules git@github.com:richstu/copydataset.git

Run the below command to setup the environment.
    
    source set_env.sh

## (Short) Steps for copying datasets

Note: Need to make json files using cc7, because dasgoclient doesn't work well with SL6.  
Copy one of the meta_* directories to `meta`.   
Make `jsons` directory or copy the matching json_* directory to `jsons` to use the MC selections that was done before.  
Make a `results` directory. Edit the files in the `meta` directory.   
In the mc_dataset_* files, one can also assign a SIGNAL_NAME_DIR to a dataset, which is used to be the directory name for the files.  
Run the below commands to get information about the datasets to download.  

    make_datasets_jsons.py
    filter_datasets_jsons.py
    select_multiple_datasets_jsons.py
    write_datasets.py
    (optional) write_datasets.py -t mc -y 2016 -op 2016_
    (optional) write_datasets.py -t data -y 2016 -op 2016_
    make_dataset_files_jsons.py
    (optional) make_disk_files_jsons.py
    (optional) write_dataset_files.py -t mc -s 'dataset_year="2016"' -op mc_
    (optional) write_dataset_files.py -t data -s 'dataset_year="2016"' -op data_
    # Need to split by year due to writing into different folders by year
    # If make_disk_files_jsons.py is ran, convert_dataset_files_to_cl.py uses results and and does not download files that are on disk.
    convert_dataset_files_to_cl.py mc /mnt/hadoop/pico ./results/cl_mc_dataset_files_2016.py -s 'dataset_year="2016"'
    convert_dataset_files_to_cl.py data /mnt/hadoop/pico ./results/cl_data_dataset_files_2016.py -s 'dataset_year="2016"'
    convert_dataset_files_to_cl.py SIGNAL_NAME_DIR /mnt/hadoop/pico ./results/cl_SIGNAL_NAME_DIR_dataset_files.py_2016 -s 'dataset_year="2016"'

Now we are ready to submit jobs. But before submitting the jobs, do voms-proxy-init on cms1.

    ssh cms1
    voms-proxy-init -voms cms -valid 168:0

Make sure you have write permissions to the target folder. Ex) /net/cms17/cms17r0/pico/NanoAODv9/nano/20XX/mc, ...
Run the below commands to submit to the ucsb job system.
    screen
    source set_env.sh
  
    convert_cl_to_jobs_info.py ./results/cl_mc_dataset_files.py ./jsons/mc_jobs_info.json
    auto_submit_jobs.py ./jsons/mc_jobs_info.json -n cms1 -c copy_aods_check_entries.py

    convert_cl_to_jobs_info.py ./results/cl_data_dataset_files.py ./jsons/data_jobs_info.json
    auto_submit_jobs.py ./jsons/data_jobs_info.json -n cms1 -c copy_aods_check_entries.py

    convert_cl_to_jobs_info.py ./results/cl_SIGNAL_NAME_dataset_files.py ./jsons/SIGNAL_NAME_jobs_info.json
    auto_submit_jobs.py ./jsons/SIGNAL_NAME_jobs_info.json -n cms1 -c copy_aods_check_entries.py

In case checking jobs needs to be redone
    
    check_jobs.py jsons/auto_mc_jobs_info.json -o jsons/check_auto_mc_jobs_info.json -c copy_aods_check_entries.py

Check reason of failed jobs and set status submit again for failed jobs.

    select_resubmit_jobs.py jsons/auto_mc_jobs_info.json -c copy_aods_check_entries.py
    select_resubmit_jobs.py jsons/auto_data_jobs_info.json -c copy_aods_check_entries.py
    select_resubmit_jobs.py jsons/auto_SIGNAL_NAME_jobs_info.json -c copy_aods_check_entries.py

Resubmit jobs if needed.

    auto_submit_jobs.py ./jsons/resubmit_auto_mc_jobs_info.json -n cms1 -c copy_aods_check_entries.py
    auto_submit_jobs.py ./jsons/resubmit_auto_data_jobs_info.json -n cms1 -c copy_aods_check_entries.py
    auto_submit_jobs.py ./jsons/resubmit_auto_SIGNAL_NAME_jobs_info.json -n cms1 -c copy_aods_check_entries.py

## (Short) Case of updating the meta file.

If the meta file is updated run the below commands to update the json files and get the commands to download the additional datasets. 
(Does not work if the nanoaod tag name has changed. In this case, please make the datasets json file again.)

    update_datasets_jsons.py
    filter_datasets_jsons.py -ip updated_
    select_multiple_datasets_jsons.py
    (optional) write_datasets.py -t mc -y 2016 -op 2016_
    (optional) write_datasets.py -t data -y 2016 -op 2016_
    update_dataset_files_jsons.py
    (optional) write_dataset_files.py -t mc -s "dataset_year=2016" -op mc_
    (optional) write_dataset_files.py -t data -s "dataset_year=2016" -op data_
    convert_dataset_files_to_cl.py mc /mnt/hadoop/pico ./results/cl_mc_dataset_files.py -s 'dataset_year="2016"' -if updated_
    convert_dataset_files_to_cl.py data /mnt/hadoop/pico ./results/cl_data_dataset_files.py -s 'dataset_year="2016"' -if updated_
    convert_dataset_files_to_cl.py SIGNAL_NAME /mnt/hadoop/pico ./results/cl_SIGNAL_NAME_dataset_files.py -s 'dataset_year="2016"' -if updated_

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

### Get information of files that are on disk

The below command gets information of files that are on disk

    make_disk_files_jsons.py

The file information is stored in a json file.
One can customize the input and output files using arguments, which can be seen with the argument -h.

* Input files:
* Output files:
  * jsons/mc_disk_files.json
  * jsons/data_disk_files.json

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
Can also do a sql search on the datasets to limit the files to be copied with the option -s. Below are the keys that can be used to search.
For Mc: filename, path, file_events, file_size, mc_dataset_name, year, data_tier, size, files, events, lumis, mc_dir, year_tag, miniaod_tag, nanoaod_tag, 
For Data: filename, path, file_events, file_size, stream, year, run_group, data_tier, size, files, events, lumis, mc_dir, year_tag, miniaod_tag, nanoaod_tag, nanoaodsim_tag
* filename: Filename of the dataset file. Ex) /store/mc/../...
* dataset_path: Dataset name. Ex) /TTJets...
* file_events: Number of events in the file
* file_size: File size of the file
* mc_dataset_name: The name of the dataset in the meta/mc_dataset_*_names
* dataset_year: year of the dataset Ex) 2016, 2017, 2018
* data_tier: miniaod or nanoaod
* size: Total size of the dataset
* events: Number of events for the dataset
* lumis: Number of lumis for the dataset
* mc_dir: Directory that the files will be downloaded to. Ex) mc
* year_tag: Tag of the year. Ex) RunIIFalll17
* miniaod_tag: Tag of the miniaod Ex) MiniAODv2
* nanoaod_tag: Tag of the nanooad Ex) NanoAODv5 for mc and Nano1June2019 for data
* dataset_stream: Trigger name of the data. Ex) MET
* dataset_run_group: Ex) A
* nanoaodsim_tag: NanoAODv5
An example of a search string would be
"year=17 and mc_dir=mc"


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
    git push origin HEAD:master

# Example of signal
make_datasets_jsons.py -m 20200113 -o 20200113 -t mc
filter_datasets_jsons.py -i ./20200113 -o ./20200113 -t mc -m ./20200113
cp jsons/selected_mc_multiple_selection.json 20200113/
select_multiple_datasets_jsons.py -t mc -i ./20200113/ -o ./20200113/ -t mc -m ./20200113
write_datasets.py -i ./20200113/ -o 20200113 -t SMS-TChiHH_unsplit -m ./20200113
make_dataset_files_jsons.py -i ./20200113 -o 20200113 -t mc
convert_dataset_files_to_cl.py SMS-TChiHH_unsplit /net/cms29/cms29r0/pico ./20200113/cl_mc_dataset_files_2016.py -m 20200113 -i 20200113 -s dataset_year=2016
convert_dataset_files_to_cl.py SMS-TChiHH_unsplit /net/cms29/cms29r0/pico ./20200113/cl_mc_dataset_files_2017.py -m 20200113 -i 20200113 -s dataset_year=2017
convert_dataset_files_to_cl.py SMS-TChiHH_unsplit /net/cms29/cms29r0/pico ./20200113/cl_mc_dataset_files_2018.py -m 20200113 -i 20200113 -s dataset_year=2018
convert_cl_to_jobs_info.py ./20200113/cl_mc_dataset_files_2016.py ./20200113/mc_jobs_info_2016.json
convert_cl_to_jobs_info.py ./20200113/cl_mc_dataset_files_2017.py ./20200113/mc_jobs_info_2017.json
convert_cl_to_jobs_info.py ./20200113/cl_mc_dataset_files_2018.py ./20200113/mc_jobs_info_2018.json
auto_submit_jobs.py ./20200113/mc_jobs_info_2016.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20200113/mc_jobs_info_2017.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20200113/mc_jobs_info_2018.json -n cms1 -c copy_aods_check_entries.py

# Example for data
cd 20200114;cp mc_dataset_common_names data_tag_meta mc_dataset_2016_names mc_dataset_2017_names mc_dataset_2018_names mc_tag_meta ../20200326
make_datasets_jsons.py -m 20200326 -o 20200326 -t data
filter_datasets_jsons.py -i ./20200326 -o ./20200326 -t data -m ./20200326
select_multiple_datasets_jsons.py -t data -i ./20200326/ -o ./20200326/ -m ./20200326
write_datasets.py -i ./20200326/ -o 20200326 -t data -m ./20200326
make_dataset_files_jsons.py -i ./20200326 -o 20200326 -t data

convert_dataset_files_to_cl.py data /net/cms29/cms29r0/pico ./20200326/cl_data_dataset_files_2016.py -m 20200326 -i 20200326 -s dataset_year=2016
convert_dataset_files_to_cl.py data /net/cms29/cms29r0/pico ./20200326/cl_data_dataset_files_2017.py -m 20200326 -i 20200326 -s dataset_year=2017
convert_dataset_files_to_cl.py data /net/cms29/cms29r0/pico ./20200326/cl_data_dataset_files_2018.py -m 20200326 -i 20200326 -s dataset_year=2018
convert_cl_to_jobs_info.py ./20200326/cl_data_dataset_files_2016.py ./20200326/data_jobs_info_2016.json
convert_cl_to_jobs_info.py ./20200326/cl_data_dataset_files_2017.py ./20200326/data_jobs_info_2017.json
convert_cl_to_jobs_info.py ./20200326/cl_data_dataset_files_2018.py ./20200326/data_jobs_info_2018.json
auto_submit_jobs.py ./20200326/data_jobs_info_2016.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20200326/data_jobs_info_2017.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20200326/data_jobs_info_2018.json -n cms1 -c copy_aods_check_entries.py

# Example for mc and signal
Important files: mc_dataset_common_names data_tag_meta mc_dataset_2016_names mc_dataset_2017_names mc_dataset_2018_names mc_tag_meta [20201029 is up to date for data and mc] 
make_datasets_jsons.py -m 20201029 -o 20201029 -t mc
filter_datasets_jsons.py -i ./20201029 -o ./20201029 -t mc -m ./20201029
select_multiple_datasets_jsons.py -t mc -i ./20201029 -o ./20201029 -t mc -m ./20201029
check_same_parent.py -i ./20201029 -o ./20201029 -t mc -m ./20201029 -ip selected_
write_datasets.py -i ./20201029/ -o 20201029 -t mc -m ./20201029 -y 2016 -op NanoAODv7_higgsino_2016_
write_datasets.py -i ./20201029/ -o 20201029 -t mc -m ./20201029 -y 2017 -op NanoAODv7_higgsino_2017_
write_datasets.py -i ./20201029/ -o 20201029 -t mc -m ./20201029 -y 2018 -op NanoAODv7_higgsino_2018_
write_datasets.py -i ./20201029/ -o 20201029 -t SMS-TChiHH_2D_unsplit -m ./20201029 -op SMS-TChiHH_2D_unsplit_
make_dataset_files_jsons.py -i ./20201029 -o 20201029 -t mc
make_dataset_files_jsons.py -i ./20201029 -o 20201029 -t mc -op SMS-TChiHH_2D_unsplit_ -ip SMS-TChiHH_2D_unsplit_

convert_dataset_files_to_cl.py mc /net/cms25/cms25r5/pico ./20201029/cl_mc_dataset_files_2016.py -m 20201029 -i 20201029 -s dataset_year=2016
convert_dataset_files_to_cl.py mc /net/cms25/cms25r5/pico ./20201029/cl_mc_dataset_files_2017.py -m 20201029 -i 20201029 -s dataset_year=2017
convert_dataset_files_to_cl.py mc /net/cms25/cms25r5/pico ./20201029/cl_mc_dataset_files_2018.py -m 20201029 -i 20201029 -s dataset_year=2018
convert_cl_to_jobs_info.py ./20201029/cl_mc_dataset_files_2016.py ./20201029/mc_jobs_info_2016.json
convert_cl_to_jobs_info.py ./20201029/cl_mc_dataset_files_2017.py ./20201029/mc_jobs_info_2017.json
convert_cl_to_jobs_info.py ./20201029/cl_mc_dataset_files_2018.py ./20201029/mc_jobs_info_2018.json
auto_submit_jobs.py ./20201029/mc_jobs_info_2016.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20201029/mc_jobs_info_2017.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20201029/mc_jobs_info_2018.json -n cms1 -c copy_aods_check_entries.py


convert_dataset_files_to_cl.py SMS-TChiHH_2D_unsplit /net/cms25/cms25r5/pico ./20201029/cl_sig_dataset_files_2016.py -m 20201029 -i 20201029 -s dataset_year=2016 -if SMS-TChiHH_2D_unsplit_
convert_dataset_files_to_cl.py SMS-TChiHH_2D_unsplit /net/cms25/cms25r5/pico ./20201029/cl_sig_dataset_files_2017.py -m 20201029 -i 20201029 -s dataset_year=2017 -if SMS-TChiHH_2D_unsplit_
convert_dataset_files_to_cl.py SMS-TChiHH_2D_unsplit /net/cms25/cms25r5/pico ./20201029/cl_sig_dataset_files_2018.py -m 20201029 -i 20201029 -s dataset_year=2018 -if SMS-TChiHH_2D_unsplit_
convert_cl_to_jobs_info.py ./20201029/cl_sig_dataset_files_2016.py ./20201029/sig_jobs_info_2016.json
convert_cl_to_jobs_info.py ./20201029/cl_sig_dataset_files_2017.py ./20201029/sig_jobs_info_2017.json
convert_cl_to_jobs_info.py ./20201029/cl_sig_dataset_files_2018.py ./20201029/sig_jobs_info_2018.json
auto_submit_jobs.py ./20201029/sig_jobs_info_2016.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20201029/sig_jobs_info_2017.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20201029/sig_jobs_info_2018.json -n cms1 -c copy_aods_check_entries.py

write_dataset_files.py -t mc -s "dataset_year=2016" -op NanoAODv7_higgsino_2016_mc_ 
write_dataset_files.py -t mc -s "dataset_year=2017" -op NanoAODv7_higgsino_2017_mc_
write_dataset_files.py -t mc -s "dataset_year=2018" -op NanoAODv7_higgsino_2018_mc_

# Downloading T5qqqqZH signal
Important files: mc_dataset_common_names data_tag_meta mc_dataset_2016_names mc_dataset_2017_names mc_dataset_2018_names mc_tag_meta [meta_current is up to date for data, mc, signal] 
make_datasets_jsons.py -m 20210119 -o 20210119 -t mc
filter_datasets_jsons.py -i ./20210119 -o ./20210119 -t mc -m ./20210119
select_multiple_datasets_jsons.py -t mc -i ./20210119 -o ./20210119 -t mc -m ./20210119
check_same_parent.py -i ./20210119 -o ./20210119 -t mc -m ./20210119 -ip filtered_
write_datasets.py -i ./20210119/ -ip filtered_ -o 20210119 -t SMS-T5qqqqZH_unsplit -m ./20210119 -op SMS-T5qqqqZH_unsplit_
make_dataset_files_jsons.py -i ./20210119 -ip filtered_ -o 20210119 -t mc -op SMS-T5qqqqZH_unsplit_ -ip SMS-T5qqqqZH_unsplit_

convert_dataset_files_to_cl.py SMS-T5qqqqZH_unsplit /net/cms24/cms24r0/pico ./20210119/cl_sig_dataset_files_2016.py -m 20210119 -i 20210119 -s dataset_year=2016 -if SMS-T5qqqqZH_unsplit_ -id filtered_
convert_dataset_files_to_cl.py SMS-T5qqqqZH_unsplit /net/cms24/cms24r0/pico ./20210119/cl_sig_dataset_files_2017.py -m 20210119 -i 20210119 -s dataset_year=2017 -if SMS-T5qqqqZH_unsplit_ -id filtered_
convert_dataset_files_to_cl.py SMS-T5qqqqZH_unsplit /net/cms24/cms24r0/pico ./20210119/cl_sig_dataset_files_2018.py -m 20210119 -i 20210119 -s dataset_year=2018 -if SMS-T5qqqqZH_unsplit_ -id filtered_
convert_cl_to_jobs_info.py ./20210119/cl_sig_dataset_files_2016.py ./20210119/sig_jobs_info_2016.json
convert_cl_to_jobs_info.py ./20210119/cl_sig_dataset_files_2017.py ./20210119/sig_jobs_info_2017.json
convert_cl_to_jobs_info.py ./20210119/cl_sig_dataset_files_2018.py ./20210119/sig_jobs_info_2018.json
auto_submit_jobs.py ./20210119/sig_jobs_info_2016.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20210119/sig_jobs_info_2017.json -n cms1 -c copy_aods_check_entries.py
auto_submit_jobs.py ./20210119/sig_jobs_info_2018.json -n cms1 -c copy_aods_check_entries.py
