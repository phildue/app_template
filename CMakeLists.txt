cmake_minimum_required(VERSION 3.1)
project(app CXX)

# Download automatically, you can also just copy the conan.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
   message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
   file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
                  "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_configure(REQUIRES MyLibrary/1.0.0@pd/stable
                      GENERATORS cmake_paths)

conan_cmake_autodetect(settings)

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conan-center
                    SETTINGS ${settings})
                    
include(${CMAKE_BINARY_DIR}/conan_paths.cmake)


if(NOT TARGET PD::MyLibrary)
    find_package(MyLibrary)
endif()

add_executable(${PROJECT_NAME} src/app.cpp)
target_link_libraries(${PROJECT_NAME} PD::MyLibrary)


