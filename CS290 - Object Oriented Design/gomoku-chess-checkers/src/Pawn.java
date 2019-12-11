public class Pawn extends ChessPiece {
    private boolean played = false;

    public Pawn (Player player, char rep) {
        super(player, rep);
        isPawn = true;
    }

    public boolean getPlayed() {
        return played;
    }

    public void setPlayedTrue() {
        played = true;
    }

}
