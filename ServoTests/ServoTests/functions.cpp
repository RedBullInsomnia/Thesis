#include "functions.h"
#include "dynamixel.h"
#include <iostream>
#include <conio.h>

using namespace std;

//Init device
int initDevice(int PORTNUM, int BAUDNUM)
{
	if (dxl_initialize(PORTNUM, BAUDNUM) == 0)
	{
		cout << "Failed to open USB2Dynamixel!" << endl;
		cout << "Press any key to terminate..." << endl;
		_getch();
		return 0;
	}
	else
	{
		cout << "Succeed to open USB2Dynamixel!" << endl;
		return 1;
	}
}

// Print communication result
void PrintCommStatus(int CommStatus)
{
	switch (CommStatus)
	{
	case COMM_TXFAIL:
		cout << "COMM_TXFAIL: Failed transmit instruction packet!" << endl;
		break;

	case COMM_TXERROR:
		cout << "COMM_TXERROR: Incorrect instruction packet!" << endl;
		break;

	case COMM_RXFAIL:
		cout << "COMM_RXFAIL: Failed get status packet from device!" << endl;
		break;

	case COMM_RXWAITING:
		cout << "COMM_RXWAITING: Now recieving status packet!" << endl;
		break;

	case COMM_RXTIMEOUT:
		cout << "COMM_RXTIMEOUT: There is no status packet!" << endl;
		break;

	case COMM_RXCORRUPT:
		cout << "COMM_RXCORRUPT: Incorrect status packet!" << endl;
		break;

	default:
		cout << "This is unknown error code!" << endl;
		break;
	}
}

// Print error bit of status packet
void PrintErrorCode()
{
	if (dxl_get_rxpacket_error(ERRBIT_VOLTAGE) == 1)
		cout << "Input voltage error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_ANGLE) == 1)
		cout << "Angle limit error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_OVERHEAT) == 1)
		cout << "Overheat error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_RANGE) == 1)
		cout << "Out of range error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_CHECKSUM) == 1)
		cout << "Checksum error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_OVERLOAD) == 1)
		cout << "Overload error!" << endl;

	if (dxl_get_rxpacket_error(ERRBIT_INSTRUCTION) == 1)
		cout << "Instruction code error!" << endl;
}

int selectMode()
{
	int choice = 0;
	while (choice <= 0 || choice >= 4)
	{
		cout << "Select the operation mode :" << endl;
		cout << "1. Manual (enter target position)" << endl;
		cout << "2. Torque test" << endl;
		cout << "3. Rotation speed test" << endl;
		cout << "Your choice (1, 2 or 3) ? ";
		cin >> choice;
	}
	return choice;
}

void manualMode()
{
	int goal_pos, present_pos, comm_status, moving;

	cout << "Goal position ? (-1 to quit)";
	cin >> goal_pos;
	if (goal_pos == -1)
		return;

	dxl_write_word(DEFAULT_ID, P_GOAL_POSITION_L, goal_pos);
	do
	{
		// Read present position
		present_pos = dxl_read_word(DEFAULT_ID, P_PRESENT_POSITION_L);
		comm_status = dxl_get_result();
		if (comm_status == COMM_RXSUCCESS)
		{
			cout << goal_pos << " " << present_pos << endl;
			PrintErrorCode();
		}
		else
		{
			PrintCommStatus(comm_status);
			break;
		}

		// Check moving done
		moving = dxl_read_byte(DEFAULT_ID, P_MOVING);
		comm_status = dxl_get_result();
		if (comm_status == COMM_RXSUCCESS)
		{
			PrintErrorCode();
		}
		else
		{
			PrintCommStatus(comm_status);
			break;
		}

	} while (moving == 1);
}