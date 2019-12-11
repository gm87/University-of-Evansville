import java.awt.Point;

public class Move {
    private Point origin;
    private Point dest;

    public Move(Point orig, Point dest) {
        this.origin = orig;
        this.dest = dest;
    }

    public Point getOrigin() {
        return origin;
    }

    public Point getDest() {
        return dest;
    }

    public boolean equals(Move move) {
        if (move.getOrigin().equals(this.origin) && move.getDest().equals(this.dest))
            return true;
        return false;
    }

    public Move reverseMove() {
        return new Move(dest, origin);
    }
}
