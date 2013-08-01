//
//  EbsTime.m
//  ebsfoundation
//
//  Created by Michael Kale on 5/4/13.
//
//

#import "EbsTime.h"
#import <Foundation/Foundation.h>

#import "EbsConstants.h"

#include <time.h>

time_t midnightOnDay(time_t t) {
    struct tm theday;
    localtime_r(&t, &theday);
    theday.tm_hour = 0;
    theday.tm_min = 0;
    theday.tm_sec = 0;
    theday.tm_isdst = -1; // per the mktime man page, setting isdst < 0 "attempts to divine whether summer time is in effect"
    return mktime(&theday);
}

// this method is a bit redundant with the one below
// but this one has the advantage of being more unit testable
time_t daysAfterTime(time_t t0, int daysAfter) {
    time_t then = t0 + (TWENTYFOURHOURS_SECONDS * daysAfter);
    
    struct tm tm0, tmThen;
    localtime_r(&t0, &tm0);
    localtime_r(&then, &tmThen);
    if (tm0.tm_isdst != tmThen.tm_isdst) {
        if (tm0.tm_isdst) {
            // t0 is ON, then is OFF DST.
            // if daysAfter is +, t0<then, this includes a 25 hour day, bring up one hour
            // if daysAfter is -, t0>then, this includes a 23 hour day, bring it back one hour
            // either way, add one hour to then
            then += ONEHOUR_SECONDS;
            //if (daysAfter > 0) {
            //} else {
            //    then -= ONEHOUR_SECONDS;
            //}
        } else {
            // t0 is OFF, then is ON DST.
            // if daysAfter is +, t0<then, this includes a 23 hour day, bring it back one hour
            // if daysAfter is -, t0>then, this includes a 25 hour day, bring it up one hour
            // either way, subtract one hour from then
            then -= ONEHOUR_SECONDS;
            
            //if (daysAfter > 0) {
            //} else {
            //    then += ONEHOUR_SECONDS;
            //}
        }
    }
    return then;
}

time_t weeksAfterTime(time_t t0, int weeksAfter) {
    return daysAfterTime(t0, 7 * weeksAfter);
}

time_t monthsAfterTime(time_t t0, int monthsAfter) {
    struct tm the_tm;
    localtime_r(&t0, &the_tm);
    int wasDST = the_tm.tm_isdst;
    the_tm.tm_mon += monthsAfter;
    time_t newTime = mktime(&the_tm);
    // now check again to see if we switched over DST
    localtime_r(&newTime, &the_tm);
    int nowDST = the_tm.tm_isdst;
    if (nowDST != wasDST) {
        if (nowDST) {
            the_tm.tm_hour -= 1;
        } else {
            the_tm.tm_hour += 1;
        }
        newTime = mktime(&the_tm);
    }
    return newTime;
}

// we could implement this in terms of the above
time_t midnightDaysAgo(int daysAgo) {
    //return midnightOnDay(daysAfterTime(time(0), -1 * daysAgo));
    // if you choose that implementation, move the below code to unit tests to validate
    // that the two methods arrive at the same answer.  (now, the above line is in unit tests).
    // note that this gets tricky to test (either way) because returning midnight
    // often corrects for +/- one hour
    time_t today = todayMidnight();
    time_t then = today - (TWENTYFOURHOURS_SECONDS * daysAgo);
    
    struct tm tmToday, tmThen;
    localtime_r(&today, &tmToday);
    localtime_r(&then, &tmThen);
    if (tmToday.tm_isdst != tmThen.tm_isdst) {
        if (tmToday.tm_isdst) {
            // today is ON, then is OFF DST.  If today>then, this includes a 23 hour day and diff is +
            // if today<then, this includes a 25 hour day and diff is -
            // either way, then will be 11pm, not midnight
            // add one hour to then to get back to midnight
            then += ONEHOUR_SECONDS;
        } else {
            // today is OFF, then is ON DST.  If today>then, this includes a 25 hour day and diff is +
            // if today<then, this includes a 23 hour day and diff is -
            // either way, then will be 1am, not midnight.
            // subtract one hour from diff and get back to a multiple of 24
            then -= ONEHOUR_SECONDS;
        }
    }
    return then;
}

time_t todayMidnight() {
    return midnightOnDay(time(0));
}

int daysSinceSunday(time_t t) {
    struct tm the_tm;
    localtime_r(&t, &the_tm);
    return the_tm.tm_wday;
}

time_t previousSunday(time_t t) {
    // $TODO: can I just set wday to 0?
    // make sure to unit test this
    struct tm the_tm;
    localtime_r(&t, &the_tm);
    int wasDST = the_tm.tm_isdst;
    time_t sundayMidnight = midnightOnDay(t) - TWENTYFOURHOURS_SECONDS * daysSinceSunday(t);
    
    localtime_r(&sundayMidnight, &the_tm);
    int sundayMidnightDST = the_tm.tm_isdst;
    if (wasDST != sundayMidnightDST) {
        if (sundayMidnightDST) {
            // we just came off DST this Sunday (as we're on at midnight but off at t)
            // means sundayMidnight is really 1am, subrtact an hour
            the_tm.tm_hour -= 1;
        } else {
            // just went on DST (as we're off at midnight but on at t)
            // means sundayMidnight is really 11pm, add an hour
            the_tm.tm_hour += 1;
        }
        sundayMidnight = mktime(&the_tm);
    }
    
    return sundayMidnight;
}

time_t monthStart(time_t t) {
    struct tm theday;
    localtime_r(&t, &theday);
    theday.tm_mday = 1;
    theday.tm_hour = 0;
    theday.tm_min = 0;
    theday.tm_sec = 0;
    theday.tm_isdst = -1; // per the mktime man page, setting isdst < 0 "attempts to divine whether summer time is in effect"
    return mktime(&theday);
}

time_t thisHourStart() {
    return hourStart(time(0));
}

time_t hourStart(time_t t) {
    struct tm thehour;
    localtime_r(&t, &thehour);
    thehour.tm_min = 0;
    thehour.tm_sec = 0;
    return mktime(&thehour);
}

bool areSameDay(time_t t1, time_t t0) {
    struct tm tm1, tm0;
    localtime_r(&t1, &tm1);
    localtime_r(&t0, &tm0);
    return ((tm1.tm_mday == tm0.tm_mday) && (tm1.tm_mon == tm0.tm_mon) && (tm1.tm_year == tm0.tm_year));
}

int daysBetween(time_t t1, time_t t0) {
    // can't just divide by 24h because DST sometimes gives us 23 and 25 hour days.
    time_t new_t1 = midnightOnDay(t1);
    time_t new_t0 = midnightOnDay(t0);
    //double secondsDiff = difftime(new_t1, new_t0);
    long secondsDiff = new_t1 - new_t0; // difftime is more correct but time_t is an int # of seconds on every platform I care about so let's not mess with doubles
    struct tm tm1, tm0;
    localtime_r(&new_t1, &tm1);
    localtime_r(&new_t0, &tm0);
    if (tm1.tm_isdst != tm0.tm_isdst) {
        if (tm1.tm_isdst) {
            // t1 is ON, t0 is OFF DST.  If t1>t0, this includes a 23 hour day and diff is +
            // if t1<t0, this includes a 25 hour day and diff is -
            // either way, add one hour to diff and get back to a multiple of 24
            secondsDiff += ONEHOUR_SECONDS;
        } else {
            // t1 is OFF, t0 is ON DST.  If t1>t0, this includes a 25 hour day and diff is +
            // if t1<t0, this includes a 23 hour day and diff is -
            // either way, subtract one hour from diff and get back to a multiple of 24
            secondsDiff -= ONEHOUR_SECONDS;
        }
    }
    return (int)(secondsDiff / TWENTYFOURHOURS_SECONDS);
}

NSDate* dateWithSecondsAfterMidnight(int secondsAfterMidnight) {
    time_t t = todayMidnight() + secondsAfterMidnight;
    return [NSDate dateWithTimeIntervalSince1970:t];
}

int secondsAfterMidnightForDate(NSDate* d) {
    time_t t = [d timeIntervalSince1970];
    return (int)(t - midnightOnDay(t));
}

