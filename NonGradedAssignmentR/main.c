#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    int i,j=0;
    int id,dept;
    float cgpa;
    srand(time(NULL));

    FILE *fp;
    fp = fopen("nglaData.txt","w");

    for(i=0;i<1000;i++){
        id = 11041 + i;
        dept = (rand()%15) + 1;
        cgpa = (rand()%50) + 50;
        cgpa /= 10;
        fprintf(fp,"%d\t%d\t%f",id,dept,cgpa);
        fprintf(fp,"\n");
    }
    fclose(fp);
    return 0;
}
