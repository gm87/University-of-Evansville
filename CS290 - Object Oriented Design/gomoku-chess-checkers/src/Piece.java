public class Piece {
    private char rep;
    private Player owner;
    boolean isEmpty = false;
    boolean madeKing = false;

    public Piece(Player player, char character) {
        owner = player;
        rep = character;
    }

    public char getRep() {
        return rep;
    }

    public Player getOwner() { return owner; }

    public boolean isEmpty() {
        return isEmpty;
    }

    public boolean isMadeKing() { return madeKing; }

    public void makeKing() { madeKing = true; }

    public void setRep(char ch) { rep = ch; }
}
