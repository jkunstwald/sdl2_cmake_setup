# SDL2 Setup

![screenshot](https://user-images.githubusercontent.com/17261478/73799160-707b4180-47b5-11ea-8988-1bbca25d03d6.PNG)

**Download: [SDL2_Setup.exe](https://github.com/jkunstwald/sdl2_cmake_setup/releases/download/v1.1/SDL2_Setup.exe)**

Installs SDL2 on Windows (MSVC, 32/64bit), making this work out of the box:

```cmake
find_package(SDL2 REQUIRED)
```

---

### Setup steps

Internally, the setup does the following:

1. Downloads SDL2 development libraries (For MS Visual C++, 32/64bit) from [libsdl.org](https://www.libsdl.org/download-2.0.php)

2. Extracts them to your directory of choice

3. Adds a CMake config file to them

4. Sets the `SDL2_DIR` environment variable in the registry to the correct path

5. Moves the headers in `include/` to `include/SDL2/` to fix include paths (for `#include <SDL2/SDL.h>`)

6. Informs IDEs about a change in the system environment, as to not require a reboot

7. Creates an uninstaller and registers it with Windows
