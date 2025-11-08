#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static void trim(char *s){size_t n=strlen(s);while(n&&isspace((unsigned char)s[n-1]))s[--n]=0;}
static int blank(const char*s){for(;*s;s++)if(!isspace((unsigned char)*s))return 0;return 1;}
static void lower(char*s){for(;*s;s++)*s=(char)tolower((unsigned char)*s);}

static double get_num(const char*p,int want_int,long long*out_i,double*out_d){
    char s[128];
    for(;;){
        fputs(p,stdout);fflush(stdout);
        if(!fgets(s,sizeof s,stdin))continue; trim(s);
        if(blank(s)){puts("Invalid. Please enter a number.");continue;}
        char*e; double x=strtod(s,&e);
        if(e==s||*e){puts(want_int?
          "Invalid. Please enter an integer number only.\n":
          "Invalid. Please enter a numeric value (e.g., 1.5, 2, 0.25).\n");continue;}
        if(want_int){long long v=(long long)x; if(out_i)*out_i=v;if(out_d)*out_d=v;return v;}
        if(out_d)*out_d=x;return x;
    }
}

static double read_clock_cycle_seconds(void){
    double v=get_num("Enter clock cycle time value (e.g., 2.5): ",0,NULL,NULL);
    const struct{char*u;double k;}U[]={{"s",1},{"ms",1e-3},{"us",1e-6},{"ns",1e-9},{"ps",1e-12}};
    char s[32];
    for(;;){
        fputs("Enter unit (s / ms / us / ns / ps): ",stdout);fflush(stdout);
        if(!fgets(s,sizeof s,stdin))continue;trim(s);lower(s);
        for(size_t i=0;i<5;i++)if(!strcmp(s,U[i].u))return v*U[i].k;
        puts("Invalid Unit. Please enter one of: s, ms, us, ns, ps.\n");
    }
}

static int choose_output(void){
    char s[8];
    for(;;){
        puts("\nSelect output:\n  1) Total clock cycles\n  2) Total execution time\n  3) Both");
        fputs("Enter option number (1/2/3): ",stdout);fflush(stdout);
        if(!fgets(s,sizeof s,stdin))continue;trim(s);
        if(!strcmp(s,"1")||!strcmp(s,"2")||!strcmp(s,"3"))return atoi(s);
        puts("Invalid input. Please enter 1, 2, or 3.\n");
    }
}

static void print_commas(long long v){
    char b[64];snprintf(b,sizeof b,"%lld",v);
    int n=strlen(b),neg=(b[0]=='-');char o[64];int j=0,c=0;
    for(int i=n-1;i>=neg;i--){o[j++]=b[i];if(++c%3==0&&i!=neg)o[j++]=',';}
    if(neg)o[j++]='-';for(int a=0,bj=j-1;a<bj;a++,bj--){char t=o[a];o[a]=o[bj];o[bj]=t;}
    o[j]=0;fputs(o,stdout);
}

int main(void){
    puts("=== Execution Time Calculator ===");
    long long n; get_num("Enter number of instruction types: ",1,&n,NULL);
    double tot=0;
    for(int i=0;i<n;i++){
        char p[64]; long long c; double f;
        sprintf(p,"Enter instruction count for type %d: ",i+1);
        get_num(p,1,&c,NULL);
        sprintf(p,"Enter CPI for type %d: ",i+1);
        get_num(p,0,NULL,&f);
        tot+=c*f;
    }
    puts("\nNow enter the clock cycle time:");
    double clk=read_clock_cycle_seconds(),time=clk*tot;
    int opt=choose_output();
    puts("\n--- Results ---");
    if(opt==1||opt==3){fputs("Total clock cycles = ",stdout);
        print_commas((long long)(tot+0.5));putchar('\n');}
    if(opt==2||opt==3){
        double t=time;
        if(t>=1)printf("Total execution time = %.6f s\n",t);
        else if(t>=1e-3)printf("Total execution time = %.6f ms\n",t*1e3);
        else if(t>=1e-6)printf("Total execution time = %.6f \xC2\xB5s\n",t*1e6);
        else if(t>=1e-9)printf("Total execution time = %.6f ns\n",t*1e9);
        else printf("Total execution time = %.6f ps\n",t*1e12);
    }
    return 0;
}
