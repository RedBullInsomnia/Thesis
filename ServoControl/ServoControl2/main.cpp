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

    }
}