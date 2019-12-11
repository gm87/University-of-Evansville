import java.awt.*;
import java.util.Scanner;
import java.util.Vector;

public class Checkers {
    public static void main (String[] args) {
        Checkers game = new Checkers();
        game.run(args);
    }

    public void run (String[] args) {
        String input; // user input
        Scanner s = new Scanner(System.in); // get input from console
        Checkerboard board = new Checkerboard();
        Player playerOne = new Player('x', 1);
        Player playerTwo = new Player('o', 2);
        board.initCheckers(playerOne, playerTwo); // playerone can move NEGATIVE, playertwo can move POSITIVE unless king, then move either way
        board.print();
        Player currentPlayer = playerTwo;

        System.out.println("\nInput should be in ColumnRow format (ex: a1 or A1).\n" +
                "First coordinate is piece to move, second coordinate is where to move it to.\n" +
                "Capital letters represent kings.\n");
        while (!board.checkCheckersWin(playerOne, playerTwo)) {
            boolean turnOver = false;
            currentPlayer = getNextPlayer(playerOne, playerTwo, currentPlayer);
            while (!turnOver) {
                boolean validInput = false;
                Vector<Move> legalMoves = board.getMoves(currentPlayer, playerOne, playerTwo);
                Point originPoint = null;
                Point destPoint = null;
                while (!validInput) {
                    System.out.print("Player " + currentPlayer.getNumber() + "'s turn: ");
                    input = s.nextLine();
                    originPoint = null;
                    destPoint = null;
                    try {
                        originPoint = new Point((Math.abs(input.charAt(1) - 56)), Math.abs(input.charAt(0) - 97));
                        destPoint = new Point((Math.abs(input.charAt(4) - 56)), Math.abs(input.charAt(3) - 97));
                        validInput = true;
                    } catch (StringIndexOutOfBoundsException e) {
                        System.out.println("Invalid input.");
                        validInput = false;
                    }
                }
                Move move = new Move(originPoint, destPoint);
                if (!moveIsLegal(legalMoves, move)){
                    System.out.println("Illegal move.");
                }
                else {
                    if (jumpExists(legalMoves) && !isJump(move)) {
                        System.out.println("A jump exists, you must take it.");
                    } else {
                        board.movePiece(move, currentPlayer, playerOne, playerTwo);
                        turnOver = true;
                    }
                }
                while (isJump(move) && !board.getNextJump(move, currentPlayer, playerOne, playerTwo).isEmpty()) {
                    System.out.println();
                    board.print();
                    System.out.println();
                    System.out.println("Another jump exists, take it");
                    System.out.print("Player " + currentPlayer.getNumber() + "'s turn: ");
                    input = s.nextLine();
                    originPoint = null;
                    destPoint = null;
                    try {
                        originPoint = new Point((Math.abs(input.charAt(1) - 56)), Math.abs(input.charAt(0) - 97));
                        destPoint = new Point((Math.abs(input.charAt(4) - 56)), Math.abs(input.charAt(3) - 97));
                    } catch (StringIndexOutOfBoundsException e) {
                        System.out.println("Invalid input.");
                    }
                    Move nextMove = new Move(originPoint, destPoint);
                    if (moveIsLegal(board.getNextJump(move, currentPlayer, playerOne, playerTwo), nextMove)) {
                        move = nextMove;
                        board.movePiece(nextMove, currentPlayer, playerOne, playerTwo);
                    }
                    else
                        System.out.println("Invalid move.");
                }
                System.out.println();
                board.print();
                System.out.println();
            }
        }
        board.print();
        System.out.println("Player " + currentPlayer.getNumber() + " wins!");
    }

    private boolean isJump(Move move) {
        if (Math.abs(move.getOrigin().y - move.getDest().y) == 2)
            return true;
        return false;
    }

    private boolean jumpExists(Vector<Move> legalMoves) {
        for (Move each : legalMoves) {
            if (Math.abs(each.getOrigin().y - each.getDest().y) == 2)
                return true;
        }
        return false;
    }

    private boolean moveIsLegal(Vector<Move> legalMoves, Move move) {
        for (Move each : legalMoves) {
            if (each.equals(move))
                return true;
        }
        return false;
    }

    private Player getNextPlayer(Player playerOne, Player playerTwo, Player currentPlayer) {
        if (currentPlayer == playerTwo)
            currentPlayer = playerOne;
        else
            currentPlayer = playerTwo;
        return currentPlayer;
    }
}
