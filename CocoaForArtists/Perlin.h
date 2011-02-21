
#ifndef _PERLIN_NOISE_H_
#define _PERLIN_NOISE_H_

float noise1(float arg);
float noise2(float vec[2]);
float noise3(float vec[3]);
float turbulence(float point[3], float lofreq, float hifreq) ;
float noise2_na(float x, float y);
float noise3_na(float x, float y, float z);

#endif

