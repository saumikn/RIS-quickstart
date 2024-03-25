This repository contains all the information you need to get started running Python and Jupyter Lab on the CPUs and GPUs available on WashU's RIS Cluster

## Task 1: Getting Access

First, you will need to get access to the RIS Cluster. Each faculty gets 5TB of free storage on the RIS Storage Cluster and access to open CPUs and GPUs on the Compute Cluster. If you're a student, you will simply be assigned access to your advisor's resources. To request access, submit a ticket at https://ris.wustl.edu/support/service-desk/. This process will probably take a few days, and you'll need your advisor to oversee the process.

## Task 2: Using the Compute Environment

To access the RIS cluster, you will need to perform the following steps.

1. If you are off-campus, you will need to be on the WashU VPN. Instructions on how to do so can be found at https://it.wustl.edu/items/connect/.
2. You should open a terminal on your computer, and SSH into the compute environment with the command `ssh <wustl-key>@compute1-client-<N>.ris.wustl.edu` where `<key>` is your official WUSTL key, and `<N>` can be any number from 1 to 4
   - e.g. `saumik@compute1-client-4.ris.wustl.edu`
   - It should be noted that despite being called `compute1`, this is a "login" node, not a "compute" node. This means that you should not run any complicated code, you should instead use a "compute" node to run your code, using the steps either in Task 3, Task 11, or Task 12.

The only reason you needed to SSH into the compute environment was to set up your account for the first time. At this point, I will be recommending that most people use Open OnDemand to access their code, rather than SSH. If you want to use the terminal, skip ahead to Task 11.

## Task 3: Using Open OnDemand

Now that you have SSHed into your account, you have access to [OpenOnDemand](https://ood.ris.wustl.edu/). This is a platform managed by RIS which gives you access to Jupyter Lab, RStudio, Matlab, and other computational tools you might use. To get started, do the following steps.

1. Go to https://ood.ris.wustl.edu/
2. To create a Jupyter Lab instance, click on the `Interactive Apps → Jupyter Notebook` button at the top of the page.
3. On the resulting page, fill out the following parameters:
   - `Mounts`: You should paste in the following text: `/scratch1/fs1/<faculty-id>:/scratch1/fs1/<faculty-id> /storage1/fs1/<faculty-id>/Active:/storage1/fs1/<faculty-id>/Active`.
     - When you first got access to RIS, you should have been told what your advisor's `<faculty-id>` is. This is not necessarily the same as their WUSTL Key.
     - If you are using the ArtSci compute conda instead of a faculty's storage, you might not have access to `/scratch1`. Instead, you should probably use this as your input: `/storage1/fs1/artsci/Active/<wustl-key>:/storage1/fs1/artsci/Active/<wustl-key>`
   - `Job Group`: You can leave the default option as is, which should be something like `<wustl-key>/ood`
   - `User Group`: You should select the dropdown option which has your advisor's `<faculty-key>`, which should be something like `compute-<faculty-key>`
   - `Queue`: You should use `general`. `general-interactive` is also an option, but I haven't tested it with GPUs.
   - `SLA Name`: Leave this empty unless your advisor tells you to put something here
   - `Memory`: Request as much memory as you think you'll need. If you request too much memory which isn't available on the cluster, your job will be stuck in a pending state. `16GB` is a reasonable amount of memory to start with. If you find that your code keeps crashing due to lack of memory, you can increase this amount as needed.
   - `Number of Hours`: How long your Jupyter Instance will run before being automatically killed by the server. You can request up to `672` hours (i.e. 28 days), but please don't just leave a job running if you're not making use of the resources, you're taking away the resources from somebody else.
   - `GPUs to Allocate`: If your code makes use of GPUs, put `1` here. If your code doesn't use GPUs, put `0`. You could request up to `4` in this slot, but unless you are really smart with your code, you will probably not be able to make use of more than one GPU at a time.
   - `GPU Model Type`: You should use `Tesla V100 (32GB SXM2)`. `NVIDIA A40` is potentially an option, but I have not tested this myself.
   - `Number of Processors`: This represents the number of CPUs assigned to your job. If your code doesn't make use of multiprocessing, you will not be able to make use of more than `1` or `2`. If you do make use of multiprocessing, you can put up to `32` here, but the higher the number, the longer it may take for your job to land.
   - `Enable MPI`: Don't check this unless your code requires `MPI`
   - `Use JupyterLab`: Click this, Jupyter Lab is a much nicer interface than Jupyter Notebook
   - `Custom Jupyter Notebook Directory`: I leave this blank, you can change this if it's helpful for you.
4. Once you've selected all your parameters, go ahead and launch your notebook by clicking the `Launch` button. This will take you to a new page with all your running sessions
5. At first, your session will have a grey background and say "Queued". If you didn't request too much RAM or GPUs or CPUs, your job should land within a minute or two
6. Once your job lands, it will have a blue background and say "Pending". You will have to continue waiting for a few minutes while your environment sets up.
7. Once your job finishes seting up, it will have a green background and be ready! You can open the environment by clicking on the blue `Connect to Jupyter` button on your job
   - If you leave this page, you can always get back to it by going to https://ood.ris.wustl.edu and clicking the `My Interactive Sessions` button at the top of the page.

### Helpful commands if your job is stuck or exiting early

If your job is stuck without landing, or your job lands and immediatly deletes itself, here are some commands you can try.

1. SSH into the login node with `ssh <wustl-key>@compute1-client-<N>.ris.wustl.edu`
2. Use `bjobs -wa` to show all of your current and recent jobs
3. If your job hasn't landed yet (still grey), then run `bjobs -l <job-id>`, which will give you a reason for why your job hasn't landed yet
4. If your job has landed but is still blue after more than 10-15 minutes of waiting, then you can run `bpeek <job-id>` to view the current status of the job.
5. If your job exits right away, your job is crashing for some reason. You should run `cd ondemand/data/sys/dashboard/batch_connect/sys/jupyter/output/`, use `ls -lh` to find the most recently created folder, and `cd` into that folder. You can then view the output with `cat output.log` (or use `less output.log` if your file is really long. Exit `less` by typing in the letter `q`)
   - One common scenario why jobs might crash immediatly is because storage1 is not set up correctly. If you try leaving the `Mounts` parameter empty and your new job doesn't crash, it means your RIS Storage hasn't been set up. Submit a ticket on RIS

## Task 4: Run your first Python Script

Once you've connected, you'll be presented with the Jupyter Lab interface. If you've never used Jupyter Lab before, here's a quick intro:

At first, you should see the Launcher taking up most of the screen. You should also see a file explorer sidebar at the left showing all your files (which may be empty if you haven't used RIS before), and a few action buttons at the top left: A blue plus, which opens new Launchers, a New Folder button, an Upload Button, and a Refresh Button.

Now that you're a little familiar with the Jupyter Lab interface, it's time to start running code.

1. Open a new terminal using the Launcher. At the prompt, you should see something like `<wustl-key>@compute1-exec-216:~$`
2. Run the command `git clone https://github.com/saumikn/RIS-quickstart.git`. This will download all of the files needed for this tutorial, and save them into the `RIS-quickstart` directory (i.e. folder).
3. Enter into this directory in your terminal with the command `cd RIS-quickstart`
4. Load the base Conda environment with `conda activate base`.
   - I will explain how Conda works in Task 6 - just go with it for now :)
   - Once you do this, your prompt should say something like `(base) <wustl-key>@compute1-exec-216:~/RIS-quickstart$`
5. Open up the `task-04.py` Python file by navigating to `RIS-quickstart` in the file browser, and double clicking on the file name
   - Nothing specific for you to do here, just good practice to look at what you're running before you run it
   - In this case, you should see that this script is simply computing the first 30 Fibonacci numbers
6. Back in your terminal, run the command `python task-04.py`
7. Once you do this, you'll get a progress bar in your terminal that shows you the status of your code, which should take about a second to run.
8. Afterwards, you can read the output of the code by opening the `RIS-quickstart` directory in the file browser, and then opening the `01-output.txt` file.
9. Because this output is so small, it's fine to save the output in the home directory (i.e. anywhere inside the `~` directory). If this output was expected to be very large, it would be better to save the output in RIS Storage. To do this, comment out line 12 and uncomment line 13. Then, rerun the script.
10. You can't open files saved in RIS Storage directly, but you can use the terminal to view the files. For example, you can do this with the command `cat /storage1/fs1/<faculty-key>/Active/01.txt`

## Task 5: Run your first Jupyter Notebook

Running code in Jupyter is almost as easy.

1. First, you should open the `task-05.ipynb` file, by double clicking on it in the file browser.
2. By default, the notebook will try to open in the `base` conda kernel. However, I'm currently encountering a bug and this kernel doesn't load. To fix this, you can click on the `base` or `No Kernel` button at the top left of the screen, and instead select the `Python 3` kernel. The choice of which kernel you use determines which Conda environment your code runs with. We'll explain more about this in the next step.
3. Then, you can run your code by clicking the `Run → Run All Cells` button in the menu options.
4. Once the code finishes running, you can view the output saved to `02-output.txt`.
5. You can instead edit the code to save output file in RIS Storage instead of your home directory.

## Task 6: Build your first Conda Environment

Both of these options worked easily and you were able to run the code which I've provided. However, these programs were very simple, and only required Python itself. Most interesting Data Science code you write will require additional packages such as `Pandas`, `Tensorflow`, or `Matplotlib`. These need to be downloaded and installed on your system first before you can use them. In order to manage these packages, and anything else you might need, we're going to use a tool called Conda. Using Conda, we can specifiy in an `environment.yml` file exactly which packages are required to run your code, making your code much more maintanable and replicable by others.

### Commands to set up Conda on RIS (only have to do once ever)

First, you need to run the following five commands. These commands are something specific to the RIS platform and allow you to save Conda environments directly to your storage cluster at `/storage1/fs1/` which has a capacity of at least 5TB, rather than your home directory which can only store 10GB. **You only need to run these commands a single time when you first set up RIS, not every time you create a new environment.** You should edit the commands with your specific `<faculty-id>` and then run the commands one at a time in your terminal.

1. `mkdir -p /storage1/fs1/<faculty-id>/Active/.conda/pkgs`
2. `conda config --add pkgs_dirs /storage1/fs1/<faculty-id>/Active/.conda/pkgs`
3. `mkdir -p /storage1/fs1/<faculty-id>/Active/.conda/envs`
4. `conda config --add envs_dirs /storage1/fs1/<faculty-id>/Active/.conda/envs`
5. `conda config --set env_prompt '({name})'`
   - Use this last command exactly, you shouldn't replace `{name}` with anything else

### Commands to create a new Conda Environment (must repeat for every new Conda Environment you want to create)

Next, we're going to build a single environment which has already been predefined in the `environment.yml` file included in the `RIS-quickstart` directory. In order to do this, you must run the following commands.

1. First, you should open the `environment.yml` file just to understand how the file is structured.
   - `name` refers to the name of the environment, how Conda distinguishes it from other environments
   - `channels` tells Conda where to look to download from. Almost all code you will ever need is available in `conda-forge`, but you can specify a different channel here if you like.
   - `dependencies` defines which packages need to be installed from Conda. You can specify an version of a package with `=` (e.g. `python=3.10`) or with `<` or `>`. Otherwise, Conda will download the latest possible version
   - `pip` defines which packages need to be installed from Pip. You can specify a version of a package with `==` (e.g. `chess==1.9.4`).
   - In general, if you can download a package from either Conda or Pip, you should choose Conda, unless you have a reason to choose Pip (either Conda somehow breaks things or the package itself recommends pip for some reason)
2. Next, run `mamba env create -f environment.yml -v`. This will take around 10 minutes to run, as Conda will need to download a bunch of new Python packages totaling several GBs, and then install them into a new environment it's creating.
   - You could also run `conda env create -f environment.yml -v`, which will give you the same thing in the end, but `mamba` is significantly faster than `conda`.
3. Once it's finished installing, you can enter the environment with `conda activate <env-name>`, filling in `<env-name>`
   - e.g. `conda activate quickstart-env`
4. To set up Jupyter, run `python -m ipykernel install --user --name <env-name> --env LD_LIBRARY_PATH $CONDA_PREFIX/lib`, filling in `<env-name>`
   - e.g. `python -m ipykernel install --user --name quickstart-env --env LD_LIBRARY_PATH $CONDA_PREFIX/lib`
5. To set up your terminal, run `conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib`.
   - When you do this, it will probably ask you to reactivate your environment with `conda activate <env-name>`, and you should do this as well

## Task 7: Run a Python Script in your Conda Environment

Running a Python script in your custom Conda Environment is just as easy as running it in the base environment (Step 5). All you need to do ensure that your terminal is currently activated with the intended environment. You can tell which environment you're in based on the terminal prompt. If the prompt starts with `(conda)` or `(base)`, it means you're in the `base` enviornment that ships with Conda, which contains almost no packages outside of Python itself. If the prompt starts with anything else (e.g. `(quickstart-env)`), it means you're in the environment with that name. If your prompt does not contain anything like this, you are not in a Conda environment.

To run a script, run the following commands:

1. Enter your Conda environment with `conda activate <env-name>`, filling in `<env-name>`
   - e.g. `conda activate quickstart-env`
   - You will get a WARNING that you are overwriting environment variables set in the machine. You can ignore this, as we explicitly set up this behavior earlier when we ran the `conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib` command in the last step
   - Once you do this, your prompt should say something like `(quickstart-env) <wustl-key>@compute1-exec-216:~/RIS-quickstart$ `
2. Run the Python script with `python task-07.py`

What happens if you try running this script in the base environment? Go ahead and try it by running `conda activate base` and `python task-07.py`.

## Task 8: Run a Jupyter Notebook in your Conda Environment

Running a Jupyter Notebook in your custom Conda Environment is also easy.

1. Open the `task-08.py` notebook by double clicking on the file inside of the `RIS-quickstart` directory in the file explorer
2. By default, Jupyter may open your notebook in the base environment instead of your custom environment. You can check which environment you're in with the button at the top right, which will either say `quickstart-env` or `base` or `Python 3`.
3. Switch to the `quickstart-env` envrionment by clicking on the button at the top right, and selecting `quickstart-env` in the dropdown
   - When you first select an environment, you will see a grey circle with a lightning bolt in the center. This means your environment is loading, and you can't run anything yet
   - Once your environment finishes loading, the symbol will turn into a white circle instead. Whenever you see a white circle, this means your environment is ready to run code
   - If your notebook is in the middle of running code, this symbol will be a grey circle
4. You can run the entire notebook by clicking on the `Run → Run All Cells` button.
   - You can also run cells one at a time by either clicking on the grey triangle in the toolbar, or using the `Shift+Enter` keyboard shortcut. These will run whichever cell you have selected, highlighted with a blue bar

## Task 9: Update your Conda Environment with new Packages

If you've already built a Conda environment and need to add additional dependencies to your project, you have two options.

### Update the existing environment

The easiest option is to just edit your enviroment with the following commands

1. Edit your `environment.yml` file with your intended changes
2. Run `mamba env update --f environment.yml -v --prune`
   - You can also use `conda` instead of `mamba`, and both will give you the same thing in the end, but `mamba` is faster

### Delete the environment and recreate

Occassionally, the above approach will give you an error, for whatever reason. If this happens, the next easiest option is to delete your current environment and recreate it from scratch. To do this, run the following steps:

1. Enter the environment you want to delete with `conda activate <env-name>`, filling in `<env-name>`
   - e.g. `conda activate quickstart-env`
2. Unlink the environment from Jupyter with `jupyter kernelspec uninstall <env-name>`, filling in `<env-name>`
   - e.g. `jupyter kernelspec uninstall quickstart-env`
   - This step essentially undoes the command entered earlier in Task 6 of `python -m ipykernel install --user --name <env-name> --env LD_LIBRARY_PATH $CONDA_PREFIX/lib`
3. Deactivate the environment you want to delete with `conda deactivate`
4. Delete the environment you want to delete with `conda remove --name <env-name> --all`, filling in `<env-name>`
   - e.g. `conda remove --name quickstart-env --all`
5. Recreate the new environment by following all of the steps in Task 6, in the section on "Commands to create a new Conda Environment"

## Task 10: Test your Skills with Conda!

I've created a Jupyter Notebook file called `task-10.ipynb`. Your task is to create a new Conda environment which can run the `task-10.ipynb` file without any errors. In addition, you should try to make your environment file as small and self-contained as possible. You should try to only list Python packages that you explicitly need in your code, and remove all dependencies which aren't necessary for your code!

For this exercise, you should practice updating your existing `environment.yml` files using the steps listed in Task 9. However, it should be noted that in general it is better practice to have entirely different `environment.yml` for each seperate projects (each located in seperate directories), rather than a single Conda environment which can run multiple projects. Otherwise, you wouldn't be able to run e.g. `task-08.ipynb` and `task-10.ipynb` at the same time, since both require mostly different dependencies, and sharing your work becomes more difficult.

## Task 11: Submitting Python Jobs to the Cluster

Sometimes, you will want to run the same Python script with many different parameters. You could do this inside Jupyter Lab, but this could get cumbersome if you have hundreds or thousands of parameters you want to run. Instead, we can submit this Python script as a seperate _job_ on the RIS cluster. This will allow us to easily manage multiple parameters, and allow us potentially use more resources, simultaneously, allowing us to finish running our code faster

As an example, we will demonstrate how to submit the `task-11.py` script as seperate jobs, so we can run run the code simultanously, with different parameters. If you take a look inside the `task-11.py` file, you will see that this script takes in a single parameter, `shape`, creates a random matrix in Pytorch with that shape, loads the matrix on either the CPU or GPU depending on availability, performs a number of matrix operations on it, saves the matrix to our RIS Storage, and prints the runtime.

Here are the steps for how to submit `task-11.py` as jobs.

1. Open the `task-11.py` script and edit the script to point to the correct RIS Storage path
   - Takes in a single parameter, `shape`
   - Creates a random matrix in Pytorch with that shape
   - Loads the matrix on either the CPU or GPU depending on availability
   - Performs 100 matrix operations on it
   - Times how long the operations takes
   - Saves the matrix to our RIS storage (make sure to edit the `output_folder` parameter)
2. Open the `task-11-gpu.sh` file, and edit the parameters to point to the correct RIS Storage path and use your correct `<wustl-key>`
   - You should also read the comments to understand what each of the other parameters represent
3. Run `mkdir -p /storage1/fs1/<faculty-id>/Active/quickstart/job_output`, as the `-o` parameter in `task-11-gpu.sh` requires this directory to exist.
4. Run `bgadd -L 100 /<wustl-key>/limit100`. This will create a new fair share allocation group for you so you can run up to 100 jobs simultaneously.
   - Don't misuse this, or RIS can remove your access to the Compute Cluster
5. In your terminal, run the command `unset LSF_DOCKER_PORTS`. Otherwise, you will not be able to submit the jobs.
6. Finally, you can submit the jobs with `bash task-11-gpu.sh`
   - Random note, submitting these jobs may create a file in your `RIS-quickstart` directory called `lib_check`, containing the ominous sounding text `Die will Fire...`. I don't know what this file does, or what it means, but I don't think it's a problem.
7. While your jobs are running, you can use the command `bjobs -w | sort` to view all the jobs you've created, and their status (if it's pending or running)
8. Once your job is running, you can view the current output with `bpeek <job-id>`. This command will not work once your job finishes
9. When your jobs finish, you will get an email with a summary of your job and some statistics.
10. To view the output of your jobs, enter the job output directory with `cd /storage1/fs1/<faculty-id>/Active/quickstart/job_output`. You can then see the names of all the files in this directory with the `ls -lh` command. You can then view a specific job's output with the command `cat <file-name>`
11. We can then view the data created by these commands by going to `cd /storage1/fs1/<faculty-id>/Active/quickstart/data_processed/gpu` and typing in `ls -lh`. The actual data is not in a human-readable format, but you can at least see how large each file is.
    - What do you notice about the file sizes?
12. Next, we can try doing the same process, but submitting our code as CPU-only rather than running our code on a GPU. First, open the `task-11-cpu.sh` file, and edit the parameters as needed
13. Then, run the script with `bash task-11-cpu.sh` (making sure to go back to the `RIS-quickstart` directory first with `cd ~/RIS-quickstart`)
14. Once the jobs are done, you can view the data output at `/storage1/fs1/<faculty-id>/Active/quickstart/data_processed/cpu`
    - Are the file sizes different with the gpu-created files? Why or why not?
15. You can also view the job outputs at `/storage1/fs1/<faculty-id>/Active/quickstart/job_output`
    - What do you notice about the runtimes for each file?
    - Hint, try running `ls -v * | xargs -I{} grep -H "Function Runtime" {} | awk -F: '{printf "%-25s %s\n", $1":", $2":"$3}'`

## Task 12: Using Docker instead of Open OnDemand

At times, you may encounter a scenario where Open OnDemand doesn't work for your code. Maybe you need a different operating system instead of Ubuntu, or you need additional terminal commands such as `sudo`, or you need additional features in Jupyter such as Tensorboard or the NVIDIA GPU Dashboards. If any of these is true, you won't be able to use Open OnDemand, you'll have to build your own Docker image and run code for that.

In this section, I'm going to be a little more brief with my instructions, and I'm assuming that anybody that needs to build a Docker container is already proficient with the command line. As always, if you have any questions, you should consult the RIS Documentation or submit a ticket with the RIS Service Desk.

1. Create an account on [Docker Hub](hub.docker.com)
2. Create a new public repository on Docker Hub, named `<container-name>`
3. Download the Docker Desktop app on your personal computer and sign into your account
4. Download the `Dockerfile` and `docker-environment.yml` files from this Github repo onto your personal computer
5. Customize the `Dockerfile` with whatever requirmenets you need for your setup. The file I've provided is the simplest possible `Dockerfile` which will work on the RIS Cluster, but you can make any additional changes you need.
6. If you want, you can customize the `docker-environment.yml` with additional packages. In general, I would try to keep this environment as minimal as possible, and use the approach described in Task 6 to define custom conda environments for each project. If you need to install additional Jupyter extensions, you will need to do it here, rather than in your project-specific environment configs.
7. Build your Docker container with `docker build -t <docker-id>/<container-name>:<optional-tag>`, where `<docker-id>` is your username on Docker Hub, and `<container-name>` is the name of the public repository you created. Each repository can store multiple versions of a container, and each of these are distinguished by their `<tag>`.
8. Push your Docker container to Docker Hub with `docker push <docker-id>/<container-name>:<optional-tag>`. Depending on the size of your container, this could take anywhere from several minutes to several hours.
9. Log into the compute cluster with `ssh <wustl-key>@compute1-client-<N>.ris.wustl.edu`
   - This will bring you to one of the RIS login nodes. This is essentially a server where you can launch and view jobs which run your code. However, the login node isn't intended as a computer to run intensive code directly, so you'll have to learn how to submit jobs.
10. Download the `jupyter-gpu.sh` file from this Github repo
    - If you don't need to request a Jupyter Lab instance with a GPU, use `jupyter-cpu.sh` instead
11. Edit the `jupyter-gpu.sh` command to refer to your advisor's `<faculty-id>`
12. Launch a new Jupyter Lab instance by running the script `bash RIS-quickstart/jupyter-gpu.sh` with whatever parameters you want to customize.
    - For example, if you want to launch a job with 100GB of memory, a time limit of 24 hours, and 8 CPUs, you would use `bash RIS-quickstart/jupyter-gpu.sh -m 100GB -t 24 -c 8`
    - If you don't need a GPU, you would use `bash RIS-quickstart/jupyter-cpu.sh -m 100GB -t 24 -c 8`
13. In order to check if your job has landed, use the `bjobs -w` command. Once your job lands, the job status will change from `PEND` to `RUN`
    - If your job is taking a really long time to land, you can use the `bjobs -l <job-id>` command to get a detailed description of your job, including the reason why it hasn't landed yet
    - I created a script called `cluster_status.py`, which allows you to view status of the cluster. You can run ith with `python3 cluster_status.py` (on the login nodes, Python 2 is still the default even though it's 2024). This script is very helpful to see how occupied the cluster is, and can tell you potentially why your jobs aren't landing, if there are open GPUs or CPUs, etc.
14. Once your job has landed, use the `bpeek <job-id>` command to view your Jupyter Notebook url, which will look something like `http://compute1-exec-207.ris.wustl.edu:8401/lab?token=<token>`
    - If your job output is too long, you can use `bpeek <job-id> | grep http` as a shorthand to find the url
    - There are a bunch of additional compute cluster commands which mostly all start with the letter b, and many of them are useful. You can read more about them at https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=started-quick-reference
15. Finally, you can access your Jupyter Lab instance by going to the given URL.
    - In order to access this url, you need to be on the WashU VPN - even if you're on campus and connected to WashU's network
    - The first time you access the instance, you will need to copy paste the entire URL, including the token.
    - Afterwards, you can drop the token, and just enter the shortened url (e.g. `http://compute1-exec-207.ris.wustl.edu:8401/lab`)

Now you're in! Until your job dies, you can continue to access this url to get to Jupyter. You can now continue with Tasks 4 through 11.
