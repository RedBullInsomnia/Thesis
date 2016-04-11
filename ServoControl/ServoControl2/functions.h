#ifndef _FUNCTIONS_H_
#define _FUNCTIONS_H_

void Help();
void Scan(void);
void BroadcastPing();
void Write(int id, int addr, unsigned int value, int len);
void Write2(int id, int addr, unsigned int value, int len);
void Read(int id, int addr, int len);
void Read2(int id, int addr, int len);
void ReadTable(int id, int addr, int len);
void ReadTable2(int id, int addr, int len);
void PrintErrorCode(int ErrorCode);

#endif