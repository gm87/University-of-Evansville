import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;

public class ChessSquare extends JPanel {
    public ChessSquare(int i, String s) {
        if ((i / 8 + i % 8) % 2 == 1) {
            this.setBackground(Color.gray);
        }
        if (!s.isEmpty())
            addImage(s);
    }

    public void addImage(String file) {
        try {
            BufferedImage image = ImageIO.read(getClass().getClassLoader().getResource(file));
            JLabel picLabel = new JLabel(new ImageIcon(image));
            this.add(picLabel);
        } catch (IOException e) {
            System.out.println("Unable to read image from file: " + file);
        }
    }
}
