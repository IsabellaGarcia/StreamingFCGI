#ifndef GETKEYFRAME_H
#define GETKEYFRAME_H
#include<math.h>
#include<vector>
#include<stdlib.h>
#include<string>
#include<stdio.h>
#include<cstring>
#include<unistd.h>
#include<iostream>
#include<cmath>
using namespace std;

#define BUFSIZE 2048
#define MAXTIME 14400
//namespace StreamphonyVoD{
    class GetKeyFrame{
         public:
	     GetKeyFrame(const char*, int);  //constructor
 	     int get_info(const char*);
	     vector<double> get_result();
	     int get_time();
	     ~GetKeyFrame();            //destructor
	 private:
             char* _request;
	     vector<double> _result;
             string _start;
	     int _interval;
	     int _total_time;
    };
//}
#endif
