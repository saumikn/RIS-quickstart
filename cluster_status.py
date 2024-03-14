import subprocess

cpus = subprocess.run(['bhosts', '-w', 'general'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
cpus = [i.split() for i in cpus][1:-1]
cpus = {i[0]:(i[1], int(i[3]), int(i[4])) for i in cpus}

jobs = subprocess.run(['bjobs', '-w', '-X', '-u', 'all'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
jobs = [i.split() for i in jobs][1:-1]
jobs = [i for i in jobs if i[2]=='RUN']
job2user = {i[0]:i[1] for i in jobs}

gpus = subprocess.run(['bhosts', '-gpu', '-l'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('HOST: ')
gpus = [i.split('\n') for i in gpus][1:]
gpus = [i for i in gpus if i[0] in cpus]
hosts = {i[0] for i in gpus}
host_gpu_info = []
jobids = []


print('--------------------Host Usage--------------------')
for gpu in gpus:
    host = gpu[0]
    for line in gpu:
        line = line.split()
        if len(line) == 3 and line[0].isnumeric():
            host_gpu_info.append((host, int(line[1]), int(line[2]), cpus[host][0], cpus[host][1], cpus[host][2]))
        if len(line) == 7 and line[0].isnumeric() and line[1]!='-':
            jobids.append((line[2], line[1]))
print('Exclusive/Shared GPUs Available:')
print('Host SharedAvail ExclusiveAvail Status CPUs InUse')
for a in host_gpu_info:
    if a[3]=='ok' and a[2] > 0: print(' '.join(str(i) for i in a))
print()

print('Only Shared GPUs Available:')
print('Host SharedAvail ExclusiveAvail Status CPUs InUse')
for a in host_gpu_info:
    if a[3]=='ok' and a[1]>0 and a[2]==0 : print(' '.join(str(i) for i in a))
print()

print('GPUs Unavailable:')
print('Host SharedAvail ExclusiveAvail Status CPUs InUse')
for a in host_gpu_info:
    if a[3]!='ok' or (a[2]==0 and a[1]==0): print(' '.join(str(i) for i in a))
print()


print('--------------------GPU Usage--------------------')
gpus_used = {}
for j,x in jobids:
    if j=='-':
        print('-')
        continue
    if j not in job2user:
        j = j.split(',')[0]
    if j not in job2user:
        continue
    if job2user[j] not in gpus_used:
        gpus_used[job2user[j]] = {'Exclusive':0, 'Shared':0}
    if x == 'Y':
        gpus_used[job2user[j]]['Exclusive'] +=1
    else:
        gpus_used[job2user[j]]['Shared'] +=1

for k,v in gpus_used.items():
    print(f'{k}: {v}')
print()

print('--------------------CPU Usage on GPU Hosts--------------------')
running = sum(cpus[i[0]][2] for i in gpus)
total = sum(cpus[i[0]][1] for i in gpus)
print(f'There are {running} CPUs in use, out of the {total} CPUs available on GPU Hosts.')
print('Top Users:')
cpus_used = {}
for i in jobs:
    job_cpus = [j.split('*') for j in i[5].split(':')]
    for c in job_cpus:
        if len(c) == 1:
            n = 1
            node = c[0]
        else:
            n = int(c[0])
            node = c[1]
        if node in hosts:
            if i[1] not in cpus_used:
                cpus_used[i[1]] = 0
            cpus_used[i[1]] += n
            
cpus_used = sorted(cpus_used.items(), key=lambda kv: kv[1], reverse=True)
for k,v in cpus_used[:5]:
    print(f'{k}: {v}')
    
print()
print('--------------------CPU Usage on General Queue Hosts--------------------')
total = sum(v[1] for k,v in cpus.items())
running = sum(v[2] for k,v in cpus.items())
print(f'There are {running} CPUs in use, out of the {total} CPUs available on all Hosts')
print('Top Users:')
cpus_used = {}
for i in jobs:
    job_cpus = [j.split('*') for j in i[5].split(':')]
    for c in job_cpus:
        if len(c) == 1:
            n = 1
            node = c[0]
        else:
            n = int(c[0])
            node = c[1]
        if node in cpus:
            if i[1] not in cpus_used:
                cpus_used[i[1]] = 0
            cpus_used[i[1]] += n
            
cpus_used = sorted(cpus_used.items(), key=lambda kv: kv[1], reverse=True)
for k,v in cpus_used[:5]:
    print(f'{k}: {v}')
