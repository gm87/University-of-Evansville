import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Item {
    private String name;
    private String examine;
    private Boolean pickup;

    public Item(File input) {
        try {
            Scanner scanner = new Scanner(input);
            while (scanner.hasNextLine()) {
                String s = scanner.nextLine();
                StringBuilder attribute = new StringBuilder();
                StringBuilder value = new StringBuilder();
                for (int i=0; i<s.indexOf(':'); i++)
                    attribute.append(s.charAt(i));
                for (int i=s.indexOf(':')+2; i<s.length(); i++)
                    value.append(s.charAt(i));
                if (attribute.toString().equals("name")) { this.name = value.toString(); }
                else if (attribute.toString().equals("examine")) { this.examine = value.toString(); }
                else if (attribute.toString().equals("pickup")) {
                    if (value.toString().equals("true"))
                        pickup = true;
                    else if (value.toString().equals("false"))
                        pickup = false;
                }
                else { System.out.println("Attribute: " + attribute + " not valid."); }
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public String name() { return this.name; }

    public String examine() { return this.examine; }

    public boolean pickup() { return this.pickup; }

}
