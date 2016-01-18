import bge
import time
import PhysicsConstraints
import os
import mathutils

# Initialization
init_time = time.time()
bge.constraints.setNumIterations(120)
scene = bge.logic.getCurrentScene()

go = True
index = 0
time_order = 0.0
torques = dict()
tokens = list()
last_line = False
last_time = 0.0
oldAngVel = dict()
for object in scene.objects:
    vec = mathutils.Vector((0.0,0.0,0.0))
    vec.freeze()
    entry={(object.name, vec)}
    oldAngVel.update(entry)

# Path to the file containing the orders
full_path = os.path.join('C:\\', 'Users', 'Hwk', 'Google Drive', 'Thesis', 'Assets', 'orders.txt')

# Load the textfile containing the orders into a buffer
# TO DO : do it in smaller chunks, and read the file when
# needed, to keep memory usage reasonable
orders = open(full_path, "r")
lines = orders.readlines()
orders.close()

########################
#      Main loop       #
########################
def report_physics(cont):
    global go, index, time_order, tokens, torques, last_line
    global last_time, oldAngVel

    # Timekeeping
    current_time = time.time() - init_time
    timestep = current_time - last_time
    last_time = current_time

    # Grouping the strings together for one big 'print'
    msg = "Time " + str(current_time) + " dT " + str(timestep) + "\n"

    # Parsing the orders from the buffer
    if True == go and index < len(lines):
        line = lines[index].strip()
        tokens = line.split(" ")
        index += 1
        go = False
        time_order = float(tokens[0])

    # Can we parse the new order yet ? Or is the file ended ?
    if time_order <= current_time and last_line == False:
        # The new order can be parsed from the buffer !
        go = True
        msg += "New order at time: " + str(time_order)
        for token in tokens[1:]:
            order = token.split(':')
            entry = {(order[0], float(order[1]))}
            torques.update(entry)
        if index == len(lines):
            last = True

    # Applying torques to the objects that have orders for them
    for key in torques:
        scene.objects[key].applyTorque((torques[key],0,0), True)
        msg += key + " :" + str(torques[key]) + "\n"

    # Computing center of gravity and reporting it
    # Also, computing angular accelerations
    center_of_gravity = mathutils.Vector((0,0,0))
    mass = 0.0
    for object in scene.objects:
        if object.name != "Hemi" and object.name != "Plane" and object.name != "Empty" and object.name != "Camera":
            # First, center of gravity
            mass_total = mass + object.mass
            center_of_gravity = (mass*center_of_gravity + object.mass*object.worldPosition) / mass_total
            mass = mass_total

            # Now, angular accelerations
            if timestep > 0:
                objectAngVel = object.getAngularVelocity(True)
                angAccel = (objectAngVel- oldAngVel[object.name])/timestep
                objectAngVel.freeze()
                entry = {(object.name, objectAngVel)}
                oldAngVel.update(entry)
                msg += str(object.name) + " Ang accel: " + str(angAccel) + "\n"

    msg += "Center of gravity: " + str(center_of_gravity)

    print(msg, flush = True)
