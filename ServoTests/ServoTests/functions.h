#ifndef _FUNCTIONS_H_
#define _FUNCTIONS_H_

// Init communication with device
int initDevice(int PORTNUM, int BAUDNUM);

// Print communication result
void PrintCommStatus(int CommStatus);

// Print error bit of status packet
void PrintErrorCode();

#endif // !_FUNCTIONS_H_
