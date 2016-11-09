/*
 * Copyright (C) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "HTC_CAM_SHIM"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <utils/Log.h>
#include <hardware/power.h>
#include <hardware/hardware.h>



//data exports we must provide for camera library to be happy

/*
 * DATA:     android::Singleton<android::SensorManager>::sLock
 * USE:      INTERPOSE: a mutes that camera lib will insist on accessing
 * NOTES:    In L, the sensor manager exposed this lock that callers
 *           actually locked & unlocked when accessing it. In M this
 *           is no longer the case, but we still must provide it for
 *           the camera library to be happy. It will lock nothnhing, but
 *           as long as it is a real lock and pthread_mutex_* funcs
 *           work on it, the camera library will be happy.
 */
pthread_mutex_t _ZN7android9SingletonINS_13SensorManagerEE5sLockE = PTHREAD_MUTEX_INITIALIZER;
