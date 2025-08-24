#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>
#include <algorithm>
using namespace std;
void outputStage(std::vector<int> b, std::vector<int> ha, std::vector<int> fa, int n, int stage){
    int width = (int)log10(2*n-1) + 1;
    cout << "Stage: " << stage << endl;
    cout << "Weights:      |";
    for(int i = 2*n-1;i >= 0;i--){
        cout << right << setw(width) << i << "|";
    }
    cout << endl;
    cout << "Bits(Count):  |";
    for(int i = 2*n-1;i >= 0;i--){
        cout << right << setw(width) << b[i] << "|";
    }
    cout << endl;
    cout << "Bits: " << endl; 
    for(int i = 1;i <= n;i++){
        cout << "              |";
        for(int j = 2*n-1;j >= 0;j--){
            cout << right << setw(width) << (b[j]>=i?"X":"") << "|";
        }
        cout << endl;
    }

    cout << endl;
    cout << "Half-Adders:  |";
    for(int i = 2*n-1;i >= 0;i--){
        cout << right << setw(width) << ha[i] << "|";
    }
    cout << endl;
    cout << "Full-Adders:  |";
    for(int i = 2*n-1;i >= 0;i--){
        cout << right << setw(width) << fa[i] << "|";
    }
    cout << endl;
}
int main(){
    int n;
    cout << "Enter the bit size of multiplier and multiplicand: ";
    cin >> n;
    int width = (int)log10(2*n-1) + 1;
    std::vector<int> b;
    std::vector<int> ha;
    std::vector<int> fa;
    int flag,stage;
    stage = 0;
    for(int i = 0;i < 2*n;i++){
        if(i == 0)  b.push_back(0);
        else b.push_back(min(i,2*n-i));
        ha.push_back(0);
        fa.push_back(0);
    }
    reverse(b.begin(),b.end());
    do{
        stage++;
        flag = 0;
        for(int i = 0;i < 2*n;i++){
            if(flag == 0 && b[i] == 3){
                flag = 1;
                ha[i] = 1;
                fa[i] = 0;
            }
            else if(flag){
                if(b[i] == 2 && i < 2*n-1){
                    if(b[i+1] == 1)ha[i] = 0;
                    else ha[i] = 1;
                }
                else ha[i] = (b[i]%3)/2;
                fa[i] = b[i]/3;
            }
            else{
                ha[i] = 0;
                fa[i] = 0;
            }
        }
        outputStage(b,ha,fa,n,stage);
        for(int i = 0;i < 2*n-1;i++){
            b[i] -= (2*fa[i] + ha[i]);
            b[i+1] += ha[i] + fa[i];
        }
        flag = 1;
        for(int i = 0;i < 2*n-1;i++){
            if(b[i] > 2) flag = 0;
        }

    }while(flag == 0 && stage < 20);
    cout << "Final Bit Arrangement before addition: " << endl;
    for(int i = 1;i <= n;i++){
        cout << "              |";
        for(int j = 2*n-1;j >= 0;j--){
            cout << right << setw(width) << (b[j]>=i?"X":"") << "|";
        }
        cout << endl;
    }
    return 0;
}