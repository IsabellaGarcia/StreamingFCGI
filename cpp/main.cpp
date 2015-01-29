#include"GetKeyFrame.h"
int main(int argc, char **argv){
	GetKeyFrame g(argv[1],atof(argv[2]));
	vector<double> result = g.get_result();
        cout <<"Duration: "<< g.get_time()<< endl;        
 	//print result
        vector<double>::iterator it = result.begin();
        while(it != result.end()){
	    cout << *it << endl;
            ++it;
	}
return 0;
}
