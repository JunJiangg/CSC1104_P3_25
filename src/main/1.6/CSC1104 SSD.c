#include <stdio.h>
#include <stdlib.h>

/*Task: Map Virtual Memory Address to Physical Memory Address using a Paging Table*/

/*Given:                                  */
/*Virtual Page Number: 5-bits             */
/*Virtual Page Offset (Page Size): 8-bits */
/*Physical Frame Number: 8-bits           */ //dont put 0s

int main()
{
    int paging_table[32] = {             //Declare Array  with 32 values 
        9, 1, 14, 10, -1, 13, 8, 15,      //Page Number 0 to 7
        -1, 30, 18, -1, 21, 27, -1, 22,     //Page Number 8 to 15
        29, -1, 19, 26, 17, 25, -1, 31,    //Page Number 16 to 23
        20, -1, 5, 4, -1, -1, 3, 2          //Page Number 24 to 31
    };


    char vpn_binary[5], vpo_binary[9];                    //Declare Virtual Page Number
    printf("\nEnter 5-bit Virtual Page Number: ");        //User Input: 5-bit digits for Virtual Memory Page Number
    scanf("%s", vpn_binary);                              /*Stores user input in variable vpn_binary in string format*/
   
    printf("\nEnter 8-bit Virtual Page Offset: ");        //User Input: 8-bit digit for Virtual Page Offset
    scanf("%s", vpo_binary);                              /*Stores user input in variable vpo_binary in string format*/

                                                          //Converts Virtual Page Number (string) into a decimal long integer and store in page_number
    int page_number = strtol(vpn_binary, NULL, 2);        //Converts vpn_binary (string) into a long integer and store in page_number

    int frame_number = paging_table[page_number];        //Pages Virtual Memory Address to Physical Frame Number
    
    printf("\nThe virtual memory address you keyed in is: %.5s %.4s %.4s ", //Prints out Virtual Memory Address (13-bit format)
           vpn_binary, vpo_binary, vpo_binary + 4);
    

    if (frame_number == 0) {                                           //Prints an Error Message if frame number is 0 (doesn't exist)
        printf("\nError! This page is not in physical memory.");
    } 
    
    else {
        char frame_bin[6];                                 //Declare Array to store the physical frame number as a 5-bit binary string 
        
        for (int i = 4; i >= 0; i--) {                   //For Loop that executes where 4 is subtracted by 1 each loop until it is 0. Fills the binary digit from left to right in the array.
            frame_bin[i] = (frame_number % 2) + '0';     //frame_bin[4] Frame Number % 2 gives the last binary digit (0 or 1) + 0 turns it into a character "0" or "1".
            frame_number /= 2;                           //Frame Number /= 2 removes the last binary digit (divide by 2)
        }

        frame_bin[5] = '\0';   //C strings need a \0 at the end to mark the end of the string.

        printf("\nThe physical memory address to be accessed after paging is: %.5s %.4s %.4s",
               frame_bin, vpo_binary, vpo_binary + 4);
    }

    return 0;

}

