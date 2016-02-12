import bge
import time
import PhysicsConstraints
import socket
import sys

cont = bge.logic.getCurrentController()
own = cont.owner

desired_angle = 0.5
goal_angle = 0.0
old_desired_angle = 0.0
difference = 0.0
int_err = 0.0
time_ = 0.0
last_err = 0.0
dt = 1/60
Kp = -3000.0
Ki = -2400.0
Kd = -400.0

TCP_IP ="127.0.0.1"
TCP_PORT = 80

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((TCP_IP,TCP_PORT))

print("Connected to Matlab")
time.sleep(0.1)

try:
    # Send desired angle
    msg_a = ("%f \r") %(desired_angle)
    print("msg_angle:", msg_a)
    client_socket.send(msg_a.encode())

    # Send Kp
    msg_p = str(Kp) + "\r"
    print("msg_kp:", msg_p)
    client_socket.send(msg_p.encode())

    # Send Ki
    msg_i = str(Ki) + "\r"
    print("msg_ki:", msg_i)
    client_socket.send(msg_i.encode())

    # Send kd
    msg_d = str(Kd) + "\r"
    print("msg_kd:", msg_d)
    client_socket.send(msg_d.encode())
except socket.erorr:
    print("Failed to send params")

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

def control_servo(desired_angle):
    global time_, int_err, dt, last_err, Kp, Ki, Kd, own

    treshold = 20
    torque_max = 4000

    print("Hello")
    
    angle = own.localOrientation.to_euler()[0]
    msg = str(angle) + "\r"
    time_ = time_ + dt
    print("Time:", time_)
    print("Message: ", msg)

    try:
        client_socket.send(msg.encode())
    except socket.error:
        print("Matlab down")
        bge.logic.endGame()

    error = angle - desired_angle
    print("error:", error)
    print("integral:", int_err)
    int_err += error*dt
    d_err = (error - last_err)/dt
    last_err = error
    if int_err > treshold:
        int_err = treshold
    elif int_err < -treshold:
        int_err = -treshold

    base_torque = 200
    correction = Kp*error + Ki*int_err + Kd*d_err
    if correction > torque_max:
        correction = torque_max
    elif correction < -torque_max:
        correction = -torque_max
    print("correction:", correction)
    print("")
    own.applyTorque((correction, 0,0), True)

def position_control():
    global own, start_angle, difference, old_desired_angle, goal_angle
   
    max_steps = 12
    min_steps = 2
    if desired_angle > 0:
        size_step = 0.1
    else:
        size_step = -0.1

    current_angle = own.localOrientation.to_euler()[0]
    if desired_angle != old_desired_angle:
        old_desired_angle = desired_angle
        difference = desired_angle - current_angle

        num_steps = difference / size_step
        if num_steps > max_steps:
            num_steps = max_steps
            size_step = difference / num_steps
        elif num_steps < min_steps:
            num_steps = min_steps
            size_step = difference / num_steps
            
        goal_angle = current_angle + size_step
    
    difference = goal_angle - current_angle
    print("difference is :", difference)
    print("size step:", size_step)
    if (difference/size_step) > 0.2 or difference/size_step < -0.2:
        control_servo(goal_angle)
    else:
        if goal_angle + size_step < desired_angle:
            goal_angle += size_step
        elif goal_angle > desired_angle:
            goal_angle += desired_angle - current_angle
