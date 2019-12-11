import java.util.Scanner;

public class Game {
    public static void main(String[] args) {
        Game game = new Game();
        game.run(args);
    }

    public void run(String[] args) {
        boolean running = true;
        Scanner s = new Scanner(System.in);
        String input;
        while (running) {
            System.out.println("Would you like to play (C)heckers, C(h)ess or (G)omoku? Or would you like to (Q)uit?");
            input = s.next();
            if (input.charAt(0) == 'c')
                Checkers.main(args);
            else if (input.toLowerCase().charAt(0) == 'g')
                Gomoku.main(args);
            else if (input.toLowerCase().charAt(0) == 'h')
                ChessGUI.main();
            else if (input.toLowerCase().charAt(0) == 'q')
                running = false;
            else
                System.out.println("Unknown command: " + input);
        }
    }
}
