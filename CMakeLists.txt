project(SeetaFaceEngine)

cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

set(SEETA_FACE_ENGINE_VERSION "master" CACHE STRING "Version name of Seeta Face Engine")
# Build options
option(USE_OPENMP      "Set to ON to build use openmp"  ON)
option(USE_SSE         "Set to ON to build use SSE"  ON)
option(BUILD_TESTS     "Set to ON to build tests"  ON)
option(BUILD_EXAMPLES  "Set to ON to build examples"  ON)
# Use C++11
set(CMAKE_CXX_STANDARD_REQUIRED ON)
message(STATUS "C++11 support has been enabled by default.")

if(NOT ${CMAKE_VERSION} VERSION_LESS 3.1)
    set(CMAKE_CXX_STANDARD 11)
else()
    set(CMAKE_CXX_FLAGS "-std=c++11")
endif()


# Use SSE
if (USE_SSE)
    add_definitions(-DUSE_SSE)
    message(STATUS "Use SSE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse4.1")
endif()

# Use OpenMP
if (USE_OPENMP)
    find_package(OpenMP QUIET)
    if (OPENMP_FOUND)
        message(STATUS "Use OpenMP")
        add_definitions(-DUSE_OPENMP)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
    endif()
endif()

# Add a compiler flag to check the output for insane values if we are in debug mode.
if(CMAKE_BUILD_TYPE MATCHES DEBUG)
	message(STATUS "Building debug release of SeetaFaceEngine.")
	add_definitions(-DASSERT_INSANE_OUTPUT)
endif()

# Add warnings
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

if(NOT APPLE AND NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
endif()

# Common setup
include_directories(${CMAKE_CURRENT_BINARY_DIR} lib)
include_directories(vendor)
include_directories(include)

# Build detection library
file(GLOB_RECURSE dtc_SRCS "src/detection/*.cpp")
file(GLOB_RECURSE dtc_HEADERS "src/detection/*.h")

set (dtc_INCLUDE_DIRS "")
foreach (_headerFile ${dtc_HEADERS})
    get_filename_component(_dir ${_headerFile} PATH)
    list (APPEND dtc_INCLUDE_DIRS ${_dir})
endforeach()
list(REMOVE_DUPLICATES dtc_INCLUDE_DIRS)

include_directories(${dtc_INCLUDE_DIRS})

add_library(seeta_facedet_lib SHARED ${dtc_SRCS})
set(facedet_required_libs seeta_facedet_lib)



add_custom_command(TARGET seeta_facedet_lib POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/resources ${CMAKE_BINARY_DIR}/resources) 

# Build alignment library

file(GLOB_RECURSE alg_SRCS "src/alignment/*.cpp")
file(GLOB_RECURSE alg_HEADERS "src/alignment/*.h")

set (alg_INCLUDE_DIRS "")
foreach (_headerFile ${alg_HEADERS})
    get_filename_component(_dir ${_headerFile} PATH)
    list (APPEND alg_INCLUDE_DIRS ${_dir})
endforeach()
list(REMOVE_DUPLICATES alg_INCLUDE_DIRS)

include_directories(${alg_INCLUDE_DIRS})


add_library(seeta_fa_lib SHARED ${alg_SRCS})
set(fa_required_libs seeta_fa_lib)

# Build verification library

file(GLOB_RECURSE vrf_SRCS "src/verification/*.cpp")
file(GLOB_RECURSE vrf_HEADERS "src/verification/*.h")

set (vrf_INCLUDE_DIRS "")
foreach (_headerFile ${vrf_HEADERS})
    get_filename_component(_dir ${_headerFile} PATH)
    list (APPEND vrf_INCLUDE_DIRS ${_dir})
endforeach()
list(REMOVE_DUPLICATES vrf_INCLUDE_DIRS)

include_directories(${vrf_INCLUDE_DIRS})

add_library(viplnet SHARED ${vrf_SRCS})
set(seeta_fi_lib_required_libs viplnet)

# List of tests. For each test there must be a file tests/${NAME}.cpp and a file tests/${NAME}.h.
set(engine_TEST
	detection
    alignment
)


# Compiling the test environment.
# if (BUILD_TESTS)
#     message(STATUS "Building tests...")
#     enable_testing()
#     foreach (test ${engine_TEST})
#         add_executable(${test} tests/main.cpp tests/${test}.cpp)
#         add_test(${test} ${test})
#     endforeach()
# endif()


#add_custom_command(TARGET SeetaFaceEngine POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/resources $<TARGET_FILE_DIR:${PROJECT}>/resources) 

# Build examples
set(eg_model ${CMAKE_BINARY_DIR}/resources/model)
set(eg_img ${CMAKE_BINARY_DIR}/resources/img)
set(dtc_model ${eg_model}/seeta_fd_frontal_v1.0.bin)
set(alg_model ${eg_model}/seeta_fa_v1.1.bin)
set(vrf_model ${eg_model}/seeta_fr_v1.0.bin)
if (BUILD_EXAMPLES)
    message(STATUS "Build with examples.")
    find_package(OpenCV)
    if (NOT OpenCV_FOUND)
        message(WARNING "OpenCV not found. Test will not be built.")
    else()
        include_directories(${OpenCV_INCLUDE_DIRS})
        list(APPEND facedet_required_libs ${OpenCV_LIBS})
        add_executable(facedet_test examples/facedetection_test.cpp)
        target_link_libraries(facedet_test ${facedet_required_libs})

        list(APPEND fa_required_libs ${OpenCV_LIBS} seeta_facedet_lib)
        add_executable(fa_test examples/face_alignment_test.cpp)
        target_link_libraries(fa_test ${fa_required_libs})

        list(APPEND seeta_fi_lib_required_libs ${OpenCV_LIBS} seeta_facedet_lib seeta_fa_lib)
        add_executable(test_face_recognizer examples/test_face_recognizer.cpp)
        target_link_libraries(test_face_recognizer ${seeta_fi_lib_required_libs})
        add_executable(test_face_verification examples/test_face_verification.cpp)
        target_link_libraries(test_face_verification ${seeta_fi_lib_required_libs})
        add_executable(feature_extractor examples/feature_extractor.cpp)
        target_link_libraries(feature_extractor ${seeta_fi_lib_required_libs})
        add_executable(extract_output examples/extract_output.cpp)
        target_link_libraries(extract_output ${seeta_fi_lib_required_libs})
        enable_testing()
        message("Press any key to finish the test.")
        add_test(DetectionTest ${EXECUTABLE_OUTPUT_PATH}/facedet_test ${eg_img}/0_1_1.jpg ${dtc_model})
        add_test(AlignmentTest ${EXECUTABLE_OUTPUT_PATH}/fa_test  ${dtc_model} ${alg_model} ${eg_img}/image_0001.png)
        add_test(RecognizerTest ${EXECUTABLE_OUTPUT_PATH}/test_face_recognizer ${eg_img}/ ${eg_model}/)
        add_test(VerificationTest ${EXECUTABLE_OUTPUT_PATH}/test_face_verification ${dtc_model} ${alg_model} ${vrf_model} ${eg_img}/)
        add_test(FeatureExtractTest ${EXECUTABLE_OUTPUT_PATH}/feature_extractor ${dtc_model} ${alg_model} ${vrf_model} ${eg_img}/)
        set_property(TEST FeatureExtractTest PROPERTY PASS_REGULAR_EXPRESSION "0.637016")
        add_test(extract_outputTest ${EXECUTABLE_OUTPUT_PATH}/extract_output ${dtc_model} ${alg_model} ${vrf_model} ${eg_img}/test_face_recognizer/images/compare_im/Aaron_Peirsol_0001.jpg)
    endif()
endif()



# Installing SeetaFaceEngine.
# include(GNUInstallDirs)
# install(TARGETS SeetaFaceEngine DESTINATION ${CMAKE_INSTALL_BINDIR})
# include(CPackConfig.cmake)

