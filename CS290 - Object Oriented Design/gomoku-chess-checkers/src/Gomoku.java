import java.util.Scanner;

public class Gomoku {
    public static void main(String[] args) {
        Gomoku game = new Gomoku();
        game.run(args);
    }

    public void run(String[] args) {
        final int size = 19;
        String input; // user input
        Scanner s = new Scanner(System.in); // get input from console
        Gomokuboard board = new Gomokuboard(size, size);
        board.print();
        Player playerOne = new Player('X', 1);
        Player playerTwo = new Player('O', 2);
        Player currentPlayer = playerTwo;

        System.out.println("\n Input should be in ColumnRow format (ex: a1 or A1)");
        while (!board.checkGomokuWin() && !board.isFull()) {
            boolean turnOver = false;
            if (currentPlayer == playerTwo)
                currentPlayer = playerOne;
            else
                currentPlayer = playerTwo;
            while (!turnOver) {
                System.out.println(); // formatting
                System.out.print("Player " + currentPlayer.getNumber() + "'s turn >"); // indicates input required
                input = s.nextLine().toLowerCase();
                if (input.equals("")) {
                    System.out.println("Enter a coordinate.");
                    if (currentPlayer==playerTwo)
                        currentPlayer=playerOne;
                    else
                        currentPlayer=playerTwo;
                    break;
                }
                System.out.println(); // formatting
                int column = input.charAt(0) - 97;
                String rowStr = "";
                for (int i = 1; i < input.length(); i++) {
                    rowStr = rowStr + input.charAt(i);
                }
                try {
                    int row = Integer.parseInt(rowStr);
                    if (board.spotIsGood(row, column)) {
                        board.setSpot(row - 1, column, currentPlayer.getCh());
                        turnOver=true;
                    }
                    else
                        System.out.println("Bad spot! Coordinate must be in grid and not already occupied.");
                } catch (Exception e) {
                    System.out.println("Invalid input. Input must be in column row format (ex: a1 or A1)");
                }
                board.print();
            }
        }
        if (board.checkGomokuWin())
            System.out.println("Player " + currentPlayer.getNumber() + " wins!");
        else if (board.isFull())
            System.out.println("Tie game!");
    }
}
