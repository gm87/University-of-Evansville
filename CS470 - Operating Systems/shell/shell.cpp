#include <iostream> // input/output stream
#include <unistd.h> // fork(), exec(),
#include <string> // c++ string class
#include <vector> // c++ vector class
#include <stdlib.h> // exit()
#include <stdio.h> // perror for fork()
#include <sys/types.h> //
#include <sys/wait.h> // wait()
#include <string.h> // c string class

#define MAX_LINE 80 /* Maximum length command */

char** convert(std::vector<std::string>* stringvec);
void printhistory(std::vector<std::vector<std::string> >vec);
int findInt(char ch);

int main(void)
{
  using namespace std;
  
  vector<vector<string> > history; /* History of Command line arguments */
  char** cargs; // converted command line arguments
  bool should_run = true; /* flag to determine when to exit program */
  vector<string> currentargs; // holds current cmd line arguments
  string input; // input from cin
  string str; // used to create substring from input
  
  while (should_run) {
    bool background = true; // bool if process should run in background or not
    int i = 0;
    currentargs.clear(); // clear current args on every iteration
    cout << "osh>"; // signal user input on every iteration
    getline(cin, input); // get line, including spaces

    if(!input.empty()) { // if input is not empty
      while ((i=input.find(" ")) != string::npos) { // find delimiter in string
	str = input.substr(0, i); // create substring from input
	currentargs.push_back(str); // add argument to currentargs vector
	input.erase(0, i+1); // erase the portion of the input we've parsed
      }
      currentargs.push_back(input); // if no delim found, last command so
                                    // push back remaining input
    }
    
    for (i=0; i<currentargs.size(); i++) { // check if arguments include &
      if (currentargs.at(i) == "&") // if it does,
        background = false;         // run the command in the background
    }
    
    if (currentargs.at(0) == "exit") // if user entered "exit"
      exit(0);
    else if (currentargs.at(0) == "!!") { // !!, redo last command
      if (history.empty()) // check if history is empty, if it is
	cout << "History is empty." << endl; // print an error message
      else
	currentargs = history.at(0); // otherwise, set current args to most
                                     // recent history
    }// end of else if(currentargs.at(0) == "!!")
    else if (currentargs.at(0)[0] == '!') { // !, redo specified command
      if (currentargs.at(0)[1] == NULL) // if no specified int,
	cout << "USAGE: !n" << endl; // print an error message
      else {
	int n = findInt(currentargs.at(0)[1]); // in lieu of c++11's stoi,
	                                       // find int
	currentargs = history.at(history.size() - n); // set current args to
	                                       // specified history
      }
    } // end of else if(currentargs.at(0)[0] == '!')
    else if (currentargs.at(0) == "history") { // if user entered "history"
      printhistory(history); // print history including order to cmd line
    }
    cargs = convert(&currentargs); // convert the vector of strings to a char**
    
    pid_t pid;
    pid = fork();
    
    if (pid<0) { // check if fork failed, if it did
      cout << "Fork failed." << endl; // print error message and
      exit(1); // exit the program
    }
    else if (pid==0){ // child process
      if (background) { // check if process should run in background
	pid = fork();
	if (pid < 0){ // check if fork failed, if it did
	  cout << "Fork failed." << endl; // print error message and
	  exit(1); // exit the program
	}
	else if (pid==0) {
	  if(execvp(cargs[0], cargs)<0 && currentargs.at(0)!="history"){
	    cout << "Unknown command" << endl; // if execvp returns, something
	    exit(0);                           // went wrong
	  }
	}
	else {
	  for (int i=0; i<currentargs.size(); i++)
	    delete [] cargs[i]; // free memory
	  delete [] cargs; // free memory
	  exit(0); // terminate child
	}
      } // end of if(background)
      else {
	if(execvp(cargs[0], cargs)<0 && currentargs.at(0)!="history") {
	  cout << "Unknown command" << endl;
	  exit(0);
	}
      }
    } // end of else if (pid==0)
    else{ // parent process
      wait(NULL);
      for (int i=0; i<currentargs.size(); i++)
	delete [] cargs[i]; // free memory
      delete [] cargs; // free memory
    }
    history.push_back(currentargs); // push currentargs to args for history
                                    // later
    if (history.size() > 10) // if history is storing more than 10 commands
      history.erase(history.begin()); // remove least recent command
    
    /**
     * After reading user input, the steps are:
     * (1) fork a child process using fork()
     * (2) the child process will invoke execvp()
     * (3) if command does not include &, parent will invoke wait()
     */
  } // end of should_run loop

  return 0;
}

// converts vector of strings to c char**
char** convert(std::vector<std::string>* stringvec)
{
  char** args = new char*[stringvec->size() + 1]; // declare size of char**
   
  for(size_t i = 0; i < stringvec->size(); i++) // loop through stringvec to
                                                // copy to args
    {	 
      args[i] = new char[stringvec->at(i).size() + 1];
      strcpy(args[i], stringvec->at(i).c_str()); 
    }
   
  args[stringvec->size()] = NULL; // null termination

  return args;
}

// prints history, including order value to command line
void printhistory(std::vector<std::vector<std::string> >vec) {
  if (vec.size() > 0) {
    for (int i=0; i<vec.size(); i++) {
      std::cout << vec.size() - i << " ";
      for (int j=0; j<vec.at(i).size(); j++)
	std::cout << vec.at(i).at(j) << " ";
      std::cout << std::endl;
    }
  }
  else
    std::cout << "Nothing in history." << std::endl;
}

// in lieu of c++11's stoi, compare ch to integer characters and return
// int if match
int findInt (char ch) {
  if (ch=='1')
    return 1;
  else if (ch=='2')
    return 2;
  else if (ch=='3')
    return 3;
  else if (ch=='4')
    return 4;
  else if (ch=='5')
    return 5;
  else if (ch=='6')
    return 6;
  else if (ch=='7')
    return 7;
  else if (ch=='8')
    return 8;
  else if (ch=='9')
    return 9;
  else
    return 10;
}
