from functools import lru_cache
from pathlib import Path
from tqdm import tqdm

def fibonacci(n):
    if n == 0 or n == 1:
        return 1
    return fibonacci(n-1) + fibonacci(n-2)

if __name__ == '__main__':
    Path("output").mkdir(parents=True, exist_ok=True) # Create output folder if it doesn't exist already

    # with open('output/01.txt', 'w') as f:
    with open('/storage1/fs1/chien-ju.ho/Active/01.txt', 'w') as f:
        print('The following output was computed using the Python script 01-python-script.py', file=f, flush=True)
        for i in tqdm(range(30)):
            result = fibonacci(i)
            print(f"Fibonacci({i}) = {result}", file=f, flush=True)
