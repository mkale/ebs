//
//  EbsTime.h
//  ebsfoundation
//
//  Created by Michael Kale on 5/4/13.
//
//

#ifdef __cplusplus
extern "C" {
#endif

bool areSameDay(time_t t1, time_t t0);
int daysBetween(time_t t1, time_t t0);
time_t todayMidnight();
time_t midnightOnDay(time_t t);
time_t midnightDaysAgo(int daysAgo);
time_t daysAfterTime(time_t t0, int daysAfter);
time_t weeksAfterTime(time_t t0, int weeksAfter);
time_t monthsAfterTime(time_t t0, int monthsAfter);
time_t previousSunday(time_t t);
int daysSinceSunday(time_t t);
time_t monthStart(time_t t);
time_t thisHourStart();
time_t hourStart(time_t t);
NSDate* dateWithSecondsAfterMidnight(int secondsAfterMidnight);
int secondsAfterMidnightForDate(NSDate* d);

#ifdef __cplusplus
}
#endif
