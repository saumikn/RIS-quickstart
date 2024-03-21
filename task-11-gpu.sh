# Adding comments before, since inline comments break the script

# We are running the script at ~/RIS-quickstart/task-11.py seven times, with arguments of 10 30 100 300 1000 3000 10000
# -n Number of CPUs
# -q Which queue
# -m Which host group
# -G Which job group
# -J Name of the job, used when you run bjobs
# -M How much memory does the job get
# -N Sends you an email when the job is done with a job summary
# -u Where to send the email to
# -o Where to write the job output to. Skip this if you just want the output sent to your email
# -R Specifies that the job must run on a node with a gpu and 4GB of memory. This should to be the same as the argument to -M
# -gpu Parameters for the GPU: how many, what type, and if we need exclusive access
# -g Used for fair share scheduling, to limit too many simultaneous jobs from running
# -a Which docker container to run inside. By default, rapidsai/rapidsai:21.10-cuda11.0-runtime-ubuntu20.04-py3.8 is reasonable, is exactly what Open OnDemand uses

# To run, we enter the RIS-quickstart folder and run task-11.py with the quickstart-env Conda environment and the SHAPE parameter



for SHAPE in 10 30 100 300 1000 3000 10000
do
bsub -n 1 \
-q general \
-m general \
-G compute-chien-ju.ho \
-J GPU_${SHAPE} \
-M 16GB \
-N \
-u saumik@wustl.edu \
-o /storage1/fs1/chien-ju.ho/Active/quickstart/job_output/GPU_${SHAPE}.%J.txt \
-R 'gpuhost rusage[mem=16GB] span[hosts=1]' \
-gpu "num=1:gmodel=TeslaV100_SXM2_32GB:j_exclusive=no" \
-g /saumik/limit100 \
-a "docker(rapidsai/rapidsai:21.10-cuda11.0-runtime-ubuntu20.04-py3.8)" \
"cd ~/RIS-quickstart && /storage1/fs1/chien-ju.ho/Active/.conda/envs/quickstart-env/bin/python task-11.py" ${SHAPE}
done