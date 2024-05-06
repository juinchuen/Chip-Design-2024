# Error Checking Module

This module implements a Hamming(16, 21) code algorithm. Assuming that the user sends in 21-bit encoded data using the [Hamming code algorithm](https://en.wikipedia.org/wiki/Hamming_code), this module retrieves the 16-bit decoded data and verifies that the decoding process was successfully completed.

## Source Code

This code is in the `decode.c` file. It has three functions:

- `parity()` which calculates the parity bit for a given position
- `encode()` which encodes a 1d data array using Hamming(16,21)
- `decode()` which decodes a 1d data array using Hamming(16,21)

### The `parity` function

**Inputs**: `n` (the length of the input array), `*arr` (a pointer to the input array of bits)   
**Goal**: Calculate the parity bit for the given array's parity bit position.   
**Process:**
1. Calculate the position of the parity bit being calculated - `p`.
2. XOR the bits not stored at parity bit positions (which are positions that are powers of 2) with the cumulated `sum` value and returns it.

**Return value**: Either `1` or `0` - `sum`

### The `encode` function
**Inputs**: `n` (the length of the data array), `*data` (a pointer to the array of bits to be encoded) and `*encoded` (a pointer to the variable where the encoded data is stored)   
**Goal**: Encodes a given data array using Hamming(16,21) code   
**Process**:
1. Calculate the number of parity bits -> `r`.
2. Move the data bits into the `encoded` array, setting positions assigned to parity bits (powers of 2) to 0.
3. Determine the parity bit at each parity bit location (using the `parity()` function) and store it at appropriate index of `encoded` array.
   
**Return value**: None; the encoded data is stored in a global variable.

### The `decode` function
**Inputs**: `n` (the length of the decoded data array), `*data` (a pointer to the decoded array of bits) and `*received` (a pointer to the encoded input array)   
**Goal**: Decode a given data array using the Hamming(16,21) code   
**Process**:
1. Determine the number of parity bits -> `r`.
2. Calculate the correct parity bit for each parity bit position. If it does not match the corresponding value in the input array, increment `error` by the incorrect parity bit's index.
3. If there's an error, flip the corrupted bit of the input array (the data bit at `received[error-1]`).
4. Retrieve the data bits from the the input array, store them in the global `data` array and return a flag on whether an error was detected.
   
**Return value**: None; the decoded data is stored in a global variable.
