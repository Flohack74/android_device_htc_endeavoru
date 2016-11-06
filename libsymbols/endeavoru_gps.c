#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>

#include <utils/Log.h>

pthread_mutex_t _ZN7android9SingletonINS_13SensorManagerEE5sLockE = PTHREAD_MUTEX_INITIALIZER;
