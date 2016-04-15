// Windows version
#include <windows.h>
#include <iostream>
#include <conio.h>
#include "dynamixel.h"
#include "functions.h"

#pragma comment(lib, "dynamixel.lib")

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

using namespace std;

int main()
{
	int GoalPos[] = { 0, 1023}; // max 1023
	int index = 0;
	int Moving, PresentPos;
	int CommStatus;

	// Open device
	if (initDevice(DEFAULT_PORTNUM, DEFAULT_BAUDNUM) == 0)
		return 0;

	while (1)
	{
		cout << "Press any key to continue!(press ESC to quit)" << endl;
		if (_getch() == 0x1b)
			break;

		// Write goal position
		dxl_write_word(DEFAULT_ID, P_GOAL_POSITION_L, GoalPos[index]);
		do
		{
			// Read present position
			PresentPos = dxl_read_word(DEFAULT_ID, P_PRESENT_POSITION_L);
			CommStatus = dxl_get_result();
			if (CommStatus == COMM_RXSUCCESS)
			{
				cout << GoalPos[index] << " " << PresentPos << endl;
				PrintErrorCode();
			}
			else
			{
				PrintCommStatus(CommStatus);
				break;
			}

			// Check moving done
			Moving = dxl_read_byte(DEFAULT_ID, P_MOVING);
			CommStatus = dxl_get_result();
			if (CommStatus == COMM_RXSUCCESS)
			{
				if (Moving == 0)
				{
					// Change goal position
					if (index == 0)
						index = 1;
					else
						index = 0;
				}

				PrintErrorCode();
			}
			else
			{
				PrintCommStatus(CommStatus);
				break;
			}

		} while (Moving == 1);
	}

	// Close device
	dxl_terminate();
	cout << "Press any key to terminate..." << endl;
	_getch();
	return 0;
}