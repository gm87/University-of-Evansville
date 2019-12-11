import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;
import java.util.Vector;

import static java.lang.System.exit;

public class Application {
    public static void main (String[] args) {
        Application application = new Application();
        application.run(args);
    }

    private void run(String[] args) {
        try {
            File output = new File("test3output3.txt");
            FileWriter fileWriter = new FileWriter(output);
            if (args.length != 2) { // check input file and quantum time are specified
                System.out.println("Input file and quantum time required to run");
                exit(1);
            }
            Queue<Process> readyqueue = new LinkedList<>(); // readyQueue is a FIFO queue
            Vector<Process> waitqueue = new Vector<>(); // waitQueue isn't a queue at all, really, just a list
            Process zero = new Process(0, -1, -1); // create 'zero' process to run when nothing on RQ
            Process running = zero;
            File input = new File(args[0]);
            int quantum = Integer.parseInt(args[1]);
            Scanner scanner = null;
            try {
                scanner = new Scanner(input);
            } catch (FileNotFoundException e) {
                System.out.println("Input file invalid."); // if input file not found, throw error message and exit
                exit(1);
            }

            while (scanner.hasNextLine()) {
                // not sure why but something broke in first test file without this if statement
                if (waitqueue.contains(running)) {
                    if (!readyqueue.isEmpty())
                        running = readyqueue.remove();
                    else
                        running = zero;
                }
                printQueues(readyqueue, waitqueue, running, quantum, fileWriter); // print queues at beginning of every iteration
                String cmd = scanner.nextLine();
                fileWriter.write(cmd + "\n");
                fileWriter.flush();
                if (cmd.toLowerCase().charAt(0) == 'x') { // if x, exit the simulation after printing queues
                    printQueues(readyqueue, waitqueue, running, quantum, fileWriter);
                    exit(0);
                }
                if (running.getpid() != 0) { // if process is not zero process, decrease burst time and increment quantum time taken
                    running.decBurstSize();
                    running.incqTime();
                }
                if (running.getBurstsize() == 0) { // if process burst size hits zero, process is done and needs destroyed
                    String s = "";
                    s = s + running.getpid(); // workaround so I don't have to rewrite a destroyProcess function that takes an int for arg3
                    running = destroyProcess(readyqueue, waitqueue, running, s, zero, fileWriter);
                }
                if (running.getqTime() == quantum) { // if process has exhausted its quantum time, it needs to be placed on RQ and its QT reset
                    fileWriter.write("Process " + running.getpid() + " " + running.getBurstsize() + " placed on ready queue\n");
                    fileWriter.flush();
                    readyqueue.add(running);
                    running.resetqTime();
                    if (!readyqueue.isEmpty())
                        running = readyqueue.remove(); // next process on RQ is given resources
                    else
                        running = zero; // if no process on RQ, process 0 runs
                }
                String[] arrOfStr = cmd.toLowerCase().split("\\s+");
                switch (arrOfStr[0]) {
                    case "c": // create process
                        running = createProcess(readyqueue, running, arrOfStr);
                        break;
                    case "d": // destroy process
                        running = destroyProcess(readyqueue, waitqueue, running, arrOfStr[1], zero, fileWriter);
                        break;
                    case "w": // wait for event
                        running = waitProcess(running, readyqueue, waitqueue, arrOfStr, zero, fileWriter);
                        break;
                    case "e": // event occurred
                        running = unWaitProcess(readyqueue, waitqueue, running, arrOfStr, fileWriter);
                        break;
                }
            }
            fileWriter.close();
        } catch (Exception e) {

        }
    }

    private Process unWaitProcess(Queue<Process> readyQueue, Vector<Process> waitQueue, Process running, String[] arrOfStr, FileWriter fileWriter) throws IOException {
        for (Process each : waitQueue) { // find process in wait queue
            if ((each.getEvent() == Integer.parseInt(arrOfStr[1]))) {
                fileWriter.write("Process " + each.getpid() + " placed on ready queue\n");
                fileWriter.flush();
                readyQueue.add(each); // when found, place on ready queue
            }
        }
        for (Process each : readyQueue) {
            waitQueue.remove(each); // if process is on RQ, remove it from WQ
        }
        if (running.getpid() == 0) // if running process zero, run process at beginning of RQ
            running = readyQueue.element();
        return running;
    }

    private Process waitProcess(Process running, Queue<Process> readyQueue, Vector<Process> waitQueue, String[] arrOfStr, Process zero, FileWriter fileWriter) throws IOException {
        fileWriter.write("Process " + running.getpid() + " " + running.getBurstsize() + " placed on wait queue\n");
        fileWriter.flush();
        running.setEvent(Integer.parseInt(arrOfStr[1])); // set process' waiting event to arrOfStr[1]
        waitQueue.add(running); // add running process to WQ
        running.resetqTime(); // reset the quantum time, since it has forfeited its time
        if (!readyQueue.isEmpty())
            return readyQueue.remove(); // return first process on RQ if not empty
        else
            return zero; // otherwise run process zero
    }

    private Process destroyProcess(Queue<Process> readyQueue, Vector<Process> waitQueue, Process running, String arrOfStr, Process zero, FileWriter fileWriter) throws IOException {
        int pid = Integer.parseInt(arrOfStr);
        Process process = null;
        for (Process each : readyQueue) { // find process in RQ
            if (each.getpid() == pid)
                process = each;
        }
        for (Process each : waitQueue) { // find process in WQ
            if (each.getpid() == pid)
                process = each;
        }
        if (running.getpid() == pid) { // find process if running
            process = running;
            fileWriter.write("Process " + process.getpid() + " " + process.getBurstsize() + " terminated\n");
        }
        if (process != null) { // if process is found, destroy all its children recursively
            running = destroyChildren(readyQueue, waitQueue, process, running, zero, fileWriter);
        }
        if (running == process) // if process is currently running, run next process on RQ
            running = readyQueue.remove();
        return running;
    }

    private Process destroyChildren(Queue<Process> readyQueue, Vector<Process> waitQueue, Process delete, Process running, Process zero, FileWriter fileWriter) throws IOException {
        for (Process each : delete.getChildren()) // find all children of process to be destroyed
            running = destroyChildren(readyQueue, waitQueue, each, running, zero, fileWriter); // recursively destroy all children
        if (readyQueue.remove(delete)) // remove children from RQ
            fileWriter.write("Process " + delete.getpid() + " " + delete.getBurstsize() + " terminated");
        if (waitQueue.remove(delete)) // remove children from WQ
            fileWriter.write("Process " + delete.getpid() + " " + delete.getBurstsize() + " terminated");
        if (running == delete){ // if currently running process to be deleted, set running process to top of RQ or zero
            if (!readyQueue.isEmpty())
                running = readyQueue.element();
            else
                running = zero;
        }
        fileWriter.flush();
        return running;
    }

    private Process createProcess(Queue<Process> readyQueue, Process running, String[] arrOfStr) {
        // create process with given parameters
        Process created = new Process (Integer.parseInt(arrOfStr[1]), Integer.parseInt(arrOfStr[2]), running.getpid());
        if (running.getpid() == 0) // if currently running process zero, run this process
            running = created;
        else {
            running.addChild(created); // otherwise, add this process to children of current running process
            readyQueue.add(created); // add process to RQ
        }
        return running;
    }

    private void printQueues(Queue<Process> readyQueue, Vector<Process> waitQueue, Process running, int quantum, FileWriter fileWriter) throws IOException {
        int x = quantum - running.getqTime();
        if (running.getpid() != 0)
            fileWriter.write("PID " + running.getpid() + " " + running.getBurstsize() + " running with " + x + " left\n");
        else
            fileWriter.write("PID 0 running\n");
        fileWriter.write("Ready queue: ");
        for (Process each : readyQueue)
            fileWriter.write("PID " + each.getpid() + " " + each.getBurstsize() + " ");
        fileWriter.write("\n");
        fileWriter.write("Wait queue: ");
        for (Process each : waitQueue)
            fileWriter.write("PID " + each.getpid() + " " + each.getBurstsize() + " " + each.getEvent() + " ");
        fileWriter.write("\n\n");
        fileWriter.flush();
    }
}
