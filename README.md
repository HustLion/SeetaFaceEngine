# SeetaFace Engine

[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)


**SeetaFace Engine** is an open source C++ face recognition engine, which can run on CPU with no third-party dependence. It contains three key parts, i.e., **SeetaFace Detection**, **SeetaFace Alignment** and **SeetaFace Identification**, which are necessary and sufficient for building a real-world face recognition applicaiton system. 

* SeetaFace Detection implements a funnel-structured (FuSt) cascade schema for real-time multi-view face detection, which achieves a good trade-off between detection accuracy and speed. State of the art accuracy can be achieved on the public dataset [FDDB](http://vis-www.cs.umass.edu/fddb/) in high speed. See [SeetaFace Detection](https://github.com/seetaface/SeetaFaceEngine/tree/master/FaceDetection) for more details. 

* SeetaFace Alignment cascades several stacked auto-encoder networks to detect landmarks in real time (more than 200 fps on a single I7 desktop CPU), and achieves the state-of-the-art accuracy at least on some public datasets [AFLW](http://lrs.icg.tugraz.at/research/aflw/). See [SeetaFace Alignment](https://github.com/seetaface/SeetaFaceEngine/tree/master/FaceAlignment) for more details. 

* SeetaFace Identification is a modification of AlexNet CNN for face recognition, with better performance in terms of both accuracy (97.1% on [LFW] (http://vis-www.cs.umass.edu/lfw/) and speed (about 120ms on a single I7 desktop CPU). See [SeetaFace Identification](https://github.com/seetaface/SeetaFaceEngine/tree/master/FaceIdentification) for more details. 

This face recognition engine is developed by Visual Information Processing and Learning (VIPL) group, Institute of Computing Technology, Chinese Academy of Sciences. The codes are written in C++ without dependence on any 3rd-party libraries. The open source is now released under BSD-2 license (see [LICENSE](LICENSE) for details), which means the codes can be used freely for both acedemic purpose and industrial products.

# Recommended Environment

* OpenCV 3.1.0
* GCC 5.4




Some examples require [boost](http://www.boost.org/) library.



> [Boost](http://www.boost.org/) is a collection of peer-reviewed (i.e. very high quality) C++ libraries that help programmers and developers not get caught up in reinventing the wheel. Boost provides implementations for linear algebra, multithreading, basic image processing, and unit testing, just to name a few. [Source](http://www.pyimagesearch.com/2015/04/27/installing-boost-and-boost-python-on-osx-with-homebrew/)



## OpenCV

### MacOS

You can use brew to install opencv:

```shell
# opencv2
brew install homebrew/science/opencv
# opencv3
brew install homebrew/science/opencv3
```

## Boost

### MacOS

You can use brew to install boost:
```shell
brew install boost
```

# Build


## Linux & MacOS
Change current working directory to `SeetaFaceEngine` and run the following command:

```shell
mkdir build
cd build
cmake .. 
make -j 4
```



Then you can type `ctest` to run examples. This will pop up a window, press any key to close it.

The compiled libraries will be in the `lib` directory under you `build` directory.



## Notes

You can specify GCC/CC version by this:

```
CC=/opt/gcc-5.4.0/bin/gcc CXX=/opt/gcc-5.4.0/bin/g++ cmake ..
```



# Usage

Just include corresponding cpp header file in your code:

```shell
#include "face_identification.h"
#include "face_detection.h"
#include "face_alignment.h"
```



# Examples



To run a single test, e.g., `FeatureExtractTest`:

```shell
ctest -R FeatureExtractTest
```



To run a single test manually:

```shell
./bin/feature_extractor ./resources/model/seeta_fd_frontal_v1.0.bin ./resources/model/seeta_fa_v1.1.bin ./resources/model/seeta_fr_v1.0.bin ./resources/img/
```



# Contact Info

If you have any problem on SeetaFace Engine, please contact us by sending email to SeetaFace@vipl.ict.ac.cn.


# Other Documentation

* [SeetaFace Detection](./FaceDetection/README.md)
* [SeetaFace Alignment](./FaceAlignment/README.md)
* [SeetaFace Identification](./FaceIdentification/README.md)