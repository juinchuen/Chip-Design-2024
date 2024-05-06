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

void print_array(int* data, int n){

    int space = n % 8;

    if (space != 0){
        for (int i = 0; i < 8 - space; i++){
            printf("0");
        }
    }

    space = space == 0 ? 8 : space;

    for (int i = n-1; i >= 0; i--){

        printf("%d", data[i]);

        space--;

        if (space == 0){
            space = 8;
            printf(" ");
        }

    }

    printf("\n");

}

void char2array (char a, char b, int* output){

    for (int i = 0; i < 8; i++){

        output[i]   = (a & 1) ? 1 : 0;
        output[i+8] = (b & 1) ? 1 : 0;

        a >>= 1;
        b >>= 1;

    }

}

void array2char (char* a, char* b, int* input){

    *a = 0;
    *b = 0;

    for (int i = 0; i < 8; i++){

        *a = input[i]   == 1? (*a << 1) + 1 : (*a << 1);
        *b = input[i+8] == 1? (*b << 1) + 1 : (*b << 1);

    }

}

void short2array (unsigned short input, int* output){

    for (int i = 0; i < 16; i++){

        output[i]   = (input & 1) ? 1 : 0;

        input >>= 1;

    }

}

void array2short (unsigned short* output, int* input){

    *output = 0;

    for (int i = 15; i >= 0; i--){

        *output = (input[i] == 1) ? (*output << 1) + 1 : (*output << 1);

    }

}

void encoded2bytes (int* encoded, char* send_data){

    send_data[0] = 0;
    send_data[1] = 0;
    send_data[2] = 0;
    

    for (int i = 7; i >= 0; i--){

        send_data[0] = encoded[i]   == 1 ? (send_data[0] << 1) + 1 : send_data[0] << 1;
        send_data[1] = encoded[i+8] == 1 ? (send_data[1] << 1) + 1 : send_data[1] << 1;

    }

    for (int i = 4; i >= 0; i--){

        send_data[2] = encoded[i+16] == 1 ? (send_data[2] << 1) + 1 : send_data[2] << 1;

    }

}

void short2encoded_bytes (short in, char* out, bool debug){

    int in_array[16];

    int encoded[21];

    int decoded[16];

    short2array(in, in_array);

    encode(in_array, 16, encoded);

    encoded2bytes(encoded, out);

    decode(decoded, 16, encoded);

    if (debug){

        printf("raw hex:\t\t ");

        print_array(in_array, 16);

        printf("encoded:\t");

        print_array(encoded, 21);

        printf("encoded bytes:\t%8d %8d %8d\n", out[2], out[1], out[0]);

        printf("decoded:\t\t ");

        print_array(decoded, 16);

    }

}

int main(){

    short in = 20085;

    char out[3];

    short2encoded_bytes(in, out, true);

    return 0;

}