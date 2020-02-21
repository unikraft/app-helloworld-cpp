# Unikraft C++ Hello World Application

To build and run this application please use the `kraft` script:

    pip3 install git+https://github.com/unikraft/kraft.git
    mkdir my-helloworld-cpp && cd my-helloworld-cpp
    kraft up -p PLATFORM -m ARCHITECTURE -a helloworld-cpp my-helloworld-cpp

For more information about `kraft` type ```kraft -h``` or read the
[documentation](http://docs.unikraft.org).
