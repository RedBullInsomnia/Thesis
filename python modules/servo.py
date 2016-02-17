import bge
import time
import PhysicsConstraints
import socket
import sys
import math

init_time = time.time()
last_time = 0.0
desired_angle = 0.0
Kp = -2200
Ki = -1600
Kd = -600

<<<<<<< HEAD
angles = dict()
angles["Cube.001"] = 0.0
angles["Cube.004"] = 0.5
=======
desired_angle = 0.0
old_desired_angle = 0.0
goal_angle = 0.0
>>>>>>> 8866afd... Tried to apply servo control to the full robot, didn't work so well

data = dict()

TCP_IP ="127.0.0.1"
TCP_PORT = 80

#client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#client_socket.connect((TCP_IP,TCP_PORT))

#print("Connected to Matlab")
#time.sleep(0.1)

<<<<<<< HEAD
# Send params to Matlab

try:
    msg_a = ("%f \r %f \r %f \r %f \r") %(desired_angle, Kp, Ki, Kd)
    client_socket.send(msg_a.encode())
except socket.erorr:
    print("Failed to send params")
=======
## Send params to Matlab
#try:
#    msg_a = ("%f \r %f \r %f \r %f \r") %(desired_angle, Kp, Ki, Kd)
#    client_socket.send(msg_a.encode())
#except socket.erorr:
#    print("Failed to send params")
>>>>>>> 8866afd... Tried to apply servo control to the full robot, didn't work so well

# def control_servo():
#     global time_, int_err, dt, desired_angle, Kp, Ki, Kd, last_err, client_socket
#
#     treshold = 20
#     torque_max = 4000
#     cont = bge.logic.getCurrentController()
#     own = cont.owner
#
#     angle = own.localOrientation.to_euler()[0]
#     msg = str(angle) + "\r"
#     time_ = time_ + dt
#     print("Time:", time_)
#     print("Message: ", msg)
#
#     try:
#         client_socket.send(msg.encode())
#     except socket.error:
#         print("Matlab down")
#         bge.logic.endGame()
#
#     error = angle - desired_angle
#     print("error:", error)
#     print("integral:", int_err)
#     int_err += error*dt
#     d_err = (error - last_err)/dt
#     last_err = error
#     if int_err > treshold:
#         int_err = treshold
#     elif int_err < -treshold:
#         int_err = -treshold
#
#     base_torque = 200
#     correction = Kp*error + Ki*int_err + Kd*d_err
#     if correction > torque_max:
#         correction = torque_max
#     elif correction < -torque_max:
#         correction = -torque_max
#     print("correction:", correction)
#     print("")
#     own.applyTorque((correction, 0,0), True)

# Clamp function, limits a value between min and max
def clamp(min_val, max_val, val):
    return max(min_val, min(max_val, val))

# Low level PID controller
def control_servo(desired_angle, own):
    global init_time, last_time, data, Kp, Ki, Kd
    
    int_err = last_err = 0
    if own in data:
        (int_err, last_err) = data[own]
    
    treshold = 20
<<<<<<< HEAD
    torque_max = 4000
    dt = 1/60
    
    time_ = time.time() - init_time
    

    angle = own.localOrientation.to_euler()[0]
    msg = str(angle) + "\r"
    
    try:
        client_socket.send(msg.encode())
    except socket.error:
        print("Matlab down")
        bge.logic.endGame()
        sys.exit()
=======
    torque_max = 10000

    time_ = time_ + dt

    angle = own.localOrientation.to_euler()[0]
    msg = str(angle) + "\r"
#    try:
#        client_socket.send(msg.encode())
#    except socket.error:
#        print("Matlab down")
#        bge.logic.endGame()
>>>>>>> 8866afd... Tried to apply servo control to the full robot, didn't work so well

    error = angle - desired_angle
    int_err += error*dt
    int_err = clamp(-treshold, treshold, int_err)
    d_err = (error - last_err)/dt
    last_err = error

<<<<<<< HEAD
    data[own] = (int_err, last_err)

=======
>>>>>>> 8866afd... Tried to apply servo control to the full robot, didn't work so well
    correction = Kp*error + Ki*int_err + Kd*d_err
    correction = correction * torque_max
    correction = clamp(-torque_max, torque_max, correction)
    own.applyTorque((correction, 0,0), True)

    print("Time:", time_)
    #print("Message: ", msg)
    #print("error:", error)
    #print("integral:", int_err)
    #print("correction:", correction)
    #print("")

def position_control():
    cont = bge.logic.getCurrentController()
    own = cont.owner
    
    desired_angle = angles[str(own)]
    current_angle = own.localOrientation.to_euler()[0]
    print("Name", own)
    print("current angle:", current_angle)
<<<<<<< HEAD

    difference = (desired_angle - current_angle)
    print("difference:", difference)
    goal_angle = current_angle + 0.8*difference
    #goal_angle = clamp(-desired_angle, desired_angle, goal_angle)

=======
    if desired_angle != old_desired_angle:
        old_desired_angle = desired_angle
        difference = (desired_angle - current_angle)
        goal_angle = difference/10

    difference = (desired_angle - current_angle)
    print("difference:", difference)
    goal_angle = (goal_angle + 0.2*difference)
    goal_angle = clamp(-desired_angle, desired_angle, goal_angle)
        
>>>>>>> 8866afd... Tried to apply servo control to the full robot, didn't work so well
    print("New goal:", goal_angle)
    print("")

    control_servo(goal_angle, own)
