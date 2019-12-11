public class Board {
    protected int rows;
    protected int columns;
    protected Spot[][] grid;

    public Board (int rows, int columns) {
        this.rows = rows;
        this.columns = columns;
        this.grid = new Spot[rows][columns];
        for (int i=0; i<rows; i++) {
            for (int j=0; j<columns; j++)
                grid[i][j] = new Spot();
        }
    }

    public Board() {

    }

    public void print () {
        printColumnLabels();
        for (int i=0; i<rows; i++) {
            System.out.print(i+1 + "\t");
            for (int j=0; j<columns; j++) {
                System.out.print(grid[i][j].spotSymbol() + "\t");
            }
            System.out.print(i+1); // print row label
            System.out.println();
        }
        printColumnLabels();
    }

    public boolean spotIsGood (int row, int col){
        if (row<=rows && col<=columns && grid[row-1][col].spotSymbol() == '.')
            return true;
        return false;
    }

    protected void printColumnLabels() {
        System.out.print("    ");
        char ch = 'A';
        for (int i=0; i<columns; i++) {
            System.out.print(ch + "\t");
            ch++;
        }
        System.out.println();
    }

    public void setSpot(int row, int column, char ch) {
        this.grid[row][column].setSpotSymbol(ch);
    }

}
