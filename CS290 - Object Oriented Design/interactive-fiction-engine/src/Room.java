import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.Vector;

public class Room {
    private String name;
    private String description;
    private String n, s, e, w, nw, ne, sw, se;
    private String listen = "";
    private Vector<Item> roomitems = new Vector();
    private boolean gameOver = false;

    public Room(File infile) {
        try {
            Scanner scanner = new Scanner(infile);
            while (scanner.hasNextLine()) {
                String s = scanner.nextLine();
                String attribute = "";
                String value = "";
                for (int i=0; i<s.indexOf(':'); i++) // read attribute from file
                    attribute += s.charAt(i);
                for (int i=s.indexOf(':')+2; i<s.length(); i++) // read value from file
                    value += s.charAt(i);
                File input = new File(String.valueOf(value));
                if (attribute.toLowerCase().equals("name")) { this.name = value.toString(); }
                else if (attribute.toLowerCase().equals("description")) { this.description = value.toString(); }
                else if (attribute.toLowerCase().equals("n")) { this.n = value; }
                else if (attribute.toLowerCase().equals("s")) { this.s = value; }
                else if (attribute.toLowerCase().equals("e")) { this.e = value; }
                else if (attribute.toLowerCase().equals("w")) { this.w = value; }
                else if (attribute.toLowerCase().equals("nw")) { this.nw = value; }
                else if (attribute.toLowerCase().equals("ne")) { this.ne = value; }
                else if (attribute.toLowerCase().equals("sw")) { this.sw = value; }
                else if (attribute.toLowerCase().equals("se")) { this.se = value; }
                else if (attribute.toLowerCase().equals("listen")) { this.listen = value.toString(); }
                else if (attribute.toLowerCase().equals("item")) { roomitems.add(new Item (input)); }
                else if (attribute.toLowerCase().equals("gameover")) { this.gameOver = true; }
                else { System.out.println("Attribute: " + attribute + " not valid."); }
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public String nroom() { return this.n; }

    public String sroom() { return this.s; }

    public String eroom() { return this.e; }

    public String wroom() { return this.w; }

    public String nwroom() { return this.nw; }

    public String neroom() { return this.ne; }

    public String swroom() { return this.sw; }

    public String seroom() { return this.se; }

    public String listen() { return this.listen; }

    public String name() { return this.name; }

    public String description() { return this.description; }

    public boolean gameOver() { return this.gameOver; }

    public boolean itemIsInRoom(Item item) { // check if an item is in a room
        if (roomitems.indexOf(item) != -1)
            return true;
        else
            return false;
    }

    public Item getItem(String str) { // returns an item in the room
        for (int i=0; i<roomitems.size(); i++) {
            if (roomitems.get(i).name().toLowerCase().equals(str))
                return roomitems.get(i);
        }
        return null;
    }

    public void removeItem(Item item) {
        roomitems.remove(item);
    }

    public void addItem(Item item) {
        roomitems.add(item);
    }
}
