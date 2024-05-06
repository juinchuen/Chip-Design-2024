#include <iostream>
using namespace std;
 
// function to calculate the parity bit for a given position
int parity(int n, int *arr) {
    int p = 0;
    for (int i = 0; i < n; i++) {
        if (i != (1 << p) - 1) {
            p++;
        }
        else {
            p++;
            i += (1 << p) - 2;
        }
    }
    int sum = 0;
    for (int i = 0; i < n; i++) {
        if ((i & (1 << p - 1)) == 0) {
            sum ^= arr[i];
        }
    }
    return sum;
}
 
// function to encode the data using the Hamming code
void encode(int *data, int n, int *encoded) {
    int r = 0;
    while ((1 << r) < n + r + 1) {
        r++;
    }
    int j = 0;
    for (int i = 0; i < n + r; i++) {
        if ((i & (i + 1)) == 0) {
            encoded[i] = 0;
        }
        else {
            encoded[i] = data[j];
            j++;
        }
    }
    for (int i = 0; i < r; i++) {
        int p = parity(n + r, encoded);
        encoded[(1 << i) - 1] = p;
    }
}

void encode_sv(int *data, int n, int *encoded){

    int syndrome[5];

    syndrome[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[13] ^ data[15];
    syndrome[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[9] ^ data[10] ^ data[12] ^ data[13];
    syndrome[2] = data[1] ^ data[2] ^ data[3] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[14] ^ data[15];
    syndrome[3] = data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10];
    syndrome[4] = data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[15];

    encoded[20] = data[15];
    encoded[19] = data[14];
    encoded[18] = data[13];
    encoded[17] = data[12];
    encoded[16] = data[11];
    encoded[15] = syndrome[4];
    encoded[14] = data[10];
    encoded[13] = data[9];
    encoded[12] = data[8];
    encoded[11] = data[7];
    encoded[10] = data[6];
    encoded[ 9] = data[5];
    encoded[ 8] = data[4];
    encoded[ 7] = syndrome[3];
    encoded[ 6] = data[3];
    encoded[ 5] = data[2];
    encoded[ 4] = data[1];
    encoded[ 3] = syndrome[2];
    encoded[ 2] = data[0];
    encoded[ 1] = syndrome[1];
    encoded[ 0] = syndrome[0];

}
 
// function to decode the data using the Hamming code
bool decode(int *data, int n, int *received) {
    int r = 0;
    while ((1 << r) < n + r + 1) {
        r++;
    }
    int error = 0;
    for (int i = 0; i < r; i++) {
        int p = parity(n + r, received);
        if (p != received[(1 << i) - 1]) {
            error += (1 << i) - 1;
        }
    }
    if (error != 0) {
        received[error - 1] ^= 1;
    }
    int j = 0;
    for (int i = 0; i < n + r; i++) {
        if ((i & (i + 1)) != 0) {
            data[j] = received[i];
            j++;
        }
    }
    return error == 0;
}

void decode_sv(int *data, int n, int *received) {

    int syndrome[5];

    int corrected[21];

    syndrome[0] = received[0] ^ received[2] ^ received[4] ^ received[6] ^ received[8] ^ received[10] ^ received[12] ^ received[14] ^ received[16] ^ received[18] ^ received[20];
    syndrome[1] = received[1] ^ received[2] ^ received[5] ^ received[6] ^ received[9] ^ received[10] ^ received[13] ^ received[14] ^ received[17] ^ received[18];
    syndrome[2] = received[3] ^ received[4] ^ received[5] ^ received[6] ^ received[11] ^ received[12] ^ received[13] ^ received[14] ^ received[19] ^ received[20];
    syndrome[3] = received[7] ^ received[8] ^ received[9] ^ received[10] ^ received[11] ^ received[12] ^ received[13] ^ received[14];
    syndrome[4] = received[15] ^ received[16] ^ received[17] ^ received[18] ^ received[19] ^ received[20];

    int syndrome_or = syndrome[0] | syndrome[1] | syndrome[2] | syndrome[3] | syndrome[4];

    int syndrome_int = (syndrome[0] << 0) | (syndrome[1] << 1) | (syndrome[2] << 2) | (syndrome[3] << 3) | (syndrome[4] << 4);

    int flipped = syndrome_or == 0 ? received[syndrome_int - 1] : (1 - received[syndrome_int - 1]);

    for (int i = 0; i < 21; i++) corrected[i] = received[i];

    corrected[syndrome_int - 1] = flipped;

    data[15] = corrected[20];
    data[14] = corrected[19];
    data[13] = corrected[18];
    data[12] = corrected[17];
    data[11] = corrected[16];
    data[10] = corrected[14];
    data[ 9] = corrected[13];
    data[ 8] = corrected[12];
    data[ 7] = corrected[11];
    data[ 6] = corrected[10];
    data[ 5] = corrected[9];
    data[ 4] = corrected[8];
    data[ 3] = corrected[6];
    data[ 2] = corrected[5];
    data[ 1] = corrected[4];
    data[ 0] = corrected[2];

}

// void main(){}