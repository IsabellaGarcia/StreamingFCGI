/* Author: Xinyi HUANG
 * Date: 30/01/2015
 * Description: Class implementation for getting keyframe
 */
#include "GetKeyFrame.h"
using namespace StreamphonyVoD;
GetKeyFrame::GetKeyFrame(const char* url, int sec){
     //initialization 
     _start = "ffprobe -show_frames -select_streams v -read_intervals ";
     _interval = sec;
     _total_time = 0;
     if(!get_info(url)){
	//cout <<"\nSuccessfully get the result" << endl;
     }
}

int GetKeyFrame::get_info(const char* url){
    FILE *stream;
    int rc = 0;

    //construct command
    char command[BUFSIZE];
    strcpy(command, _start.c_str());
    //for read_intervals
    int start = _interval;
    while(start < MAXTIME){
         char temp[10];
   	 sprintf(temp, "%d", start);
    
    	strcat(command,temp);
   	strcat(command,"%+#1,");
    	start+=_interval;
    }
    strcat(command, "14400%+#1 ");
    strcat(command, url);
    strcat(command, " 2>&1");

    //get output from command
    stream = popen(command,"r");
    if(!stream){
	cerr << "popen failed" << endl;
	return -1;
    }

    //get keyframes
    char result_buf[BUFSIZE];
    string str = "pkt_pts_time=";
    int length = str.length();

    bool duration = true;

    while(fgets(result_buf, BUFSIZE, stream)){
	//get duration time
	if(duration==true){
		char *ptr_1;
		const char * split_1 = ",";
		const char * split_2 = ":";
		//cout<< result_buf << endl;
		ptr_1 = strstr(result_buf, "Duration:");
		if(ptr_1!=NULL){
		   vector<string> fields;
	           //string s = "a,b,";
	   	   boost::algorithm::split( fields, ptr_1, boost::algorithm::is_any_of( split_1 ) );
	           vector<string> time_fields;
		   boost::algorithm::split( time_fields, fields.at(0), boost::algorithm::is_any_of( split_2 ));
  		   _total_time += atoi(time_fields.at(1).c_str())*3600;
		   _total_time += atoi(time_fields.at(2).c_str())*60;
		   _total_time += atoi(time_fields.at(3).c_str());
		   duration = false;
		}
	}
	//get key frame times
	else{
        	char *ptr;
       		 ptr = strstr(result_buf, str.c_str());
		if(ptr!=NULL){
        	   string str_1(ptr);
	   	   str_1 = str_1.substr(length);
          	    //get pkt_pts_time
	           double t = stod(str_1);
          	   if(_result.size()==0||t!=_result.at(_result.size()-1)){
	      	       _result.push_back(t);
	   	   }
          	   else{
			break;
	  	   } 
	         }
	
        }
}

    //close stream
    rc = pclose(stream);
    if(rc == -1){
 	cerr << "file close failed" << endl;
        return -2;
    }
return 0;

}
int GetKeyFrame::get_time(){
    return _total_time;
}
vector<double> GetKeyFrame::get_result(){
    return _result;
}

GetKeyFrame::~GetKeyFrame(){
}
