//
//  EbsConstants.h
//  ebsfoundation
//
//  Created by mkale on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

static const double OZ_TO_ML = 29.57353;
static const double UKOZ_TO_ML = 28.41307;
static const double ML_TO_OZ = 0.033814;
static const double ML_TO_UKOZ = 0.035195;
static const double LBS_TO_OZ = 16.0;
static const double OZ_TO_LBS = 1.0 / 16.0;
static const double OZ_TO_GRAMS = 28.3495;
static const double GRAMS_TO_OZ = 0.03527;
static const double GRAMS_TO_KG = 1.0 / 1000.0;
static const double FEET_TO_INCHES = 12.0;
static const double INCHES_TO_FEET = 1.0 / 12.0;
static const double INCHES_TO_CM = 2.54;
static const double CM_TO_INCHES = 0.3937;

static const double PI = 3.14159265;
static const long ONEHOUR_SECONDS = 60 * 60;
static const long TWENTYFOURHOURS_SECONDS = 60 * 60 * 24; //ONEHOUR_SECONDS * 24;
static const long TWENTYFOURHOURS_MINUTES = 60 * 24;
static const time_t FAR_FUTURE = 2147000000;

#ifdef __cplusplus
}
#endif

