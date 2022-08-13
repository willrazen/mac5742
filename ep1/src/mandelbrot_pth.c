#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/************ START CHANGES ************/

#include <string.h>
#include <pthread.h>

#ifndef NUM_THREADS
#define NUM_THREADS 16
#endif

#ifndef BENCH
#define BENCH 0
#endif

/************* END CHANGES *************/

double c_x_min;
double c_x_max;
double c_y_min;
double c_y_max;

double pixel_width;
double pixel_height;

int iteration_max = 200;

int image_size;
unsigned char **image_buffer;

int i_x_max;
int i_y_max;
int image_buffer_size;

int gradient_size = 16;
int colors[17][3] = {
                        {66, 30, 15},
                        {25, 7, 26},
                        {9, 1, 47},
                        {4, 4, 73},
                        {0, 7, 100},
                        {12, 44, 138},
                        {24, 82, 177},
                        {57, 125, 209},
                        {134, 181, 229},
                        {211, 236, 248},
                        {241, 233, 191},
                        {248, 201, 95},
                        {255, 170, 0},
                        {204, 128, 0},
                        {153, 87, 0},
                        {106, 52, 3},
                        {16, 16, 16},
                    };

void allocate_image_buffer(){
    int rgb_size = 3;
    image_buffer = (unsigned char **) malloc(sizeof(unsigned char *) * image_buffer_size);

    for(int i = 0; i < image_buffer_size; i++){
        image_buffer[i] = (unsigned char *) malloc(sizeof(unsigned char) * rgb_size);
    };
}

/************ START CHANGES ************/

void init(int argc, char *argv[]){

    if(argc == 3){
        sscanf(argv[2], "%d", &image_size);
        if(!strcmp(argv[1], "full")){
            c_x_min = -2.5;
            c_x_max = 1.5;
            c_y_min = -2.0;
            c_y_max = 2.0;
        } else
        if(!strcmp(argv[1], "seahorse")){
            c_x_min = -0.8;
            c_x_max = -0.7;
            c_y_min = 0.05;
            c_y_max = 0.15;
        } else
        if(!strcmp(argv[1], "elephant")){
            c_x_min = 0.175;
            c_x_max = 0.375;
            c_y_min = -0.1;
            c_y_max = 0.1;
        } else
        if(!strcmp(argv[1], "spiral")){
            c_x_min = -0.188;
            c_x_max = -0.012;
            c_y_min = 0.554;
            c_y_max = 0.754;
        } else {
            exit(-1);
        };
    } else
    if(argc < 6){
        printf("usage: ./mandelbrot_seq c_x_min c_x_max c_y_min c_y_max image_size\n");
        printf("examples with image_size = 11500:\n");
        printf("    Full Picture:         ./mandelbrot_seq -2.5 1.5 -2.0 2.0 11500\n");
        printf("    Seahorse Valley:      ./mandelbrot_seq -0.8 -0.7 0.05 0.15 11500\n");
        printf("    Elephant Valley:      ./mandelbrot_seq 0.175 0.375 -0.1 0.1 11500\n");
        printf("    Triple Spiral Valley: ./mandelbrot_seq -0.188 -0.012 0.554 0.754 11500\n");
        exit(0);
    }
    else{
        sscanf(argv[1], "%lf", &c_x_min);
        sscanf(argv[2], "%lf", &c_x_max);
        sscanf(argv[3], "%lf", &c_y_min);
        sscanf(argv[4], "%lf", &c_y_max);
        sscanf(argv[5], "%d", &image_size);
    };

    i_x_max           = image_size;
    i_y_max           = image_size;
    image_buffer_size = image_size * image_size;

    pixel_width       = (c_x_max - c_x_min) / i_x_max;
    pixel_height      = (c_y_max - c_y_min) / i_y_max;
}

/************* END CHANGES *************/

void update_rgb_buffer(int iteration, int x, int y){
    int color;

    if(iteration == iteration_max){
        image_buffer[(i_y_max * y) + x][0] = colors[gradient_size][0];
        image_buffer[(i_y_max * y) + x][1] = colors[gradient_size][1];
        image_buffer[(i_y_max * y) + x][2] = colors[gradient_size][2];
    }
    else{
        color = iteration % gradient_size;

        image_buffer[(i_y_max * y) + x][0] = colors[color][0];
        image_buffer[(i_y_max * y) + x][1] = colors[color][1];
        image_buffer[(i_y_max * y) + x][2] = colors[color][2];
    };
}

void write_to_file(){
    FILE * file;
    char * filename               = "output.ppm";
    char * comment                = "# ";

    int max_color_component_value = 255;

    file = fopen(filename,"wb");

    fprintf(file, "P6\n %s\n %d\n %d\n %d\n", comment,
            i_x_max, i_y_max, max_color_component_value);

    for(int i = 0; i < image_buffer_size; i++){
        fwrite(image_buffer[i], 1 , 3, file);
    };

    fclose(file);
}

/************ START CHANGES ************/

void *compute_mandelbrot(void *threadid){
    long t;
    t = (long) threadid;

    double chunk_size;
    double remainder;

    double z_x;
    double z_y;
    double z_x_squared;
    double z_y_squared;
    double escape_radius_squared = 4;

    int iteration;
    int i_x;
    int i_y;
    int px;
    int px_start;
    int px_end;

    double c_x;
    double c_y;

    //Break image in appropriately sized chunks for each thread
    chunk_size = image_buffer_size / NUM_THREADS;
    remainder = image_buffer_size % NUM_THREADS;
    if(t >= remainder){
        px_start = t * chunk_size + remainder;
        px_end = (t + 1) * chunk_size + remainder - 1;
    }
    else{
        px_start = t * (chunk_size + 1);
        px_end = (t + 1) * (chunk_size + 1) - 1;
    };

    //Loop through pixels in thread's chunk
    for(px = px_start; px <= px_end; px++){
        //Convert to x y coordinates
        i_x = px % i_y_max;
        i_y = px / i_y_max;

        //Obtain true coordinates
        c_x = c_x_min + i_x * pixel_width;
        c_y = c_y_min + i_y * pixel_height;
        if(fabs(c_y) < pixel_height / 2){
            c_y = 0.0;
        };

        //Initialize z
        z_x = 0.0;
        z_y = 0.0;
        z_x_squared = 0.0;
        z_y_squared = 0.0;

        //Check divergence (approximated)
        for(iteration = 0;
            iteration < iteration_max && \
            ((z_x_squared + z_y_squared) < escape_radius_squared);
            iteration++){
            z_y = 2 * z_x * z_y + c_y;
            z_x = z_x_squared - z_y_squared + c_x;
            z_x_squared = z_x * z_x;
            z_y_squared = z_y * z_y;
        };

        //Update image
        //Note that no mutex is needed because each index is only accessed once
        if(!BENCH) update_rgb_buffer(iteration, i_x, i_y);
    };
    pthread_exit(NULL);
}

int main(int argc, char *argv[]){
    pthread_t threads[NUM_THREADS];
    pthread_attr_t attr;
    int rc;
    long t;
    void *status;

    init(argc, argv);
    if(!BENCH) allocate_image_buffer();

    //Create threads
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    for(t = 0; t < NUM_THREADS; t++){
        rc = pthread_create(&threads[t], NULL, compute_mandelbrot, (void *) t);
        if(rc){
            printf("ERROR; return code from pthread_create() is %d\n", rc);
            exit(-1);
        };
    };

    //Join threads
    pthread_attr_destroy(&attr);
    for(t = 0; t < NUM_THREADS; t++){
        rc = pthread_join(threads[t], &status);
        if(rc){
            printf("ERROR; return code from pthread_join() is %d\n", rc);
            exit(-1);
        };
    };
    
    if(!BENCH) write_to_file();
    pthread_exit(NULL);
}

/************* END CHANGES *************/
