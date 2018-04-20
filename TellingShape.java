import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class TellingShape {
	public static void main(String[] args) {
		Telling telling = new Telling();
		telling.init();
	}
	
}

class Telling {
	
	public static boolean clicked = false;
	public static int previousX = 0;
	public static int previousY = 0;
	int[] valueX;
	int[] valueY;
	public static int numX;
	public static int numY;
	
	public static int midX;
	public static int midY;
	
	public static int midXR;
	public static int midYR;
	
	public static int midXL;
	public static int midYL;

	private int dists[];
	
	List<Integer> setX = new ArrayList<Integer>();
	List<Integer> setY = new ArrayList<Integer>();
	
	private JLabel textL;
	public void init() {
		
		JFrame ui = new JFrame();
		ui.setSize(500,600);
		ui.setVisible(true);
		ui.setResizable(false);
		
		JPanel drawP = new JPanel();
		drawP.setBackground(Color.cyan);
		drawP.setSize(500,500);
		
		JPanel textP = new JPanel();
		textP.setBackground(Color.GREEN);
		textP.setSize(500,100);
		
		ui.add(textP);
		ui.add(drawP);
		
		textL = new JLabel();
		textP.add(textL);
		
		textL.setText("Please try to draw a circle in blue area");
		
		textL.setFont(textL.getFont().deriveFont(25.0f));
		textL.setForeground(Color.black);
		
		
		
		drawP.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent e) {
				setX.clear();
				setY.clear();
				midXR = 0;
				midXL = 1000;
				midYR = 0;
				midYL = 1000;
				valueX = null;
				valueY = null;
				
				dists = null;
				clear(drawP.getGraphics());
			}
			
			@Override
			public void mouseReleased(MouseEvent e) {
			
				convert();
			}
		});
		
		drawP.addMouseMotionListener(new MouseAdapter() {
			@Override
			public void mouseDragged(MouseEvent e) {

				setX.add(e.getX());
				setY.add(e.getY());
				paint(drawP.getGraphics(), e.getX(), e.getY());
			}
		});
		
		ui.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
	}
	
	public void convert() {
		numX = setX.size();
		numY = setY.size();
		
		valueX = new int[numX];
		valueY = new int[numY];
		
		for(int i = 0; i < numX; i++) {
			valueX[i] = setX.get(i);
			valueY[i] = setY.get(i);
		}
		
		calculate();
	}
	
	public void calculate() {

		for(int x:valueX) {
			if (x > midXR) {
				midXR = x;
			} 
			if (x < midXL) {
				midXL = x;
			}
		}
		
		for(int y:valueY) {
			if (y > midYR) {
				midYR = y;
			}
			if (y < midYL) {
				midYL = y;
			}
		}
		
		midX = (midXR + midXL) / 2;
		midY = (midYR + midYL) / 2;
		
		if (numX > numY) {
			dists = new int[numX];
		} else {
			dists = new int[numY];
		}
		
		for (int i = 0; i < dists.length; i++) {
			dists[i] = (int) Math.sqrt((valueX[i] - midX) *
					(valueX[i] - midX) +
					(valueY[i] - midY) *
					(valueY[i] - midY));
			

		}
		

		analysis(dists);
	}
	
	private void analysis(int[] dists2) {
		// TODO Auto-generated method stub
		double sd = 0;
		int sum  = 0;
		int average = 0;
		for (int i = 0; i < dists2.length; i++) {
			average += dists2[i];
		}
		
		average /= dists2.length;
		
		for (int i = 0; i < dists2.length; i++) {
			sum += (dists2[i] - average) * (dists2[i] - average);
		}
		
		sd = Math.sqrt(sum / dists2.length);
		
		if (sd == 0) {
			textL.setText("The object is too small");
		}
		
		for(int i = 0 ; i < dists2.length; i++) {
			System.out.println(dists2[i]);
		}
		
		System.out.println("____________" + sd);
		
		if(sd < 10 ) {
			textL.setText("The object is close to a circle");
		} else {
			textL.setText("The object is close to a Polygonal");
		}
	}

	public void clear(Graphics g) {
		g.setColor(Color.cyan);
		g.fillRect(0, 100, 500, 600);
		

	}
	
	public void paint(Graphics g, int x, int y) {
		if (y > 100) {
			g.drawOval(x, y, 2, 2);
		}
	}
}
