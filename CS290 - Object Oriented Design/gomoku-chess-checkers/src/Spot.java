public class Spot {
    private char symbol;

    public Spot () {
        symbol = '.';
    }

    public char spotSymbol() {
        return symbol;
    }

    public void setSpotSymbol(char ch){
        symbol = ch;
    }
}
