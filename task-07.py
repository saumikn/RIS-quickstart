print('Importing Numpy')
import numpy as np


print('First 100 Square Numbers:')
squares = (np.arange(100)+1)**2
print(squares)
print()


#########################

print('Importing Chess')
import chess

print('Starting Chess Position:')
board = chess.Board()
print(board)
moves = [i.uci() for i in board.legal_moves]
print('Legal Moves in the Starting Chess Position:')
print(moves)
print()


#########################

print('Importing Torch')
import torch


print('Torch GPU Status:')
print(torch.cuda.get_device_name(torch.cuda.current_device()) if torch.cuda.is_available() else "No GPU")
print()

#########################

print('Importing Tensorflow')
import tensorflow as tf

print('Tensorflow GPU Status:')
print(tf.config.list_physical_devices('GPU'))

#########################

