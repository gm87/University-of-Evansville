import java.util.Vector;

public class Player {
    private Room room;
    private Vector<Item> inventory = new Vector();
    private boolean hasGameOver = false;

    public Player (Room room) {
        this.room = room;
    } // constructor, takes room argument as first room

    public void setRoom (Room room) {
        this.room = room;
    } // sets player into specified room

    public Room currentRoom () {
        return this.room;
    } // returns current room item that player is in

    public boolean hasGameOver() {
        return hasGameOver;
    } // returns current gameOver status, true if game is over

    public void gameOver() {
        hasGameOver = true;
    } // sets gameOver status to true, ending the game

    public boolean hasItem(String val) { // checks if player has item in inventory
        for (Item i : inventory) {
            if (i.name().toLowerCase().equals(val))
                return true;
        }
        return false;
    }

    public void listInv () { // list player's inventory
        if (inventory.isEmpty())
            System.out.println("You have nothing.");
        else {
            for (Item item : inventory) {
                System.out.println(item.name());
            }
        }
    }

    public String examineItemHelper(String str) { // finds item in inventory or room and returns its description if found
        if (room.getItem(str) != null)
            return examineItem(room.getItem(str));
        else if (getInvItem(str) != null)
            return examineItem(getInvItem(str));
        else
            return "I don't see that.";
    }

    public String takeItemHelper(String str) { // finds item in room and takes it if found
        if (room.getItem(str) != null) {
            if (room.getItem(str).pickup()) {
                takeItem(room.getItem(str));
                return "I took the " + str + ".";
            }
            else
                return "I can't take that.";
        }
        else
            return "I don't see the " + str + ".";
    }

    public String dropItemHelper(String str) { // drops item in player's inventory if found
        if (getInvItem(str) != null) {
            dropItem(getInvItem(str));
            return "I dropped the " + str + " here.";
        }
        else
            return "I don't have a " + str + " to drop.";
    }

    private void dropItem(Item invItem) {
        inventory.remove(invItem);
        room.addItem(invItem);
    }

    private void takeItem(Item item) {
        inventory.add(item);
        room.removeItem(item);
    }

    public String examineItem (Item item) {
        if ((inventory.indexOf(item) != -1) || (room.itemIsInRoom(item)))
            return item.examine();
        else
            return "I don't see it.";
    }

    private Item getInvItem (String str) {
        for (Item item : inventory) {
            if (item.name().toLowerCase().equals(str))
                return item;
        }
        return null;
    }
}