#ifndef _FUNCTIONS_H_
#define _FUNCTIONS_H_

// Control table address
#define P_GOAL_POSITION_L		30
#define P_GOAL_POSITION_H		31
#define P_PRESENT_POSITION_L	36
#define P_PRESENT_POSITION_H	37
#define P_MOVING				46

// Defulat setting
#define DEFAULT_PORTNUM		3 // COM3
#define DEFAULT_BAUDNUM		1 // 1Mbps
#define DEFAULT_ID			1

// Init communication with device
int initDevice(int PORTNUM, int BAUDNUM);

// Print communication result
void PrintCommStatus(int CommStatus);

// Print error bit of status packet
void PrintErrorCode();

int selectMode();

void manualMode();

#endif // !_FUNCTIONS_H_
