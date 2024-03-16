from pathlib import Path
import sys
import time
import torch

if __name__ == '__main__':
    
    shape = int(sys.argv[1])
    
    print(f"Shape: {shape}")
    
    output_folder = "/storage1/fs1/chien-ju.ho/Active/quickstart/processed_data/"
    if torch.cuda.is_available():
        output_folder = f"{output_folder}/gpu/"
        device = torch.device('cuda')
    else:
        output_folder = f"{output_folder}/cpu"
        device = torch.device('cpu')

    print(f"Using Device: {device}")

    start_time = time.perf_counter()
    x = torch.rand(shape, shape, device=device, dtype=torch.float32)
    res = 0
    for _ in range(100):
        res = res + (x**5 + 12) # Random matrix operations
    end_time = time.perf_counter()
    time_taken = end_time - start_time
    
    print(f"Function Runtime: {time_taken:.4f} seconds")
    
    
    Path(output_folder).mkdir(parents=True, exist_ok=True)
    torch.save(x, f"{output_folder}/{shape}.pt")

        