#include <iostream>
#include <fstream>

using namespace std;
int main(){
    fstream fout;
    
    // opens an existing csv file or creates a new file. 
    fout.open("fft_test.csv", ios::out | ios::app); 
    
  
    // Read the input 
    for (int i = 0; i < 50; i++) { 
        for (int i = 0; i < 50; i++) { 
        fout << "" << ", "
             << "" << ", "
             << "" << ", "
             << "" << ", "
             << "" << ", "
             << "" << ", "
             << "\n"; 
        }
    } 
    return 0;

}