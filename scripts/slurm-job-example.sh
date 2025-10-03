#!/bin/bash
#SBATCH --job-name=rnaseq_demo        # Job name
#SBATCH --account=ACCOUNT             # Replace with your project account
#SBATCH --partition=cpu               # Partition/queue
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8             # Number of CPU cores
#SBATCH --time=04:00:00               # Walltime (hh:mm:ss)
#SBATCH --mem=32G                     # Total memory
#SBATCH --output=out.%j               # Standard output (%j = jobID)
#SBATCH --error=err.%j                # Standard error
#SBATCH --mail-user=username@purdue.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# --- Environment setup ---
module --force purge
module load conda                     # load site-provided Conda module

# Enable conda in non-interactive shells
eval "$(conda shell.bash hook)"

# Activate your environment (installed under /depot/projectspace/...)
conda activate rnaseq-env

# --- Commands to run ---
# Example: QC + alignment + BAM conversion
fastqc my_reads.fastq
cutadapt -a AGATCGGAAGAGC -o trimmed.fastq my_reads.fastq
hisat2 -x reference_index -U trimmed.fastq -S aln.sam
samtools view -Sb aln.sam > aln.bam
multiqc .

# files can be edited directly on the cluster

# --- Post-job info ---
jobinfo $SLURM_JOB_ID
