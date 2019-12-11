import java.awt.*;
import java.util.Scanner;
import java.util.Vector;

public class Chess {

    public static void main (String[] args) {
        Chess game = new Chess();
        game.run(args);
    }

    private void run(String[] args) {
        String input; // user input
        boolean turnover;
        Scanner s = new Scanner(System.in); // get input from console
        Chessboard board = new Chessboard();
        Player playerOne = new Player('x', 1);
        Player playerTwo = new Player('y', 2);

        board.initChess(playerOne, playerTwo);
        Player currentPlayer = playerTwo;
        board.print();
        System.out.println("Enter your move in rowcol-rowcol format (ex: a2-a3)");
        while (!board.gameOver(currentPlayer, playerOne, playerTwo)) {
            turnover=false;
            if (currentPlayer==playerOne)
                currentPlayer=playerTwo;
            else
                currentPlayer=playerOne;
            Vector<Move> legalMoves = board.getLegalMoves(currentPlayer, playerOne, playerTwo);
            Vector<Move> opponentMoves;
            if (currentPlayer==playerOne)
               opponentMoves = board.getLegalMoves(playerTwo, playerOne, playerTwo);
            else
                opponentMoves = board.getLegalMoves(playerOne, playerOne, playerTwo);
            if (board.inCheck(currentPlayer, opponentMoves))
                System.out.println("Check!");
            while (!turnover) {
                System.out.println("Player " + currentPlayer.getNumber() + "'s turn: ");
                input = s.nextLine();
                Point originPoint = null;
                Point destPoint = null;
                try {
                    originPoint = new Point((Math.abs(input.charAt(1) - 56)), Math.abs(input.charAt(0) - 97));
                    destPoint = new Point((Math.abs(input.charAt(4) - 56)), Math.abs(input.charAt(3) - 97));
                } catch (StringIndexOutOfBoundsException e) {
                    System.out.println("Invalid input.");
                }
                Move move = new Move(originPoint, destPoint);
                if (board.hasLegalMove(legalMoves, move)) {
                    board.movePiece(move, currentPlayer, playerOne, false);
                    turnover=true;
                    if (board.inCheck(currentPlayer, opponentMoves)) {
                        board.movePiece(move.reverseMove(), currentPlayer, playerOne, false);
                        System.out.println("You can't put yourself in check.");
                        turnover=false;
                    }
                }
                board.print();
            }
        }
        System.out.println("Player " + currentPlayer.getNumber() + " wins!");
    }
}
