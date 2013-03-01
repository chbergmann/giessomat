#ifndef _CLOCK_H_
#define _CLOCK_H_

enum weekday
{
	Montag,
	Dienstag,
	Mittwoch,
	Donnerstag,
	Freitag,
	Samstag,
	Sonntag
};

struct time_st
{
	unsigned char sec;
	unsigned char min;
	unsigned char hour;
	int day;
	int month;
	int sec_cnt;
	int hour_cnt;
};

extern struct time_st zeit;
extern const char monat[12][4];
extern int tickcount;

void Clock_Init();
uint16_t get_freq(unsigned char port);

#endif //_CLOCK_H_
