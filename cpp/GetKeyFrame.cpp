#include "GetKeyFrame.h"

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
    //get the duration time
    bool duration = true;
    while(fgets(result_buf, BUFSIZE, stream)){
	if(duration==true){
		char *ptr_1;
		ptr_1 = strstr(result_buf, "Duration:");
		const char * split_1 = ",";
		const char * split_2 = ":";
		if(ptr_1!=NULL){
                   char *ptr_2 = strtok(ptr_1, split_1);
		   ptr_2 = strtok(ptr_2, split_2);
		   //get the duration in sec
		   if(ptr_2!=NULL){
			//hours
			ptr_2 = strtok(NULL, split_2);
			string hours(ptr_2);
			_total_time += atoi(hours.c_str())*3600;
		   	//minutes	
			ptr_2 = strtok(NULL, split_2);
                        string minutes(ptr_2);
			_total_time += atoi(minutes.c_str())*60;
			//seconds
			ptr_2 = strtok(NULL, split_2);
			string seconds(ptr_2);
			_total_time += atoi(seconds.c_str());
		   }

		   duration = false;
		}
	}
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
