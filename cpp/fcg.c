#include"fcgi_stdio.h"
//#include<libcpuid.h>
#include <stdlib.h>
#include<unistd.h>
#include<sys/sysinfo.h>
#define MAX 255 
int  main()
{
//for request number
    int count = 0;
//for hostname
    char hostname[MAX];
    gethostname(hostname,MAX);
//for RAM info
    struct sysinfo info;
    if(sysinfo(&info)<0){
	FCGI_printf("%s","sysinfo failed");
	return -1;
    }

/*for CPU info
    if(!cpuid_present()){
	FCGI_printf("CPU doesn't support CPUID\n");
	return -2;
     } 
     struct cpu_raw_data_t raw;
     struct cpu_id_t data;
*/
    while(FCGI_Accept() >= 0){
/*	if(!cpuid_present()){
 *	   FCGI_printf("CPU doesn't support CPUID");
//	}
//	if(cpuid_get_raw_data(&raw)<0){
//		FCGI_printf("Can't get raw data");
//	}
//	if(cpu_identify(&raw, &data)<0){
//		FCGI_printf("Failed\n");
//		FCGI_printf("error%s\n",cpuid_error());
	}*/
        FCGI_printf("Content-type: text/html\r\n"
               "\r\n"
               "<title>FastCGI Hello!</title>"
               "<h1>FastCGI Hello!</h1>"
               "Request number %d running on host <i>%s\n</i>\n"
	       "<p>HostName: %s</p>\n"
	       "<p>Total RAM:%ldkB</p>\n"
	       "<p>Available RAM:%ldkB</p>\n"
	       "<p>Number of Cores: %d</p>\n",
                ++count, getenv("SERVER_NAME"),hostname,info.totalram/1024,info.freeram/1024,sysconf(_SC_NPROCESSORS_ONLN));
		
   }
    return 0;
}

