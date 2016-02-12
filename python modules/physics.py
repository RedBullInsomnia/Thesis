import bge
import time
import PhysicsConstraints
import socket
import sys

init_time = time.time()
bge.constraints.setNumIterations(120)
scene = bge.logic.getCurrentScene()

def report_physics(cont):
    scene = bge.logic.getCurrentScene()
    
    elapsed_time = time.time() - init_time