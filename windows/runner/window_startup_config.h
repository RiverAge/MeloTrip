#ifndef RUNNER_WINDOW_STARTUP_CONFIG_H_
#define RUNNER_WINDOW_STARTUP_CONFIG_H_

#include <windows.h>

void ConfigureInitialWindowPositionAndScale(HWND window_handle,
                                            int logical_width,
                                            int logical_height);

#endif  // RUNNER_WINDOW_STARTUP_CONFIG_H_
