#!/bin/bash
source $(dirname $(readlink -e "$BASH_SOURCE"))/modules/datasets/set_env.sh
source $(dirname $(readlink -e "$BASH_SOURCE"))/modules/jb_utils/set_env.sh
source $(dirname $(readlink -e "$BASH_SOURCE"))/modules/queue_system/set_env.sh

. /cvmfs/cms.cern.ch/cmsset_default.sh
cd /net/cms29/cms29r0/pico/CMSSW_10_2_11_patch1/src
eval `scramv1 runtime -sh`
cd -

voms-proxy-init -voms cms -valid 168:0

# Setup batch
export JOBBIN=/net/cms2/cms2r0/Job
export JOBS=/net/cms2/cms2r0/${USER}/jobs
export LOG=/net/cms2/cms2r0/${USER}/log
export PATH=$JOBBIN${PATH:+:${PATH}}
alias bsub='JobSubmit.csh'
alias bjobs='JobShow.csh'
alias bkill='JobKill.csh'
unset -f bkillall 
function bkillall {
  cat $JOBS/running.list | awk '{print $1}' | xargs -I {} JobKill.csh {}
  cat $JOBS/queued.list | awk '{print $1}' | xargs -I {} JobKill.csh {}
  cat $JOBS/ready.list | awk '{print $1}' | xargs -I {} JobKill.csh {}
}
unset -f blog
function blog {
  cat /net/cms2/cms2r0/jbkim/log/$1.log
}
alias bproc="tail -f /net/cms2/cms2r0/${USER}/log/JobProc.log"
