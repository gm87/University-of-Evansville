import javax.swing.*;
import java.awt.*;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.ArrayList;
import java.util.Vector;

public class ChessGUI extends JFrame implements MouseListener, MouseMotionListener {

    private JPanel boardPanel = new JPanel();
    private JFrame frame = new JFrame();
    private JLabel chessPiece;
    private JLabel playerLabel = new JLabel();
    private Point parentLocation;
    private boolean drag = false;
    private Chessboard board = new Chessboard();
    private Point orig;
    private Point dest;
    private Player playerOne = new Player('x', 1);
    private Player playerTwo = new Player('y', 2);
    private Player currentPlayer=playerOne;

    public static void main() {
        ChessGUI game = new ChessGUI();
        game.run();
    }

    private void run() {
        board.initChess(playerOne, playerTwo);
        Dimension size = new Dimension(600, 600);
        frame.addMouseListener(this);
        frame.addMouseMotionListener(this);
        boardPanel.setLayout(new GridLayout(8, 8));
        frame.setLayout(new GridLayout(1, 2));
        this.setPreferredSize(size);
        initChess();
        playerLabel.setText("Player " + currentPlayer.getNumber() + "'s turn");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.add(boardPanel);
        frame.add(playerLabel);
        frame.pack();
        frame.setVisible(true);
    }

    private void initChess() {
        boardPanel.add(new ChessSquare(0, "img/blackRook.png"));
        boardPanel.add(new ChessSquare(1, "img/blackKnight.png"));
        boardPanel.add(new ChessSquare(2, "img/blackBishop.png"));
        boardPanel.add(new ChessSquare(3, "img/blackQueen.png"));
        boardPanel.add(new ChessSquare(4, "img/blackKing.png"));
        boardPanel.add(new ChessSquare(5, "img/blackBishop.png"));
        boardPanel.add(new ChessSquare(6, "img/blackKnight.png"));
        boardPanel.add(new ChessSquare(7, "img/blackRook.png"));
        for (int i=8; i<16; i++)
            boardPanel.add(new ChessSquare(i, "img/blackPawn.png"));
        for (int i = 16; i < 48; i++)
            boardPanel.add(new ChessSquare(i, ""));
        for (int i=48; i<56; i++)
            boardPanel.add(new ChessSquare(i, "img/whitePawn.png"));
        boardPanel.add(new ChessSquare(56, "img/whiteRook.png"));
        boardPanel.add(new ChessSquare(57, "img/whiteKnight.png"));
        boardPanel.add(new ChessSquare(58, "img/whiteBishop.png"));
        boardPanel.add(new ChessSquare(59, "img/whiteQueen.png"));
        boardPanel.add(new ChessSquare(60, "img/whiteKing.png"));
        boardPanel.add(new ChessSquare(61, "img/whiteBishop.png"));
        boardPanel.add(new ChessSquare(62, "img/whiteKnight.png"));
        boardPanel.add(new ChessSquare(63, "img/whiteRook.png"));
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        System.out.println("(" + e.getX() + ", " + e.getY() + ")");
    }

    @Override
    public void mousePressed(MouseEvent e) {
        Component c = boardPanel.getComponentAt(e.getX(), e.getY());
        Container subContainer = (Container)c;
        parentLocation = c.getParent().getLocation();
        chessPiece = (JLabel) subContainer.getComponent(0);
        int width = frame.getBounds().width;
        int height = frame.getBounds().height;
        orig = new Point((e.getY() / (height/8)), (e.getX() / (width/16)));
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        boolean turnover = false;
        drag = false;
        if (chessPiece == null)
            return;
        Component c = boardPanel.getComponentAt(e.getX(), e.getY());
        Container subContainer = (Container)c;
        int width = frame.getBounds().width;
        int height = frame.getBounds().height;
        dest = new Point((e.getY() / (height/8)), (e.getX() / (width/16)));
        Move move = new Move(orig, dest);
        Vector<Move> legalMoves = board.getLegalMoves(currentPlayer, playerOne, playerTwo);
        Vector<Move> opponentMoves;
        if (currentPlayer==playerOne)
            opponentMoves = board.getLegalMoves(playerTwo, playerOne, playerTwo);
        else
            opponentMoves = board.getLegalMoves(playerOne, playerOne, playerTwo);
        System.out.println("My move: " + move.getOrigin() + " " + move.getDest());
        for (Move each : legalMoves)
            System.out.println(each.getOrigin() + " " + each.getDest());
        System.out.println();
        if (board.hasLegalMove(legalMoves, move)) {
            board.movePiece(move, currentPlayer, playerOne, false);
            turnover = true;
            if (board.inCheck(currentPlayer, opponentMoves)) {
                board.movePiece(move.reverseMove(), currentPlayer, playerOne, false);
                System.out.println("You can't put yourself in check.");
                turnover = false;
            }
            else if (subContainer.getComponents().length == 0)
                ((Container) c).add(chessPiece);
            else {
                ((Container) c).remove(subContainer.getComponent(0));
                ((Container) c).add(chessPiece);
            }
            if (turnover) {
                if (currentPlayer == playerOne)
                    currentPlayer = playerTwo;
                else
                    currentPlayer = playerOne;
            }
            playerLabel.setText("Player " + currentPlayer.getNumber() + "'s turn");
        }
        board.print();
        boardPanel.updateUI();
    }

    @Override
    public void mouseEntered(MouseEvent e) {

    }

    @Override
    public void mouseExited(MouseEvent e) {

    }

    @Override
    public void mouseDragged(MouseEvent e) {
        if (chessPiece == null)
            return;
        int xAdjustment = parentLocation.x - e.getX();
        int yAdjustment = parentLocation.y - e.getY();
        chessPiece.setLocation(e.getX() + xAdjustment, yAdjustment + e.getY());
        boardPanel.updateUI();
    }

    @Override
    public void mouseMoved(MouseEvent e) {
        boardPanel.updateUI();
    }
}
