from bge import logic, constraints, events
from mathutils import Matrix, Vector
import socket
import bpy
import time

# Initialization
init_time = time.time()
constraints.setNumIterations(120)
scene = logic.getCurrentScene()
cont = logic.getCurrentController()

class G:
    viewer = cont.owner
    camera = scene.active_camera
    viewer.worldPosition = camera.worldPosition
    camwoe = camera.worldOrientation.to_euler()
    viewer.worldOrientation = Matrix.Rotation(camwoe.z, 3, 'Z')
    camera.setParent(viewer)
    camera.localOrientation = Matrix.Rotation(camwoe.x, 3, 'X')

    v = Vector((0,0.2))
    ev = {events.ZKEY:v.xyx,
              events.SKEY:-v.xyx,
              events.QKEY:-v.yxx,
              events.DKEY:v.yxx}
    igv = Vector((0,0,bpy.data.scenes[scene.name].game_settings.physics_gravity))

    logic.mouse.position = 0.5, 0.5  # centre mouse

socket_on = False
torques = dict()
buf = ""
last_time = 0.0
oldAngVel = dict()
for object in scene.objects:
    vec = Vector((0.0,0.0,0.0))
    vec.freeze()
    entry={(object.name, vec)}
    oldAngVel.update(entry)

# Open the socket
TCP_IP = "127.0.0.1"
TCP_PORT = 80
BUFFER_SIZE = 8192

if socket_on:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((TCP_IP, TCP_PORT))

########################
#      Main loop       #
########################
def main_loop(cont):
    global socket_on, torques, buf, BUFFER_SIZE
    global last_time, oldAngVel

    # Timekeeping
    current_time = time.time() - init_time
    timestep = current_time - last_time
    last_time = current_time

    # Camera control
    G.viewer.applyForce(G.igv, False)
    for e in G.ev:
        if logic.keyboard.events[e] == logic.KX_INPUT_ACTIVE:
            G.viewer.localLinearVelocity += G.ev[e]

    mmb = logic.mouse.events[logic.KX_MOUSE_BUT_MIDDLE]
    if mmb:
        if mmb == logic.KX_INPUT_JUST_ACTIVATED:
            logic.mouse.position = 0.5,0.5
        elif mmb == logic.KX_INPUT_ACTIVE:
            G.camera.applyRotation((-(round(logic.mouse.position[1],2)-0.5),0,0), True)
            G.viewer.localAngularVelocity += Vector((0,0,2.0 * (0.5-logic.mouse.position[0])))
            logic.mouse.position = 0.5, 0.5

    # Grouping the strings together for one big 'print'
    msg = "Time " + str(current_time) + " dT " + str(timestep) + "\n"
    socket_msg = ""

    # Parsing the orders from the socket
    order_received = False
    while socket_on and not order_received:
        data = s.recv(BUFFER_SIZE)
        if not data:
            socket_on = False
            break
        buf += data.decode()
        if "\\n" in buf:
            order_received = True
            orders = buf.split("\\n", 1)
            buf = orders[1]
            tokens = orders[0].split(" ")
            for token in tokens:
                order = token.split(':')
                entry = {(order[0], float(order[1]))}
                torques.update(entry)

    # Applying torques to the objects that have orders for them
    for key in torques:
        scene.objects[key].applyTorque((torques[key],0,0), True)
        msg += key + " :" + str(torques[key]) + "\n"

    # Computing center of gravity and reporting it
    # Also, computing angular accelerations
    center_of_gravity = Vector((0,0,0))
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
                socket_msg += str(object.name) + " Ang accel: " + str(angAccel) + "\n"

    if socket_on:
        socket_msg += "Center of gravity: " + str(center_of_gravity) + "\r"
        s.send(socket_msg.encode())

    print(msg, flush = True)
