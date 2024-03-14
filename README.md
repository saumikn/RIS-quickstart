This repository contains all the information you need to get started running Python and Jupyter Lab on the CPUs and GPUs available on WashU's RIS Cluster

## Task 1: Getting Access

First, you will need to get access to the RIS Cluster. Each faculty gets 5TB of free storage on the RIS Storage Cluster and access to open CPUs and GPUs on the Compute Cluster. If you're a student, you will simply be assigned access to your advisor's resources. To request access, submit a ticket at https://ris.wustl.edu/support/service-desk/. This process will probably take a few days, and you'll need your advisor to oversee the process.

## Task 2: Using the Compute Environment

To access the RIS cluster, you will need to be on the WashU VPN. Instructions on how to do so can be found at https://it.wustl.edu/items/connect/.

Once you're on the VPN (and you have access to the compute cluster), you can SSH into the compute environment with the command `ssh <wustl-key>@compute1-client-<N>.ris.wustl.edu`, where `<key>` is your official WUSTL key, and `<N>` can be any number from 1 to 4 (e.g. `saumik@compute1-client-4.ris.wustl.edu`).

The only reason you needed to SSH into the compute environment was to set up your account for the first time. At this point, I will be recommending that most people use Open OnDemand to access their code, rather than SSH. If you want to use the terminal, skip ahead to Task 11.

## Task 3: Using Open OnDemand

Now that you have SSHed into your account, you have access to [OpenOnDemand](https://ood.ris.wustl.edu/). This is a platform managed by RIS which gives you access to Jupyter Lab, RStudio, Matlab, and other computational tools you might use. To get started, go to https://ood.ris.wustl.edu/.

To create a Jupyter Lab instance, click on the `Interactive Apps → Jupyter Notebook` button at the top of the page. Then, you should submit a form with the following parameters:

- `Mounts`: You should paste in the following text: `/scratch1/fs1/<faculty-id>:/scratch1/fs1/<faculty-id> /storage1/fs1/<faculty-id>/Active:/storage1/fs1/<faculty-id>/Active`. When getting access to RIS, you should have been told what your advisor's `<faculty-id>` is. Note that this is not necessarily the same as their WUSTL Key.
- `Job Group`: You can leave the default option as is, which should be something like `<wustl-key>/ood`
- `User Group`: You should select the dropdown option which has your advisor's `<faculty-key>`, which should be something like `compute-<faculty-key>`
- `Queue`: You should use `general`. `general-interactive` is also an option, but I haven't tested it with GPUs.
- `SLA Name`: Leave this empty unless your advisor tells you to put something here
- `Memory`: Request as much memory as you think you'll need. If you request too much memory which isn't available on the cluster, your job will be stuck in a pending state. `16GB` is a reasonable amount of memory to start with. If you find that your code keeps crashing due to lack of memory, you can increase this amount as needed.
- `Number of Hours`: How long your Jupyter Instance will run before being automatically killed by the server. You can request up to `672` hours (i.e. 28 days), but please don't just leave a job running if you're not making use of the resources, you're taking away the resources from somebody else.
- `GPUs to Allocate`: If your code makes use of GPUs, put `1` here. If your code doesn't use GPUs, put `0`. You could request up to `4` in this slot, but unless you are really smart with your code, you will probably not be able to make use of more than one GPU at a time.
- `GPU Model Type`: You should use `Tesla V100 (32GB SXM2)`. `NVIDIA A40` is potentially an option, but I haven't been able to get them to work personally.
- `Number of Processors`: This represents the number of CPUs assigned to your job. If your code doesn't make use of multiprocessing, you will not be able to make use of more than `1` or `2`. If you do make use of multiprocessing, you can put up to `40` here, but the higher the number, the longer it may take for your job to land.
- `Enable MPI`: Don't check this unless your code requires `MPI`
- `Use JupyterLab`: Click this, Jupyter Lab is a much nicer interface than Jupyter Notebook
- `Custom Jupyter Notebook Directory`: I leave this blank, you can change this if it's helpful for you.

Once you've selected all your parameters, go ahead and launch your notebook by clicking the `Launch` button. Afterwards, you'll be automatically taken to a new page with all of your running interactive sessions. If you leave this page, you can always get back to it by going to https://ood.ris.wustl.edu and clicking the `My Interactive Sessions` button at the top of the page.

Afterwards, you can open your Jupyter Lab environment by clicking the blue `Connect to Jupyter` button on your job, and you're in!

## Task 4: Run your first Python Script

Once you've connected, you'll be presented with the Jupyter Lab interface. If you've never used Jupyter Lab before, I'll give a quick intro and explain

Once you are inside Jupyter Lab, you should see the Launcher taking up most of the screen. You should also see a file explorer sidebar at the left showing all your files (which may be empty if you haven't used RIS before), and a few action buttons at the top left: A blue plus, which opens new Launchers, a New Folder button, an Upload Button, and a Refresh Button.

Now that you're a little familiar with the Jupyter Lab interface, it's time to start running code :).

1. Open a new terminal using the Launcher. At the prompt, you should see something like `(base) <wustl-key>@compute1-exec-216:~$`
2. Run the command `git clone git@github.com:saumikn/RIS-quickstart.git`. This will download all of the files needed for this tutorial, and save them into the `RIS-quickstart` directory (i.e. folder).
3. Enter into this directory in your terminal with the command `cd RIS-quickstart`
4. In your terminal, run the command `python 01-python-script.py`
5. Once you do this, you'll get a progress bar in your terminal that shows you the status of your code, which should take about a second to run. Afterwards, you can read the output of the code by opening the `RIS-quickstart` folder in the file browser, and then opening the `01-output.txt` file.

## Task 5: Run your first Jupyter Notebook

Running code in Jupyter is almost as easy.

1. First, you should open the `02-jupyter-notebook.ipynb` file, by double clicking on it in the file browser.
2. By default, the notebook will try to open in the `base` conda kernel. However, I'm currently encountering a bug and this kernel doesn't load. To fix this, you can click on the `base` or `No Kernel` button at the top left of the screen, and instead select the `Python 3` kernel. The choice of which kernel you use determines which Conda environment your code runs with. We'll explain more about this in the next step.
3. Then, you can run your code by clicking the `Run → Run All Cells` button in the menu options.
4. Once the code finishes running, you can view the output saved to `02-output.txt`.

## Task 6: Build your first Conda Environment

Both of these options worked easily and you were able to run the code which I've provided. However, these programs were very simple, and only required Python itself. Most interesting Data Science code you write will require additional packages such as `Pandas`, `Tensorflow`, or `Matplotlib`. These need to be downloaded and installed on your system first before you can use them. In order to manage these packages, and anything else you might need, we're going to use a tool called Conda. Using Conda, we can specifiy in an `environment.yml` file exactly which packages are required to run your code, making your code much more maintanable and replicable by others.

First, you need to run the following four commands. These commands are something specific to the RIS platform and allow you to save Conda environments directly to your storage cluster at `/storage1/fs1/` which has a capacity of at least 5TB, rather than your home directory which can only store 10GB. **You only need to run these commands a single time when you first set up RIS, not every time you create a new environment.**. You should edit the commands with your specific `<faculty-id>` and then run the commands one at a time in your terminal.

- `mkdir -p /storage1/fs1/<faculty-id>/Active/.conda/pkgs`
- `conda config --add pkgs_dirs /storage1/fs1/<faculty-id>/Active/.conda/pkgs`
- `mkdir -p /storage1/fs1/<faculty-id>/Active/.conda/envs`
- `conda config --add envs_dirs /storage1/fs1/<faculty-id>/Active/.conda/envs`
- `conda config --set env_prompt '({name})'`

Next, we're going to build a single environment which has already been predefined in the `environment.yml` file included in the `RIS-quickstart` folder. In order to do this, you must run the following commands.

1. First, you should take a look inside the `environment.yml` file just to understand how the file is structured.
   - `name` refers to the name of the environment, how Conda distinguishes it from other environments
   - `channels` tells Conda where to look to download from. Almost all code you will ever need is available in `conda-forge`, but you can specify a different channel here if you like.
   - `dependencies` defines which packages need to be installed from Conda. You can specify an version of a package with `=` (e.g. `python=3.10`) or with `<` or `>`. Otherwise, Conda will download the latest possible version
   - `pip` defines which packages need to be installed from Pip. You can specify a version of a package with `==` (e.g. `tensorflow==2.8`).
   - In general, if you can download a package from either Conda or Pip, you should choose Conda, unless you have a reason to choose Pip (either Conda somehow breaks things or the package itself recommends pip for some reason)
2. Next, run `mamba env create -f environment.yml -v`. This may take several minutes to run, as Conda will need to download a bunch of new Python packages totaling several GBs, and then install them into a new environment it's creating.
   - You could also run `conda env create -f environment.yml -v`, but using `mamba` is faster.
3. Once it's finished installing, you can enter the environment with `conda activate <env-name>` (e.g. `conda activate quickstart-env`)
4. The first time you create an environment, you will need to run the following two lines to make sure your terminal and Jupyter are properly set up to run code in this environment.
   - To set up Jupyter, run `python -m ipykernel install --user --name <env-name> --env LD_LIBRARY_PATH $CONDA_PREFIX/lib`
   - To set up your terminal, run `conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib`. When you do this, it will probably ask you to reactivate your environment with `conda activate <env-name>`, and you should do this

## Task 7: Run a Python Script in your Conda Environment

Running a Python script in your custom Conda Environment is just as easy as running it in the base environment (Step 5). All you need to do ensure that your terminal is currently activated with the intended environment. You can tell which environment you're in based on the terminal prompt. If the prompt starts with `(conda)` or `(base)`, it means you're in the `base` enviornment that ships with Conda, which contains almost no packages outside of Python itself. If the prompt starts with anything else (e.g. `(quickstart-env)`), it means you're in the environment with that name. If you want to switch to a new environment, just use the `conda activate <env-name>` command.

Once you're in the `quickstart-env` environment that you just built, run the Python script I've written with `python 03-python-script.py`. (TODO)

What happens if you try running this script in the base environment? Go ahead and try it by running `conda activate base` and `python 03-python-script.py`.

## Task 8: Run a Jupyter Notebook in your Conda Environment

Running a Jupyter Notebook in your custom Conda Environment is also easy. Once you've opened a notebook, you can use the `Kernel → Change Kernel` option in the menu at the top to select which Conda environment you want to run your code with. You can always check which environemnt you're currently using with the button at the top right.

You can test this out by opening the `python 04-jupyter-notebook.py` file in Jupyter. the Once you've selected the `quickstart-env` kernel, run the entire notebook with `Run → Run All Cells`. (TODO)

## Task 9: Update your Conda Environment with new Packages

If you've already created your environment and you want to add new packages, the easiest option is to simply edit your `environment.yml` file, and then run `mamba env update --f environment.yml -v --prune`. (You could also use `conda` instead of `mamba`, but `mamba` is faster). If you're able to update your code successfully, you're done!

Occassionally, using this approach will give you an error, due to conflicting environment setups. If this happens, you should just delete your current environment and recreate it from scratch. To do this, run the following steps:

1. If you're currently in the environment you want to delete, run `conda deactivate`
2. Delete the environment with `conda remove --name <env-name> --all` and then `jupyter kernelspec uninstall <env-name>`
3. Recreate the new environment with the steps listed above

## Task 10: Test your Skills with Conda!

I've created a Jupyter Notebook file called `05-jupyter-notebook.ipynb`. Your task is to modify your `environment.yml` to build an environment which can run the `05-jupyter-notebook.ipynb` file without any errors. In addition, you should try to make your `environment.yml` file as small and self-contained as possible. You should try to only list Python packages that you explicitly need in your code, and remove all dependencies which aren't necessary for your code! (TODO)

## Task 11: Submitting Python Jobs to the Cluster

(TODO)

## Task 11: Using Docker instead of Open OnDemand

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
12. Launch a new Jupyter Lab instance by running the script `bash jupyter-gpu.sh` with whatever parameters you want to customize.
    - For example, if you want to launch a job with 100GB of memory, a time limit of 24 hours, and 8 CPUs, you would use `bash jupyter-gpu.sh -m 100GB -t 24 -c 8`
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
