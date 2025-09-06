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
void displayBits(vector<int> b, int n){
    int width = (int)log10(2*n-1) + 1;
    cout << "Bits: " << endl; 
    for(int i = 1;i <= n;i++){
        cout << "              |";
        for(int j = 2*n-1;j >= 0;j--){
            cout << right << setw(width) << (b[j]>=i?"X":"") << "|";
        }
        cout << endl;
    }
}
int main(){
    int n;
    cout << "Enter the bit size of multiplier and multiplicand: ";
    cin >> n;
    int width = (int)log10(2*n-1) + 1;
    std::vector<int> b;
    std::vector<int> b_;
    std::vector<int> ha;
    std::vector<int> fa;
    int flag,stage;
    stage = 0;
    for(int i = 0;i < 2*n;i++){
        if(i == 0)  b.push_back(0);
        else b.push_back(min(i,2*n-i));
        b_.push_back(0);
        ha.push_back(0);
        fa.push_back(0);
    }
    reverse(b.begin(),b.end());
    // ----- Wallace Tree -----
    // do{
    //     stage++;
        // flag = 0;
        // for(int i = 0;i < 2*n;i++){
        //     if(flag == 0 && b[i] == 3){
        //         flag = 1;
        //         ha[i] = 1;
        //         fa[i] = 0;if(b[i] > dj){
                
    //}
        //     }
        //     else if(flag){
        //         if(b[i] == 2 && i < 2*n-1){
        //             if(b[i+1] == 1)ha[i] = 0;
        //             else ha[i] = 1;
        //         }
        //         else 
        //             ha[i] = (b[i]%3)/2;
        //         fa[i] = b[i]/3;
        //     }
        //     else{
        //         ha[i] = 0;
        //         fa[i] = 0;
        //     }
        // }
        // outputStage(b,ha,fa,n,stage);
        // for(int i = 0;i < 2*n-1;i++){
        //     b[i] -= (2*fa[i] + ha[i]);
        //     b[i+1] += ha[i] + fa[i];
        // }
        // flag = 1;
        // for(int i = 0;i < 2*n-1;i++){
        //     if(b[i] > 2) flag = 0;
        // }
        
    // }while(flag == 0 && stage < 20);
    // ------------------------
    // ----- Dadda Tree -----
    vector <int> dj;
    int temp = 2;
    int j;
    for(j = 0;temp<n;j++){
        dj.push_back(temp);
        temp = (int)floor(1.5*temp);
    }    
    j--;
    cout << "j = " << j << ", dj = " << dj[j] << endl;
    for(int i = j;i >= 0;i--){
        copy(b.begin(),b.end(),b_.begin());
        // displayBits(b_,n);
        for(int k = 0;k < 2*n-1;k++){
            if(b_[k] > dj[i]){
                int res = b_[k] - dj[i];
                fa[k] = res/2;
                ha[k] = res%2;
            }
            else{
                fa[k] = 0;
                ha[k] = 0;
            }
            b_[k] = b_[k] - (2*fa[k] + ha[k]);
            b_[k+1] = b_[k+1] + fa[k] + ha[k];
        }
        outputStage(b,ha,fa,n,stage);
        copy(b_.begin(),b_.end(),b.begin());
        stage++;
    }
    // ----------------------
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