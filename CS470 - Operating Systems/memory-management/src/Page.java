public class Page {

    private int pid;
    private int pageid;

    public Page(String input) {
        String[] arrOfStr = input.split("\\s+");
        pid = Integer.parseInt(arrOfStr[0]);
        pageid = Integer.parseInt(arrOfStr[1]);
    }

    public int getPid() {
        return this.pid;
    }

    public int getPageid() {
        return this.pageid;
    }

    public boolean equals(Page page) {
        return ((page.getPid() == this.pid) && (page.getPageid() == this.pageid));
    }
}
