import java.awt.*;
import java.util.Scanner;
import java.util.Vector;

public class Chessboard extends Board {
    private ChessPiece[][] grid;

    public Chessboard () {
        rows = 8;
        columns = 8;
        grid = new ChessPiece[rows][columns];
        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++){
                grid[i][j] = new ChessEmpty();
            }
        }
    }

    public Chessboard (ChessPiece[][] grid) {
        rows = 8;
        columns = 8;
        this.grid = new ChessPiece[rows][columns];
        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++){
                this.grid[i][j] = grid[i][j];
            }
        }
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

    public void initChess(Player playerOne, Player playerTwo) {
        for (int i=0; i<columns; i++) {
            grid[1][i] = new Pawn(playerTwo, 'P');
            grid[6][i] = new Pawn(playerOne, 'p');
        }
        grid[7][0] = new Rook(playerOne, 'r');
        grid[7][7] = new Rook(playerOne, 'r');
        grid[0][0] = new Rook(playerTwo, 'R');
        grid[0][7] = new Rook(playerTwo, 'R');
        grid[7][1] = new Knight(playerOne, 'n');
        grid[7][6] = new Knight(playerOne, 'n');
        grid[0][1] = new Knight(playerTwo, 'N');
        grid[0][6] = new Knight(playerTwo, 'N');
        grid[7][2] = new Bishop(playerOne, 'b');
        grid[7][5] = new Bishop(playerOne, 'b');
        grid[0][2] = new Bishop(playerTwo, 'B');
        grid[0][5] = new Bishop(playerTwo, 'B');
        grid[7][3] = new Queen(playerOne, 'q');
        grid[0][3] = new Queen(playerTwo, 'Q');
        grid[7][4] = new King(playerOne, 'k');
        grid[0][4] = new King(playerTwo, 'K');
    }

    public boolean gameOver(Player currentPlayer, Player playerOne, Player playerTwo) {
        Chessboard test = new Chessboard(this.grid);
        if (currentPlayer==playerOne)
            currentPlayer=playerTwo;
        else
            currentPlayer=playerOne;
        Vector<Move> legalMoves = test.getLegalMoves(currentPlayer, playerOne, playerTwo);
        Vector<Move> opponentMoves;
        if (currentPlayer==playerOne)
            opponentMoves = this.getLegalMoves(playerTwo, playerOne, playerTwo);
        else
            opponentMoves = this.getLegalMoves(playerOne, playerOne, playerTwo);
        for (Move each : legalMoves) {
            test.movePiece(each, currentPlayer, playerOne, true);
            if (test.inCheck(currentPlayer, opponentMoves))
                test.movePiece(each.reverseMove(), currentPlayer, playerOne, true);
            else
                return false;
        }
        return true;
    }

    // TODO: Castling

    public void movePiece(Move move, Player currentPlayer, Player playerOne, boolean isTest){
        grid[move.getDest().x][move.getDest().y] = grid[move.getOrigin().x][move.getOrigin().y];
        grid[move.getOrigin().x][move.getOrigin().y] = new ChessEmpty();
        if (grid[move.getDest().x][move.getDest().y].isPawn() && (move.getDest().y == rows-1 || move.getDest().y == 0))
            pawnPromote(move.getDest().x, move.getDest().y, currentPlayer, playerOne, isTest);
    }

    private void pawnPromote(int row, int col, Player currentPlayer, Player playerOne, boolean isTest) {
        if (!isTest) {
            System.out.println("Do you want to promote your pawn to a (r)ook, k(n)ight, (b)ishop or (q)ueen?");
            Scanner s = new Scanner(System.in);
            String str;
            boolean done = false;
            while (!done) {
                str = s.nextLine();
                if (str.toLowerCase().charAt(0) == 'r') {
                    if (currentPlayer == playerOne)
                        grid[row][col] = new Rook(currentPlayer, 'r');
                    else
                        grid[row][col] = new Rook(currentPlayer, 'R');
                    done = true;
                } else if (str.toLowerCase().charAt(0) == 'n') {
                    if (currentPlayer == playerOne)
                        grid[row][col] = new Knight(currentPlayer, 'n');
                    else
                        grid[row][col] = new Knight(currentPlayer, 'N');
                    done = true;
                } else if (str.toLowerCase().charAt(0) == 'b') {
                    if (currentPlayer == playerOne)
                        grid[row][col] = new Bishop(currentPlayer, 'b');
                    else
                        grid[row][col] = new Bishop(currentPlayer, 'B');
                    done = true;
                } else if (str.toLowerCase().charAt(0) == 'q') {
                    if (currentPlayer == playerOne)
                        grid[row][col] = new Queen(currentPlayer, 'q');
                    else
                        grid[row][col] = new Queen(currentPlayer, 'Q');
                    done = true;
                } else
                    System.out.println("Invalid input");
            }
        }
    }

    public Vector<Move> getLegalMoves(Player player, Player playerOne, Player playerTwo) {
        Vector<Move> result = new Vector();

        for (int i=0; i<rows; i++){
            for (int j=0; j<columns; j++) {
                if (grid[i][j].getOwner() == player) {
                    if (grid[i][j].isPawn())
                        getPawnMoves(player, playerOne, playerTwo, result, i, j);
                    if (grid[i][j].isKnight())
                        getKnightMoves(player, result, i, j);
                    if (grid[i][j].isBishop())
                        getBishopMoves(player, result, i, j);
                    if (grid[i][j].isRook())
                        getRookMoves(player, result, i, j);
                    if (grid[i][j].isQueen()){
                        getBishopMoves(player, result, i, j);
                        getRookMoves(player, result, i, j);
                    }
                    if (grid[i][j].isKing())
                        getKingMoves(player, result, i, j);
                }
            }
        }
        return result;
    }

    private void getKingMoves(Player player, Vector<Move> result, int i, int j) {
        for (int x=-1; x<2; x++){
            for (int y=-1; y<2; y++) {
                try {
                    if (grid[i+x][j+y].isEmpty() || grid[i+x][j+y].getOwner()!=player)
                        result.add((new Move((new Point(i, j)), new Point(Math.abs(i+x), Math.abs(j+y)))));
                } catch (ArrayIndexOutOfBoundsException e) {
                    // do nothing
                }
            }
        }
    }

    private void getRookMoves(Player player, Vector<Move> result, int i, int j) {
        int x=i;
        int y=j;
        while (x+1<rows && (grid[x+1][y].isEmpty() ||
                ((grid[x+1][y].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
            result.add((new Move((new Point(i, j)), new Point(Math.abs(x+1), Math.abs(y)))));
            x++;
        }
        x=i;
        while (x-1>=0 && (grid[x-1][y].isEmpty() ||
                ((grid[x-1][y].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
            result.add((new Move((new Point(i, j)), new Point(Math.abs(x-1), Math.abs(y)))));
            x--;
        }
        x=i;
        while (y+1<columns && (grid[x][y+1].isEmpty() ||
                ((grid[x][y+1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
            result.add((new Move((new Point(i, j)), new Point(Math.abs(x), Math.abs(y+1)))));
            y++;
        }
        y=j;
        while (y-1>=0 && (grid[x][y-1].isEmpty() ||
                ((grid[x][y-1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
            result.add((new Move((new Point(i, j)), new Point(Math.abs(x), Math.abs(y-1)))));
            y--;
        }
    }

    private void getBishopMoves(Player player, Vector<Move> result, int i, int j) {
        int x=i;
        int y=j;
        try {
            while (x+1<rows && y+1<columns && (grid[x+1][y+1].isEmpty() ||
                    ((grid[x+1][y+1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
                result.add((new Move((new Point(i, j)), new Point(Math.abs(x+1), Math.abs(y+1)))));
                x++;
                y++;
            }
        } catch (ArrayIndexOutOfBoundsException e) { }
        x=i;
        y=j;
        try {
            while (x+1<rows && y-1>=0 && (grid[x+1][y-1].isEmpty() ||
                    ((grid[x+1][y-1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
                result.add((new Move((new Point(i, j)), new Point(Math.abs(x+1), Math.abs(y-1)))));
                x++;
                y--;
            }
        } catch (ArrayIndexOutOfBoundsException e) { }
        x=i;
        y=j;
        try {
            while (x-1<rows && y+1<columns && (grid[x-1][y+1].isEmpty() ||
                    ((grid[x-1][y+1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
                result.add((new Move((new Point(i, j)), new Point(Math.abs(x-1), Math.abs(y+1)))));
                x--;
                y++;
            }
        } catch (ArrayIndexOutOfBoundsException e) { }
        x=i;
        y=j;
        try {
            while (x-1>=0 && y-1>=0 && (grid[x-1][y-1].isEmpty() ||
                    ((grid[x-1][y-1].getOwner()!=player) && (grid[x][y].isEmpty() || grid[x][y].getOwner()==player)))) {
                result.add((new Move((new Point(i, j)), new Point(Math.abs(x-1), Math.abs(y-1)))));
                x--;
                y--;
            }
        } catch (ArrayIndexOutOfBoundsException e) { }
    }

    private void getKnightMoves(Player player, Vector<Move> result, int i, int j) {
        try {
            if (grid[i + 2][j + 1].isEmpty() || grid[i + 2][j + 1].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 2), Math.abs(j + 1))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i + 2][j - 1].isEmpty() || grid[i + 2][j - 1].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 2), Math.abs(j - 1))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i + 1][j + 2].isEmpty() || grid[i + 1][j + 2].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 1), Math.abs(j + 2))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i + 1][j - 2].isEmpty() || grid[i + 1][j - 2].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 1), Math.abs(j - 2))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i - 2][j + 1].isEmpty() || grid[i - 2][j + 1].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 2), Math.abs(j + 1))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i - 2][j - 1].isEmpty() || grid[i - 2][j - 1].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 2), Math.abs(j - 1))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i - 1][j + 2].isEmpty() || grid[i - 1][j + 2].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 1), Math.abs(j + 2))));
        } catch (ArrayIndexOutOfBoundsException e) { }
        try {
            if (grid[i - 1][j - 2].isEmpty() || grid[i - 1][j - 2].getOwner() != player)
                result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 1), Math.abs(j - 2))));
        } catch (ArrayIndexOutOfBoundsException e) { }
    }

    private void getPawnMoves(Player player, Player playerOne, Player playerTwo, Vector<Move> result, int i, int j) {
        if (player == playerOne) {
            try {
                if (grid[i - 1][j].isEmpty())
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 1), Math.abs(j))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i - 2][j].isEmpty() && i==6)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 2), Math.abs(j))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i - 1][j - 1].getOwner() == playerTwo)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 1), Math.abs(j - 1))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i - 1][j + 1].getOwner() == playerTwo)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i - 1), Math.abs(j + 1))));
            } catch (ArrayIndexOutOfBoundsException e) { }
        }
        else if(player==playerTwo) {
            try {
                if (grid[i + 1][j].isEmpty())
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 1), Math.abs(j))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i + 2][j].isEmpty() && i==1)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 2), Math.abs(j))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i + 1][j + 1].getOwner() == playerOne)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 1), Math.abs(j + 1))));
            } catch (ArrayIndexOutOfBoundsException e) { }
            try {
                if (grid[i + 1][j - 1].getOwner() == playerOne)
                    result.add(new Move((new Point(i, j)), new Point(Math.abs(i + 1), Math.abs(j - 1))));
            } catch (ArrayIndexOutOfBoundsException e) { }
        }
    }

    public boolean hasLegalMove(Vector<Move> legalMoves, Move move) {
        if (move.getOrigin() == null || move.getDest() == null)
            return false;
        for (Move each : legalMoves) {
            if (each.equals(move))
                return true;
        }
        System.out.println("Illegal move.");
        return false;
    }

    public boolean inCheck(Player currentPlayer, Vector<Move> opponentMoves) {
        for (Move each : opponentMoves) {
            if (grid[each.getDest().x][each.getDest().y].isKing() && grid[each.getDest().x][each.getDest().y].getOwner()==currentPlayer)
                return true;
        }
        return false;
    }
}
