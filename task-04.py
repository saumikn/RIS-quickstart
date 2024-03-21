from functools import lru_cache
from pathlib import Path
from tqdm import tqdm

def fibonacci(n):
    if n == 0 or n == 1:
        return 1
    return fibonacci(n-1) + fibonacci(n-2)

if __name__ == '__main__':
    
    output_folder = "output"
    # output_folder = "/storage1/fs1/<faculty-key>/Active/quickstart/output"
    
    Path(output_folder).mkdir(parents=True, exist_ok=True) # Create output folder if it doesn't exist already

    with open(f'{output_folder}/task-04.txt', 'w') as f:
        print('The following output was computed using the Python script task-04.py', file=f, flush=True)
        for i in tqdm(range(30)):
            result = fibonacci(i)
            print(f"Fibonacci({i}) = {result}", file=f, flush=True)
