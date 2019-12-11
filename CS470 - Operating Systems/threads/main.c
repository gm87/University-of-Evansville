#include "buffer.h"
#include <stdio.h> // input/output
#include <stdlib.h> 
#include <string.h> // string library
#include <pthread.h> // pthread library
#include <semaphore.h> // semaphore library
#include <unistd.h> // sleep()
#include "main.h"

int sleeptime;
sem_t isEmpty;
sem_t isFull;
buffer_item buffer[BUFFER_SIZE];
pthread_mutex_t inputMutex;
pthread_mutex_t outputMutex;

int main(int argc, char *argv[]) {
  /* 1. Get command line arguments argv[1], argv[2], and argv[3] */
  
  if (argc != 4)
    {
      printf ("Usage: %s sleep ProducerThreads ConsumerThreads \n", argv[0]);
      return -1;
    }
  sleeptime = atoi(argv[1]);
  int producerThreads = atoi(argv[2]);
  int consumerThreads = atoi(argv[3]);
  
  /* 2. Initialize buffer */
  for (int i=0; i<BUFFER_SIZE; i++)
    buffer[i] = -1;

  // initialize semaphores
  sem_init(&isEmpty, 0, BUFFER_SIZE);
  sem_init(&isFull, 0, 0);
  
  /* 3. Create producer thread(s) */
  pthread_t producerThreadArray[BUFFER_SIZE];
  for (int i=0; i<producerThreads; i++) {
    if (pthread_create(&producerThreadArray[i], NULL, producer, (void *) (intptr_t) i)) {
      printf("Error in pthread_create for producers.\n");
      return -1;
    }
    else
      printf("Created producer thread: %d\n", i);
  }
  
  /* 4. Create consumer thread(s) */
    pthread_t consumerThreadArray[BUFFER_SIZE];
  for (int i=0; i<consumerThreads; i++) {
    if (pthread_create(&consumerThreadArray[i], NULL, consumer, (void *) (intptr_t) i)) {
      printf("Error in pthread_create for consumers.\n");
      return -1;
    }
    else
      printf("Created consumer thread: %d\n", i);
  }
  
  /* 5. Sleep */
  sleep(sleeptime);
  
  /* 6. Exit */
  pthread_exit(NULL);
  return 0;
}

void *producer(void *param){
  buffer_item item;
  int num = (intptr_t)param;

  while(1) {
    /* sleep for a random period of time */
    sleep(rand() % sleeptime);
    /* generate a random number */
    item = rand();

    // get mutex lock to output to console
    pthread_mutex_lock(&outputMutex);

    printf("Producer %d waiting on empty.\n", num);

    // give up mutex lock to output to console
    pthread_mutex_unlock(&outputMutex);

    // wait for isEmpty signal
    sem_wait (&isEmpty);

    // get buffer input and console output mutex locks
    pthread_mutex_lock(&inputMutex);

    pthread_mutex_lock(&outputMutex);
    
    if (insert_item(item)) {
      printf("report error condition\n");
      pthread_mutex_unlock(&outputMutex);
    }
    else {
      printf("producer %d produced %d\n", num, item);
      pthread_mutex_unlock(&outputMutex);
      sem_post(&isFull); // signal full
    }

    pthread_mutex_unlock(&outputMutex); // give up locks
    pthread_mutex_unlock(&inputMutex);
    
  }
}

void *consumer(void * param){
  buffer_item item;
  int num = (intptr_t)param;
  while(1) {
    /* sleep for a random period of time */
    sleep(rand() % sleeptime);
    /* generate a random number */
    item = rand();
    
    // get mutex lock to print to console
    pthread_mutex_lock(&outputMutex);
    
    printf("Consumer %d waiting on full.\n", num);
    
    // give up mutex lock to print to console
    pthread_mutex_unlock(&outputMutex);
    
    // wait for isFull signal
    sem_wait (&isFull);
    
    // get console output and buffer input mutex locks
    pthread_mutex_lock(&outputMutex);
    
    pthread_mutex_lock(&inputMutex);
    
    if (remove_item(&item)) {
      printf("report error condition\n");
      pthread_mutex_unlock(&outputMutex);
    }
    else {
      printf("consumer %d consumed %d\n", num, item);
      pthread_mutex_unlock(&outputMutex);
      sem_post(&isEmpty); // signal isEmpty
    }
    
    pthread_mutex_unlock(&outputMutex); // give up mutex locks
    pthread_mutex_unlock(&inputMutex);
  }
}

int insert_item(buffer_item item) {
  /* insert item into buffer
     return 0 if successful, otherwise
     return -1 indicating error */
  int i = 0;
  // find first empty spot
  while ((buffer[i] != -1) && (i < BUFFER_SIZE))
    i++;
  if (i==BUFFER_SIZE) {// if i is BUFFER_SIZE, buffer is full
    return -1;
  }
  else
    buffer[i] = item; // otherwise, place item at index i
  return 0;
}

int remove_item(buffer_item *item) {
  /* remove an object from buffer
     placing it in item
     return 0 if successful, otherwise
     return -1 indicating error */
  int i = 0;
  // find first nonempty space
  while ((buffer[i] == -1) && (i < BUFFER_SIZE))
    i++;
  if (i==BUFFER_SIZE) {// if i is BUFFER_SIZE, buffer is empty 
    return -1;
  }
  else {
    *item = buffer[i]; // 
    buffer[i] = -1; // remove item from buffer
  }
  return 0;
}
