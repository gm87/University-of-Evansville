import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

import static java.lang.System.exit;

public class Application {
    public static void main (String[] args) {
        Application application = new Application();
        application.run(args);
    }

    private void run(String[] args) {
        File input = new File(args[0]);
        Scanner s = null;
        try { s = new Scanner(input); }
        catch (FileNotFoundException e) {
            System.out.println("Invalid input file.");
            exit(1);
        }
        Vector<Page> inputVector = new Vector<>();
        int frameSize = Integer.parseInt(args[1]);
        while (s.hasNextLine()) {
            inputVector.add(new Page(s.nextLine()));
        }
        LRU(inputVector, frameSize);
        FIFO(inputVector, frameSize);
        Optimal(inputVector, frameSize);
    }

    private void Optimal(Vector<Page> inputVector, int frameSize) {
        Vector<Page> pageTable = new Vector<>();
        int pageFaults = 0; // pageFaults counter
        for (Page each : inputVector) {
            if (pageTable.size() < frameSize && (!pageTableVectorContains(pageTable, each))) { // if pageTable size is within frame size boundary
                                                                                               // and if page is not currently in page table
                pageTable.add(each);
                pageFaults++;
            }
            else if (pageTable.size() >= frameSize && (!pageTableVectorContains(pageTable, each))) { // if page table size is equal to frame size boundary
                                                                                                     // and page is not currently in page table
                pageTable.remove(findVictimPage(inputVector, pageTable, inputVector.indexOf(each))); // use findVictimPage to find page to remove
                pageTable.add(each);
                pageFaults++;
            }
        }
        System.out.println("Page faults from Optimal: " + pageFaults);
    }

    private void FIFO(Vector<Page> inputVector, int frameSize) {
        Queue<Page> pageTable = new LinkedList<>(); // use queue to implement FIFO functionality
        int pageFaults = 0;
        for (Page each : inputVector) {
            if (pageTable.size() < frameSize && (!pageTableContains(pageTable, each))){ // if pageTable size is within frame size boundary
                                                                                        // and page is not currently in page table
                pageTable.add(each);
                pageFaults++;
            }
            else if (pageTable.size() >= frameSize && (!pageTableContains(pageTable, each))){ // if page table size is equal to frame size boundary
                                                                                              // and page is not currently in page table
                pageTable.remove();
                pageTable.add(each);
                pageFaults++;
            }
        }
        System.out.println("Page faults from FIFO: " + pageFaults);
    }

    private void LRU(Vector<Page> inputVector, int frameSize) {
        Queue<Page> pageTable = new LinkedList<>(); // queue to implement LRU functionality
        int pageFaults = 0;
        for (Page each : inputVector) {
            if (pageTable.size() < frameSize && (!pageTableContains(pageTable, each))) { // if pageTable size is within frameSize boundary
                                                                                         // and if page is not currently in page table
                pageTable.add(each);
                pageFaults++;
            }
            else if (pageTable.size() >= frameSize && (!pageTableContains(pageTable, each))) { // if page table size is equal to frameSize boundary
                                                                                               // and if page is not currently in page table
                pageTable.remove(); // page at front of queue is least recently used page
                pageTable.add(each);
                pageFaults++;
            }
            else if (pageTableContains(pageTable, each)) { // if page table already contains page being accessed, move it to back of queue
                pageTable.remove(getEach(pageTable, each));
                pageTable.add(each);
            }
        }
        System.out.println("Page faults from LRU: " + pageFaults);
    }

    // find the copy of each in pageTable
    private Page getEach(Queue<Page> pageTable, Page page) {
        for (Page each : pageTable) {
            if (each.equals(page)) {
                return each;
            }
        }
        return null;
    }

    private Page findVictimPage(Vector<Page> inputVector, Vector<Page> pageTable, int i) {
        Vector<Page> workingVector = new Vector<>(); // pages that will be accessed in the future
        Page max = null; // init max page to null
        int maxindex = 0; // init maxindex to zero
        for (int j = i; j<inputVector.size(); j++) // add pages to be accessed in future to working vector
            workingVector.add(inputVector.elementAt(j));
        for (Page each : pageTable) {
            if (!pageTableVectorContains(workingVector, each)) // check if page is in working vector
                return each; // if not, we can throw this page out because we don't access it again in the future
        }
        for (Page each : pageTable) { // otherwise loop through page table
            for (int j = 0; j<workingVector.size(); j++) { // loop through working vector to find first occurrence of page 'each'
                if (workingVector.elementAt(j).equals(each)) {
                    if (j>maxindex) { // if current index is greater than max index, this is new potential victim page
                        max = each;
                        maxindex = j;
                    }
                    break; // break since we found first occurrence
                }
            }
        }
        return max;
    }

    // use this instead of pageTable.contains since we make each line its own new page
    private boolean pageTableContains(Queue<Page> pageTable, Page page) {
        for (Page each : pageTable) {
            if (each.equals(page))
                return true;
        }
        return false;
    }

    private boolean pageTableVectorContains(Vector<Page> pageTable, Page page) {
        for (Page each : pageTable) {
            if (each.equals(page))
                return true;
        }
        return false;
    }
}
