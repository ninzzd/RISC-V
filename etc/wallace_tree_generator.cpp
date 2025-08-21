#include <iostream>
#include <vector>
#include <cmath>
using namespace std;
int main(){
    int n;
    cout << "Enter the bit size of multiplier and multiplicand: ";
    cin >> n;
    int stage = 1;
    std::vector<int> bits_per_column;
    std::vector<int> ha_count;
    std::vector<int> fa_count;
    for(int i = 0;i < 2*n-1;i++){
        bits_per_column.push_back(min(i+1,2*n-i-1));
        ha_count.push_back(0);
        fa_count.push_back(0);
        cout << i << " ";
    }
    int flag;
    cout << endl;
    do{
        cout << "--------------------" << endl;
        cout << "Stage: " << stage << endl;
        cout << "Initial bit count: " << endl;
        for(int i = 0;i < 2*n-1;i++){
            cout << bits_per_column[i] << " ";
        }
        flag = 0;
        for(int i = 0;i < 2*n-1;i++){
            int fa,ha;
            if(!flag){
                if(bits_per_column[i] >= 3){
                    flag = 1;
                    fa = (bits_per_column[i] - 1)/3;
                    ha = (bits_per_column[i] - 3*fa - 1)/2;
                }
                else{
                    fa = ha = 0;
                }
            }
            else{
                fa = bits_per_column[i]/3;
                ha = (bits_per_column[i] - 3*fa)/2;
                if(stage == 1 && i == 2*n-3)
                    ha = 0;
            }
            fa_count[i] = fa;
            ha_count[i] = ha;
        }
        cout << "\nNo. of half adders:" << endl; 
        for(int i = 0;i < 2*n-1;i++){
            cout << "(" << i  << ")" << "->" << ha_count[i] << " ";
        }
        cout << "\nNo. of full adders:" << endl; 
        for(int i = 0;i < 2*n-1;i++){
            cout << "(" << i  << ")" << "->" << fa_count[i] << " ";
        }
        for(int i = 0;i < 2*n-1;i++){
            bits_per_column[i] -= (2*fa_count[i] + ha_count[i]);
            if(i == 2*n-2 && (fa_count[i] + ha_count[i]) != 0)
                bits_per_column.push_back(fa_count[i] + ha_count[i]);
            else
                bits_per_column[i+1] +=  (fa_count[i] + ha_count[i]);
        }
        cout << "\nBit count after compression:" << endl; 
        for(int i = 0;i < (int)bits_per_column.size();i++){
            cout << bits_per_column[i] << " ";
        }
        stage++;
        cout << "\n--------------------" << endl;
        flag = 0;
        for(int i = 0;i < (int)bits_per_column.size();i++){
            if(bits_per_column[i] > 2){
                flag = 1;
                break;
            }
        }
    }while(flag == 1 && stage<=10);
    return 0;
}