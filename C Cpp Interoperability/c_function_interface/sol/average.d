module D-Summer-School.lab-07.c_function_interface.sol.average;

/**
 * Read about arrays in D here:
 * https://dlang.org/spec/interfaceToC.html#passing_d_array
 */
extern(C) double computeAverage(int* arr, int n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += arr[i];
    }

    return cast(double)sum / n;
}
