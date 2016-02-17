import bge
import time
import PhysicsConstraints
import socket
import sys
import math

matlab = False

init_time = time.time()
last_time = 0.0

angles = dict()
angles["Servo.002"] = 0.5
angles["Servo.003"] = 0.5

Kp = 0.01
Ki = 0

data = dict()

TCP_IP ="127.0.0.1"
TCP_PORT = 80

if matlab:
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect((TCP_IP,TCP_PORT))

    print("Connected to Matlab")
    time.sleep(0.1)

    # Send params to Matlab
    desired_angle = angles["Servo.002"]
    try:
        msg_a = ("%f \r %f \r %f \r") %(desired_angle, Kp, Ki)
        client_socket.send(msg_a.encode())
    except socket.error:
        print("Failed to send params")

# Clamp function, limits a value between min and max
def clamp(min_val, max_val, val):
    return max(min_val, min(max_val, val))

# Low level PID controller
def control_servo():
    global init_time, last_time, data, Kp, Ki, angles, data, matlab

    cont = bge.logic.getCurrentController()
    own = cont.owner

    int_err = 0
    if own in data:
        int_err = data[own]
    desired_angle = angles[str(own)]

    treshold = 20
    torque_max = 4000

    time_ = time.time() - init_time
    dt = time_ - last_time
    last_time = time_

    angle = own.localOrientation.to_euler()[0]
    msg = str(angle) + "\r"

    if matlab:
        try:
            client_socket.send(msg.encode())
        except socket.error:
            print("Matlab down")
            bge.logic.endGame()
            sys.exit()

    error = desired_angle - angle
    int_err += abs(error)*dt
    int_err = clamp(0, treshold, int_err)

    data[own] = int_err
    
    if error > 0:
        correction = Kp*error + Ki*int_err
    else:
        correction = Kp*error - Ki*int_err
        
    correction = clamp(-torque_max, torque_max, correction)
    own.applyTorque((correction, 0,0), True)

    print("Time dt:", dt)
    print("TIme:", time_)
    print("Angle: ", msg)
    print("error:", error)
    print("integral:", int_err)
    print("correction:", correction)
    print("LogicTicRate:", bge.logic.getLogicTicRate())
    print("")
