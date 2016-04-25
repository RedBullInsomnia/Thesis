#ifndef _FUNCTIONS_H_
#define _FUNCTIONS_H_

// Control table address
#define P_ALARM_LED             17
#define P_ALARM_SHUTDOWN        18
#define P_LED                   25
#define P_GOAL_POSITION_L		30
#define P_GOAL_POSITION_H		31
#define P_MOVING_SPEED_L        32
#define P_TORQUE_LIMIT_L        34
#define P_PRESENT_POSITION_L	36
#define P_PRESENT_POSITION_H	37
#define P_MOVING				46

// Defulat setting
#define DEFAULT_PORTNUM		3 // COM3
#define DEFAULT_BAUDNUM		1 // 1Mbps
#define DEFAULT_ID			1

// Init communication with device
int initDevice();

// Print communication result
void PrintCommStatus(int CommStatus);

// Print error bit of status packet
void PrintErrorCode();

int selectMode();

void manualMode();
void testCycleMode(int index);

void setSpeedLimit(int speed_limit);

void resetServo();

#endif // !_FUNCTIONS_H_
