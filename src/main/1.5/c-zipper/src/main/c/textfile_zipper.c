#include <limits.h>
#ifndef PATH_MAX
#define PATH_MAX 4096
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <zip.h>
#include <time.h>  // For timing measurements

// Buffer size for reading file data during compression
#define BUF_SZ 2048

/**
 *   1. Find the last occurrence of '.' in the filename using strrchr()
 *   2. If no dot found or dot is at the beginning, return 0 (not a text file)
 *   3. Convert characters after the dot to lowercase for case-insensitive comparison
 *   4. Check if the three characters spell 't', 'x', 't'
 *   5. Verify that the string ends after 'txt' (no extra characters)
 */
static int has_txt_extension_ci(const char *name) {
    const char *dot = strrchr(name, '.');
    if (!dot || dot == name) return 0;
    return (tolower((unsigned char)dot[1]) == 't' &&
            tolower((unsigned char)dot[2]) == 'x' &&
            tolower((unsigned char)dot[3]) == 't' &&
            dot[4] == '\0');
}

/**
 Main entry point for the text file zipper program
 *   1. Get the current working directory
 *   2. Construct the path to the resources directory
 *   3. Open the resources directory for reading
 *   4. Create a ZIP file for output
 *   5. Iterate through all files in the resources directory
 *   6. For each file with a .txt extension:
 *      a. Validate that it's a regular file (not a directory)
 *      b. Add it to the ZIP archive
 *      c. Increment the counter
 *   7. Close the directory and ZIP file
 *   8. Print summary statistics
 */
int main(void) {
    // Start timing
    clock_t start_time = clock();
    struct timespec start_real;
    clock_gettime(CLOCK_MONOTONIC, &start_real);
    
    printf("==============================================\n");
    printf("    C Text File Zipper - Performance Test\n");
    printf("==============================================\n\n");
    
    // STEP 1: Get Current Working Directory
    char cwd[PATH_MAX];
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd() error");
        return 1;
    }
    printf("Current working directory: %s\n", cwd);

    // STEP 2: Construct Path to Resources Directory
    const char *resourceSubDir = "../resources";
    char resource_dir[PATH_MAX];
    int n = snprintf(resource_dir, sizeof(resource_dir), "%s/%s", cwd, resourceSubDir);
    if (n < 0 || n >= (int)sizeof(resource_dir)) {
        fprintf(stderr, "Path too long for resource_dir\n");
        return 1;
    }

    printf("Resource directory: %s\n", resource_dir);

    // STEP 3: Open Resources Directory
    DIR *dir = opendir(resource_dir);
    if (!dir) {
        perror("opendir");
        return 1;
    }

    // STEP 4: Create ZIP Archive for Output
    int zip_err = 0;
    const char *zip_name = "../output/text_file.zip";
    
    // ZIP_CREATE: create if doesn't exist
    // ZIP_TRUNCATE: truncate if exists (overwrite)
    zip_t *za = zip_open(zip_name, ZIP_CREATE | ZIP_TRUNCATE, &zip_err);
    if (!za) {
        fprintf(stderr, "Failed to create zip archive\n");
        closedir(dir);
        return 1;
    }

    // STEP 5: Directory Iteration and File Processing
    struct dirent *de;           // Directory entry
    struct stat st;              // File statistics (to check if it's a regular file)
    char path[PATH_MAX];         // Full path to the current file
    int count = 0;               // Counter for added files

    // Loop through all entries in the directory
    while ((de = readdir(dir)) != NULL) {
        // Check if the filename has a .txt extension (case-insensitive)
        if (has_txt_extension_ci(de->d_name)) {
            // Construct the full path to the file
            int m = snprintf(path, sizeof(path), "%s/%s", resource_dir, de->d_name);
            if (m < 0 || m >= (int)sizeof(path)) {
                fprintf(stderr, "Path too long for file %s\n", de->d_name);
                continue;
            }

            // Check if the path is a regular file (not a directory or special file)
            if (stat(path, &st) == 0 && S_ISREG(st.st_mode)) {
                // Create a ZIP data source from the file
                zip_source_t *src = zip_source_file(za, path, 0, -1);
                if (!src) {
                    fprintf(stderr, "zip_source_file failed for %s\n", de->d_name);
                    continue;
                }
                
                // Add the file to the ZIP archive with UTF-8 encoding
                if (zip_file_add(za, de->d_name, src, ZIP_FL_ENC_UTF_8) < 0) {
                    zip_source_free(src);
                    fprintf(stderr, "zip_file_add failed for %s\n", de->d_name);
                    continue;
                }
                
                // Successfully added file
                count++;
                printf("Added: %s\n", de->d_name);
            }
        }
    }

    // STEP 6: Cleanup and Summary
    // Close the directory handle
    // Close and finalize the ZIP archive
    closedir(dir);
    zip_close(za);    
    
    // End timing
    clock_t end_time = clock();
    struct timespec end_real;
    clock_gettime(CLOCK_MONOTONIC, &end_real);
    
    // Calculate elapsed times
    double cpu_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC * 1000.0;  // in milliseconds
    double real_time = (end_real.tv_sec - start_real.tv_sec) * 1000.0 + 
                       (end_real.tv_nsec - start_real.tv_nsec) / 1000000.0;  // in milliseconds
    
    // Print summary information
    printf("\n==============================================\n");
    printf("             RESULTS SUMMARY\n");
    printf("==============================================\n");
    printf("Files processed: %d .txt files\n", count);
    printf("Output archive:  %s\n", zip_name);
    printf("\n--- Performance Metrics ---\n");
    printf("CPU Time:        %.3f ms\n", cpu_time);
    printf("Real Time:       %.3f ms\n", real_time);
    printf("Language:        C\n");
    printf("Compiler:        GCC with -O2 optimization\n");
    printf("==============================================\n");
    
    return 0;
}