/* Author: Xinyi HUANG
 * Date: 30/01/2015
 * Description: Main function to getting keyframe by GetKeyFrame Class
 *              Max duration: 4hours
 * parameter: input.mp4 interval
 */

#include"GetKeyFrame.h"
using namespace StreamphonyVoD;
int main(int argc, char **argv){
	GetKeyFrame g(argv[1],atof(argv[2]));

        // get time & keyframe 
	vector<double> result = g.get_result();

	// print out result
        cout <<"Duration: "<< g.get_time()<< endl;        
        vector<double>::iterator it = result.begin();
        while(it != result.end()){
	    cout << *it << endl;
            ++it;
	}
return 0;
}
