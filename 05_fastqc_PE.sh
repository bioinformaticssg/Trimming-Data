#!/bin/bash

#$ -N fastqc_PE             # name of the job
#$ -o /data/users/$USER/BioinformaticsSG/Trimming-Data/fastqc_PE.out   # contains what would normally be printed to stdout
#$ -e /data/users/$USER/BioinformaticsSG/Trimming-Data/fastqc_PE.err   # file name to print standard error messages to. 
#$ -q free64,som,asom       # request cores from the free64, som, asom queues.
#$ -pe openmp 8-64          # request parallel environment. You can include a minimum and maximum core count.
#$ -m beas                  # send you email of job status (b)egin, (e)rror, (a)bort, (s)uspend
#$ -ckpt blcr               # (c)heckpoint: writes a snapshot of a process to disk, (r)estarts the process after the checkpoint is c$

set -euxo pipefail

module load blcr
module load fastqc/0.11.7


DATA_DIR=/data/users/$USER/BioinformaticsSG/griffith_data/reads

DIR=/data/users/$USER/BioinformaticsSG/Trimming-Data
PE_DIR=${DIR}/paired_end_data

PE_DATA_QC=${PE_DIR}/PE_fastqc_result_files
PE_QC_HTML=${PE_DATA_QC}/PE_fastqc_result_files_html_only


mkdir -p ${PE_DIR}
mkdir -p ${PE_DATA_QC}
mkdir -p ${PE_QC_HTML}


# FastQC on paired end files. We are finding all files (-type f) using the program find.

for SAMPLE in `find ${DATA_DIR} -type f`; do
    fastqc ${SAMPLE} \
    --outdir ${PE_DATA_QC}

    # I am moving all the html files to a new directory
    mv ${PE_DATA_QC}/*.html ${PE_QC_HTML}
done

# I am compressing the directory containing all the html files into one file
tar -C ${PE_DATA_QC} -czvf ${PE_QC_HTML}.tar.gz ${PE_QC_HTML} 