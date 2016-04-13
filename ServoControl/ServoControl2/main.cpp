#include <Windows.h>
#include <iostream>
#include <conio.h>
#include "dynamixel2.h"
#include "functions.h"

#pragma comment(lib, "dynamixel2_win64.lib")

#define MAX_IN_CHAR 128

using namespace std;

int main(void)
{
	char input[MAX_IN_CHAR];
	int port_num = 3, baud_rate = 57600, input_len, num_param;
	int baudrates[] = {9600, 19200, 57600, 115200, 200000, 250000, 400000, 500000, 1000000 };

    // Initialization
	if (dxl_initialize(port_num, baud_rate) == 0)
	{
		printf("Failed to open USB2Dynamixel!\n");
		printf("Press any key to terminate...\n");
		_getch();
		return 0;
	}
	else
    {
		printf("Succeed to open USB2Dynamixel!\n\n");
    }

    while (true)
    {
		for (size_t i = 0; i < 9; ++i)
		{
			if (dxl_change_baudrate(baudrates[i]) == 0)
			{
				printf("Failed to change baudrate!\n");
				continue;
			}
			printf("\n Changed baudrate to [baud num : %d]\n\n", baudrates[i]);
			dxl_ping(1);
		}
		break;
    }

	dxl_terminate();
	return 0;
}