import java.awt.Point;
import java.util.Vector;

public class Checkerboard extends Board {
    private Piece[][] grid;

    public Checkerboard () {
        rows = 8;
        columns = 8;
        grid = new Piece[rows][columns];
        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++){
                grid[i][j] = new CheckersEmpty();
            }
        }
    }

    public void initCheckers(Player playerOne, Player playerTwo) {
        // set playerOne initial positions
        grid[5][0] = new Piece(playerOne, playerOne.getCh());
        grid[5][2] = new Piece(playerOne, playerOne.getCh());
        grid[5][4] = new Piece(playerOne, playerOne.getCh());
        grid[5][6] = new Piece(playerOne, playerOne.getCh());
        grid[6][1] = new Piece(playerOne, playerOne.getCh());
        grid[6][3] = new Piece(playerOne, playerOne.getCh());
        grid[6][5] = new Piece(playerOne, playerOne.getCh());
        grid[6][7] = new Piece(playerOne, playerOne.getCh());
        grid[7][0] = new Piece(playerOne, playerOne.getCh());
        grid[7][2] = new Piece(playerOne, playerOne.getCh());
        grid[7][4] = new Piece(playerOne, playerOne.getCh());
        grid[7][6] = new Piece(playerOne, playerOne.getCh());
        // set playerTwo initial positions
        grid[0][1] = new Piece(playerTwo, playerTwo.getCh());
        grid[0][3] = new Piece(playerTwo, playerTwo.getCh());
        grid[0][5] = new Piece(playerTwo, playerTwo.getCh());
        grid[0][7] = new Piece(playerTwo, playerTwo.getCh());
        grid[1][0] = new Piece(playerTwo, playerTwo.getCh());
        grid[1][2] = new Piece(playerTwo, playerTwo.getCh());
        grid[1][4] = new Piece(playerTwo, playerTwo.getCh());
        grid[1][6] = new Piece(playerTwo, playerTwo.getCh());
        grid[2][1] = new Piece(playerTwo, playerTwo.getCh());
        grid[2][3] = new Piece(playerTwo, playerTwo.getCh());
        grid[2][5] = new Piece(playerTwo, playerTwo.getCh());
        grid[2][7] = new Piece(playerTwo, playerTwo.getCh());

    }

    public boolean checkCheckersWin(Player playerOne, Player playerTwo) {
        int p1 = 0;
        int p2 = 0;
        for (int i=0; i<rows; i++) {
            for (int j=0; j<columns; j++) {
                if (grid[i][j].getOwner() == playerOne)
                    p1++;
                else if (grid[i][j].getOwner() == playerTwo)
                    p2++;
            }
        }
        return p1 == 0 || p2 == 0;
    }

    @Override
    public void print() {
        printColumnLabels();
        for (int i=0; i<rows; i++) {
            System.out.print(i+(8-2*i) + "\t");
            for (int j=0; j<columns; j++) {
                System.out.print(grid[i][j].getRep() + "\t");
            }
            System.out.print(i+(8-2*i)); // print row label
            System.out.println();
        }
        printColumnLabels();
    }

    public Vector<Move> getMoves(Player currentPlayer, Player playerOne, Player playerTwo) {
        Vector<Move> moves = new Vector();
        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++){
                if ((currentPlayer == playerOne && grid[i][j].getOwner() == playerOne)
                    || (currentPlayer == playerTwo && grid[i][j].getOwner()==playerTwo && grid[i][j].isMadeKing())) {
                    try {
                        if (grid[i-1][j-1].isEmpty())
                            moves.add(new Move (new Point(i, j), new Point(i-1, j-1)));
                    } catch (ArrayIndexOutOfBoundsException e) { }
                    try {
                        if (grid[i-1][j+1].isEmpty())
                            moves.add(new Move (new Point(i, j), new Point(i-1, j+1)));
                    } catch (ArrayIndexOutOfBoundsException e) { }
                    try {
                        if(grid[i-1][j-1].getOwner() == playerTwo && grid[i-2][j-2].isEmpty())
                            moves.add(new Move(new Point(i, j), new Point(i-2, j-2)));
                    } catch (ArrayIndexOutOfBoundsException e) { }
                    try {
                        if(grid[i-1][j+1].getOwner()==playerTwo && grid[i-2][j+2].isEmpty())
                            moves.add(new Move(new Point(i, j), new Point(i-2, j+2)));
                    } catch (ArrayIndexOutOfBoundsException e) { }
                }
            else if ((currentPlayer == playerTwo && grid[i][j].getOwner()==playerTwo)
                    || (currentPlayer == playerOne && grid[i][j].getOwner()==playerOne && grid[i][j].isMadeKing())){
                try {
                    if (grid[i+1][j-1].isEmpty())
                        moves.add(new Move (new Point(i, j), new Point(i+1, j-1)));
                } catch (ArrayIndexOutOfBoundsException e) { }
                try {
                    if (grid[i+1][j+1].isEmpty())
                        moves.add(new Move (new Point(i, j), new Point(i+1, j+1)));
                } catch (ArrayIndexOutOfBoundsException e) { }
                try {
                    if(grid[i+1][j-1].getOwner() == playerOne && grid[i+2][j-2].isEmpty())
                        moves.add(new Move(new Point(i, j), new Point(i+2, j-2)));
                } catch (ArrayIndexOutOfBoundsException e) { }
                try {
                        if(grid[i+1][j+1].getOwner()==playerOne && grid[i+2][j+2].isEmpty())
                            moves.add(new Move(new Point(i, j), new Point(i+2, j+2)));
                    } catch (ArrayIndexOutOfBoundsException e) { }
                }
            }
        }
        return moves;
    }

    public void movePiece(Move move, Player currentplayer, Player playerOne, Player playerTwo) {
        if (Math.abs(move.getOrigin().y - move.getDest().y) == 1) {
            grid[move.getDest().x][move.getDest().y] = grid[move.getOrigin().x][move.getOrigin().y];
            grid[move.getOrigin().x][move.getOrigin().y] = new CheckersEmpty();
        } else {
            grid[move.getDest().x][move.getDest().y] = grid[move.getOrigin().x][move.getOrigin().y];
            grid[(move.getOrigin().x+move.getDest().x)/2][(move.getOrigin().y+move.getDest().y)/2] = new CheckersEmpty();
            grid[move.getOrigin().x][move.getOrigin().y] = new CheckersEmpty();
        }
        if ((currentplayer == playerOne && move.getDest().x==0) || (currentplayer == playerTwo && move.getDest().x==7)) {
            grid[move.getDest().x][move.getDest().y].makeKing();
            grid[move.getDest().x][move.getDest().y].setRep(Character.toUpperCase(currentplayer.getCh()));
        }
    }

    public Vector<Move> getNextJump(Move move, Player currentPlayer, Player playerOne, Player playerTwo) {
        Vector<Move> moves = new Vector();
        Point dest = move.getDest();
        if ((currentPlayer == playerOne && grid[dest.x][dest.y].getOwner() == playerOne)
                || (currentPlayer == playerTwo && grid[dest.x][dest.y].getOwner()==playerTwo && grid[dest.x][dest.y].isMadeKing())) {
            try {
                if(grid[dest.x-1][dest.y-1].getOwner() == playerTwo && grid[dest.x-2][dest.y-2].isEmpty())
                    moves.add(new Move(new Point(dest.x, dest.y), new Point(dest.x-2, dest.y-2)));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if(grid[dest.x-1][dest.y+1].getOwner()==playerTwo && grid[dest.x-2][dest.y+2].isEmpty())
                    moves.add(new Move(new Point(dest.x, dest.y), new Point(dest.x-2, dest.y+2)));
            } catch (ArrayIndexOutOfBoundsException e) { }
        }
        else if ((currentPlayer == playerTwo && grid[dest.x][dest.y].getOwner()==playerTwo)
                || (currentPlayer == playerOne && grid[dest.x][dest.y].getOwner()==playerOne && grid[dest.x][dest.y].isMadeKing())){
            try {
                if(grid[dest.x+1][dest.y-1].getOwner() == playerOne && grid[dest.x+2][dest.y-2].isEmpty())
                    moves.add(new Move(new Point(dest.x, dest.y), new Point(dest.x+2, dest.y-2)));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if(grid[dest.x+1][dest.y+1].getOwner()==playerOne && grid[dest.x+2][dest.y+2].isEmpty())
                    moves.add(new Move(new Point(dest.x, dest.y), new Point(dest.x+2, dest.y+2)));
            } catch (ArrayIndexOutOfBoundsException e) { }
        }
        return moves;
    }
}
