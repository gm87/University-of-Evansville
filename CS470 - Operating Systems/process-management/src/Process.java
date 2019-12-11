import java.util.Vector;

public class Process {
    private int pid;
    private int burstsize;
    private Vector<Process> children = new Vector();
    private int event;
    private int parentID;
    private int qTime=0;

    public Process(int pid, int burstsize, int parentID){
        this.pid = pid;
        this.burstsize = burstsize;
        this.parentID = parentID;
    }

    public int getpid () { return pid; }

    public int getBurstsize () { return burstsize; }

    public int getEvent () { return this.event; }

    public int getParentID () { return this.parentID; }

    public Vector<Process> getChildren () { return children; }

    public int getqTime () { return qTime; }

    public void incqTime () { qTime++; }

    public void resetqTime () { qTime = 0; }

    public void addChild(Process elementAt) { children.add(elementAt); }

    public void setEvent(int event) { this.event = event; }

    public void decBurstSize() { burstsize--; }
}