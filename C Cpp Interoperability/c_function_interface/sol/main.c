
#include <stdio.h>
#include <stdlib.h>

double computeAverage(int arr[], int n);

int main() {
    int n;
    scanf("%d", &n);

    int* arr = (int*) malloc(n * sizeof(int));
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr[i]);
    }

    printf("Average = %lf\n", computeAverage(arr, n));
    return 0;
}
