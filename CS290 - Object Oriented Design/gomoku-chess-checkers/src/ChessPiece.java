public class ChessPiece extends Piece{
    boolean isPawn = false;
    boolean isKnight = false;
    boolean isBishop = false;
    boolean isRook = false;
    boolean isQueen = false;
    boolean isKing = false;


    public ChessPiece(Player player, char character) {
        super(player, character);
    }

    public boolean isBishop() {
        return isBishop;
    }

    public boolean isKing() {
        return isKing;
    }

    public boolean isKnight() {
        return isKnight;
    }

    public boolean isPawn() {
        return isPawn;
    }

    public boolean isQueen() {
        return isQueen;
    }

    public boolean isRook() {
        return isRook;
    }
}
