import bge
import time
import PhysicsConstraints
import socket
import sys
import math

time_ = 0.0
desired_angle = 0.5

int_err = 0.0
last_err = 0.0
dt = 1/60

TCP_IP ="127.0.0.1"
TCP_PORT = 80

#client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#client_socket.connect((TCP_IP,TCP_PORT))

#print("Connected to Matlab")
#time.sleep(0.1)

## Send params to Matlab
#try:
#    msg_a = ("%f \r %f \r %f \r %f \r") %(desired_angle, Kp, Ki, Kd)
#    client_socket.send(msg_a.encode())
#except socket.erorr:
#    print("Failed to send params")

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
    global time_, int_err, dt, last_err
    
    Kp = -2200
    Ki = -1600
    Kd = -600
    
    treshold = 20
    torque_max = 4000

    time_ = time_ + dt

    angle = own.localOrientation.to_euler()[0]
    msg = str(angle) + "\r"
#    try:
#        client_socket.send(msg.encode())
#    except socket.error:
#        print("Matlab down")
#        bge.logic.endGame()

    error = angle - desired_angle
    int_err += error*dt
    int_err = clamp(-treshold, treshold, int_err)
    d_err = (error - last_err)/dt
    last_err = error

    correction = Kp*error + Ki*int_err + Kd*d_err
    correction = clamp(-torque_max, torque_max, correction)
    own.applyTorque((correction, 0,0), True)

    #print("Time:", time_)
    #print("Message: ", msg)
    #print("error:", error)
    #print("integral:", int_err)
    #print("correction:", correction)
    #print("")

def position_control():
    cont = bge.logic.getCurrentController()
    own = cont.owner

    current_angle = own.localOrientation.to_euler()[0]
    print("Name", own)
    print("current angle:", current_angle)

    difference = (desired_angle - current_angle)
    print("difference:", difference)
    goal_angle = current_angle + 0.7*difference
    #goal_angle = clamp(-desired_angle, desired_angle, goal_angle)

    print("New goal:", goal_angle)
    print("")

    control_servo(goal_angle, own)
