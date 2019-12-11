public class Gomokuboard extends Board {
    public Gomokuboard(int rows, int columns) {
        super(rows, columns);
    }

    public boolean checkGomokuWin() {
        for (int i=0; i<rows-4; i++){
            for (int j=0; j<rows-4; j++){
                char ch = grid[i][j].spotSymbol();
                if (ch!='.'){ // if character is placed by player
                    if ((grid[i+1][j].spotSymbol() == ch) && (grid[i+2][j].spotSymbol() == ch) // check horizontal
                            && (grid[i+3][j].spotSymbol() == ch) && grid[i+4][j].spotSymbol() == ch)
                        return true;
                    else if ((grid[i][j+1].spotSymbol() == ch) && (grid[i][j+2].spotSymbol() == ch) // check vertical
                            && (grid[i][j+3].spotSymbol() == ch) && grid[i][j+4].spotSymbol() == ch)
                        return true;
                    else if ((grid[i+1][j+1].spotSymbol() == ch) && (grid[i+2][j+2].spotSymbol() == ch) // check diagonal down to right
                            && (grid[i+3][j+3].spotSymbol() == ch) && (grid[i+4][j+4].spotSymbol() == ch))
                        return true;
                }
            }
        }
        for (int i=4; i<rows; i++){
            for (int j=0; j<columns-4; j++){
                char ch = grid[i][j].spotSymbol();
                if (ch!='.'){
                    if ((grid[i-1][j+1].spotSymbol()==ch) && (grid[i-2][j+2].spotSymbol()==ch) // check diagonal down to left
                            && (grid[i-3][j+3].spotSymbol()==ch) && grid[i-4][j+4].spotSymbol()==ch)
                        return true;
                }
            }
        }
        return false;
    }

    public boolean isFull() {
        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++){
                if (grid[i][j].spotSymbol() == '.')
                    return false;
            }
        }
        return true;
    }
}
