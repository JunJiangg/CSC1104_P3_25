// file path: src/task1_5_zip_txt_simple.c
// Build: gcc -std=c11 -Wall -Wextra -O2 src/task1_5_zip_txt_simple.c -lzip -o task1_5_zip_txt_simple
// Run  : ./task1_5_zip_txt_simple

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

#define BUF_SZ 2048   // increased buffer size

static int has_txt_extension_ci(const char *name) {
    const char *dot = strrchr(name, '.');
    if (!dot || dot == name) return 0;
    return (tolower((unsigned char)dot[1]) == 't' &&
            tolower((unsigned char)dot[2]) == 'x' &&
            tolower((unsigned char)dot[3]) == 't' &&
            dot[4] == '\0');
}

int main(void) {
    char cwd[PATH_MAX];
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd() error");
        return 1;
    }
    printf("Current working directory: %s\n", cwd);

    const char *resourceSubDir = "../resources";
    char resource_dir[PATH_MAX];
    int n = snprintf(resource_dir, sizeof(resource_dir), "%s/%s", cwd, resourceSubDir);
    if (n < 0 || n >= (int)sizeof(resource_dir)) {
        fprintf(stderr, "Path too long for resource_dir\n");
        return 1;
    }

    printf("Resource directory: %s\n", resource_dir);

    DIR *dir = opendir(resource_dir);
    if (!dir) {
        perror("opendir");
        return 1;
    }

    int zip_err = 0;
    const char *zip_name = "../output/mytxt.zip";
    zip_t *za = zip_open(zip_name, ZIP_CREATE | ZIP_TRUNCATE, &zip_err);
    if (!za) {
        fprintf(stderr, "Failed to create zip archive\n");
        closedir(dir);
        return 1;
    }

    struct dirent *de;
    struct stat st;
    char path[PATH_MAX];
    int count = 0;

    while ((de = readdir(dir)) != NULL) {
        if (has_txt_extension_ci(de->d_name)) {
            int m = snprintf(path, sizeof(path), "%s/%s", resource_dir, de->d_name);
            if (m < 0 || m >= (int)sizeof(path)) {
                fprintf(stderr, "Path too long for file %s\n", de->d_name);
                continue;
            }

            if (stat(path, &st) == 0 && S_ISREG(st.st_mode)) {
                zip_source_t *src = zip_source_file(za, path, 0, -1);
                if (!src) {
                    fprintf(stderr, "zip_source_file failed for %s\n", de->d_name);
                    continue;
                }
                if (zip_file_add(za, de->d_name, src, ZIP_FL_ENC_UTF_8) < 0) {
                    zip_source_free(src);
                    fprintf(stderr, "zip_file_add failed for %s\n", de->d_name);
                    continue;
                }
                count++;
                printf("Added: %s\n", de->d_name);
            }
        }
    }

    closedir(dir);
    zip_close(za);
    printf("There are %d .txt files and compressed into %s\n", count, zip_name);
    return 0;
}