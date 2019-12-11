import java.util.Scanner;
import java.io.File;
import java.util.Vector;

import static java.lang.System.exit;

public class Application {
    public static void main(String[] args) {

        Scanner s = new Scanner(System.in);
        String str;
        String cmd = "";
        String val = "";
        boolean use1 = false;
        boolean use2 = false;
        boolean use3 = false;

        Vector<Room> rooms = new Vector();
        File rooms_folder = new File(args[0]);
        File[] room_files = rooms_folder.listFiles();

        if (room_files != null) {
            for (File file : room_files) {
                rooms.add(new Room(file));
            }
        }

        // player starts in first room in folder
        Player player = new Player(rooms.get(0));
        System.out.println(player.currentRoom().name());
        // while the player has not won
        while (!player.hasGameOver()) {
            System.out.print(">"); // indicates input required
            str = s.nextLine().toLowerCase();
            if (str.indexOf(' ') != -1) { // if there is a space in the command, there is a command and an argument
                for (int i = 0; i < str.indexOf(' '); i++)
                    cmd += str.charAt(i);
                for (int i = str.indexOf(' ') + 1; i < str.length(); i++) {
                    val += str.charAt(i);
                }
            } else // otherwise, the entire string is the command
                cmd = str;
            // print room description with 'look' command
            if (cmd.equals("look")) {
                System.out.println(player.currentRoom().description());
            }
            // room navigation
            else if (cmd.equals("go")) {
                if (val.equals("n") || val.equals("north")) {
                    roomNavigation(player, rooms, player.currentRoom().nroom());
                } else if (val.equals("e") || val.equals("east")) {
                    roomNavigation(player, rooms, player.currentRoom().eroom());
                } else if (val.equals("w") || val.equals("west")) {
                    roomNavigation(player, rooms, player.currentRoom().wroom());
                } else if (val.equals("s") || val.equals("south")) {
                    roomNavigation(player, rooms, player.currentRoom().sroom());
                } else if (val.equals("nw") || val.equals("northwest")) {
                    roomNavigation(player, rooms, player.currentRoom().nwroom());
                } else if (val.equals("ne") || val.equals("northeast")) {
                    roomNavigation(player, rooms, player.currentRoom().neroom());
                } else if (val.equals("sw") || val.equals("southwest")) {
                    roomNavigation(player, rooms, player.currentRoom().swroom());
                } else if (val.equals("se") || val.equals("southeast")) {
                    roomNavigation(player, rooms, player.currentRoom().seroom());
                } else
                    System.out.println("Go where?"); // direction not specified
            }// end of room navigation
            else if (cmd.equals("n") || cmd.equals("north")) {
                roomNavigation(player, rooms, player.currentRoom().nroom());
            } else if (cmd.equals("e") || cmd.equals("east")) {
                roomNavigation(player, rooms, player.currentRoom().eroom());
            } else if (cmd.equals("w") || cmd.equals("west")) {
                roomNavigation(player, rooms, player.currentRoom().wroom());
            } else if (cmd.equals("s") || cmd.equals("south")) {
                roomNavigation(player, rooms, player.currentRoom().sroom());
            } else if (cmd.equals("nw") || cmd.equals("northwest")) {
                roomNavigation(player, rooms, player.currentRoom().nwroom());
            } else if (cmd.equals("ne") || cmd.equals("northeast")) {
                roomNavigation(player, rooms, player.currentRoom().neroom());
            } else if (cmd.equals("sw") || cmd.equals("southwest")) {
                roomNavigation(player, rooms, player.currentRoom().swroom());
            } else if (cmd.equals("se") || cmd.equals("southeast")) {
                roomNavigation(player, rooms, player.currentRoom().seroom());
            }
            else if (cmd.equals("quit")) // quit the game
                exit(0);
            else if (cmd.equals("listen")) { // print value of listen attribute of room
                if (!player.currentRoom().listen().equals("")) // if there is a listen value for the room
                    System.out.println(player.currentRoom().listen());
                else
                    System.out.println("You don't hear anything out of the ordinary..."); // if there is not a listen value for the room
            } else if (cmd.equals("inventory")) // print player's current inventory
                player.listInv();
            else if (cmd.equals("examine")) { // examine an item either in the room or in the player's current inventory
                if (!val.equals("")) {
                    System.out.println(player.examineItemHelper(val));
                } else
                    System.out.println("Examine what?"); // if an item is not specified
            } else if (cmd.equals("take") || cmd.equals("get")) { // take an item in the room, if it can be taken
                if (!val.equals("")) {
                    System.out.println(player.takeItemHelper(val));
                } else
                    System.out.println("Take what?"); // no item specified to take
            } else if (cmd.equals("drop")) { // drop an item from player's inventory into the room
                if (!val.equals(""))
                    System.out.println(player.dropItemHelper(val));
                else
                    System.out.println("Drop what?"); // no item specified to drop
            } else if (cmd.equals("use")) {
                if (!val.equals("")) {
                    if ((val.toLowerCase().equals("gold key")) && ((player.hasItem("gold key")))) {
                        if (player.currentRoom().name().equals("CEO Office")) {
                            use1 = true;
                            System.out.println("I insert the gold key into the safe, and it fits.");
                        }
                        else
                            System.out.println("I can't use that here.");
                    }
                    else if ((val.toLowerCase().equals("silver key")) && ((player.hasItem("silver key")))) {
                        if (player.currentRoom().name().equals("CEO Office")) {
                            use2 = true;
                            System.out.println("I insert the silver key into the safe, and it fits.");
                        }
                        else
                            System.out.println("I can't use that here.");
                    }
                    else if ((val.toLowerCase().equals("bronze key")) && ((player.hasItem("bronze key")))) {
                        if (player.currentRoom().name().equals("CEO Office")) {
                            use3 = true;
                            System.out.println("I insert the bronze key into the safe, and it fits.");
                        }
                        else
                            System.out.println("I can't use that here.");
                    }
                    else
                        System.out.println("I don't know how to use that.");
                }
                else
                    System.out.println("Use what?");
            } else
                System.out.println("What?"); // player entered a command not supported
            if (use1 && use2 && use3) {
                System.out.println("You find all your company's assets locked away in this one safe. This is definitely not the way you planned on retiring, but you'll take it.");
                player.gameOver();
            }
            cmd = ""; // clear value for next iteration of loop
            val = ""; // clear value for next iteration of loop
        }
    }
    private static void roomNavigation(Player player, Vector<Room> rooms, String nextroom) {
        if (nextroom != null) { // if the next room exists
            for (Room i : rooms) { // find the next room in rooms vector
                if (i.name().equals(nextroom)){
                    player.setRoom(i);
                    System.out.println(player.currentRoom().name());
                }
            }
            if (player.currentRoom().gameOver()) {
                System.out.println(player.currentRoom().description());
                player.gameOver();
            }
        } else {
            System.out.println("You can't go that way."); // if the next room does not exist
        }
    }
}