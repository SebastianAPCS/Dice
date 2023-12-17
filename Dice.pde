/*

Created by Sebastian Dowell in  October 2023 for Mr. Chan's APCSA class.

*/

ArrayList<Die> dice = new ArrayList(); // NullPointerException, needs initialization (will cause code to fail otherwise)

Die die1 = new Die(-200, 0, 0, 50, 2.0, 255, 0, 0);
Die die2 = new Die(0, 0, 0, 50, 2.0, 255, 0, 0);
Die die3 = new Die(200, 0, 0, 50, 2.0, 255, 0, 0);
Die die4 = new Die(-200, 200, 0, 50, 2.0, 255, 0, 0);
Die die5 = new Die(0, 200, 0, 50, 2.0, 255, 0, 0);
Die die6 = new Die(200, 200, 0, 50, 2.0, 255, 0, 0);
Die die7 = new Die(-200, -200, 0, 50, 2.0, 255, 0, 0);
Die die8 = new Die(0, -200, 0, 50, 2.0, 255, 0, 0);
Die die9 = new Die(200, -200, 0, 50, 2.0, 255, 0, 0);

Die[] diceArray = {die1, die2, die3, die4, die5, die6, die7, die8, die9};

double speed = 6;

void setup() {
    size(800, 600);
    fill(255, 0, 0);
    
    for (Die die : diceArray) {
        die.roll();
    }
}

void draw() {
    background(0);

    if (speed > 0 && die1.angles[0] < 360) {
        background(0);

        for (Die die : diceArray) {
            die.updateTransform();
            die.angles[0] += speed;
            die.angles[1] += speed;
            die.show();
        }

        if (speed < 0.5) {
            speed = 0.5;
        } else {
            speed -= 0.05;
        }
    } else {
        speed = 0;
        background(0);

        Die[] diceArray = {die1, die2, die3, die4, die5, die6, die7, die8, die9};

        for (Die die : diceArray) {
            die.angles[0] = 0;
            die.angles[1] = 0;
            die.show();
            die.renderFace(0, 0, 70, 0.4);
        }
        
        displayTotal();
    }
}


void mousePressed() {
    for (Die die : diceArray) {
        die.roll();
    }
    die1.angles[0] = 0;
    speed = 6;
}

void displayTotal() {
    int total = die1.getNum() + die2.getNum() + die3.getNum()
              + die4.getNum() + die5.getNum() + die6.getNum()
              + die7.getNum() + die8.getNum() + die9.getNum();
    
    textSize(70);
    
    pushMatrix();
    translate(width/2, height/2);
    text("Total: " + total, -130, -75);
    popMatrix();
}

class Die {
    // Die coordinates
    int xdiff;
    int ydiff;
    int x = 0;
    int y = 0;
    int z;
    
    // Apothem of square
    double p;
    
    // Stroke Width
    float w;
    
    // Die number
    int num;
    
    // Required declarations for 3D
    Matrix3 transform;
    float[] angles = new float[2];
    
    // Stroke Color
    int rc;
    int gc;
    int bc;
  
    Die(int xdiff, int ydiff, int z, double p, float w, int rc, int gc, int bc) {
        this.xdiff = xdiff;
        this.ydiff = ydiff;
        this.z = z;
        this.p = p;
        this.w = w;
        this.rc = rc;
        this.gc = gc;
        this.bc = bc;
        
        angles[0] = 0;
        angles[1] = 0;
    }
    
    void roll() {
        num = (int) (Math.random() * 6 + 1);
    }
    
    int getNum() {
      return num;
    }
    
    void show() {
        ArrayList<Quadrilateral> d = initializeDie(x, y, z, p);
        
        updateTransform();
        
        pushMatrix();
        translate((width / 2) + xdiff, (height / 2) + ydiff);
        renderQuadrilateral(d, w, rc, gc, bc);
        popMatrix();
    }
  
    void updateTransform() {
        float heading = radians(angles[0]);
        Matrix3 headingTransform = new Matrix3(new double[]{
            cos(heading), 0, -sin(heading),
            0, 1, 0,
            sin(heading), 0, cos(heading)
        });
    
        float pitch = radians(angles[1]);
        Matrix3 pitchTransform = new Matrix3(new double[]{
            1, 0, 0,
            0, cos(pitch), sin(pitch),
            0, -sin(pitch), cos(pitch)
        });
    
        transform = headingTransform.multiply(pitchTransform);
    }
    
    ArrayList initializeDie(int x, int y, int z, double p) {
        // Example: p = 100, x, y, z = 0 -> Dice with width of 200 centered at (0, 0, 0)
        
        ArrayList<Quadrilateral> q = new ArrayList<Quadrilateral>();
        Vertex r1 = new Vertex((int)(x + p), (int)(y + p), (int)(z + p));
        Vertex r2 = new Vertex((int)(x - p), (int)(y + p), (int)(z + p));
        Vertex r3 = new Vertex((int)(x - p), (int)(y - p), (int)(z + p));
        Vertex r4 = new Vertex((int)(x + p), (int)(y - p), (int)(z + p));
        Vertex r5 = new Vertex((int)(x + p), (int)(y + p), (int)(z - p));
        Vertex r6 = new Vertex((int)(x - p), (int)(y + p), (int)(z - p));
        Vertex r7 = new Vertex((int)(x - p), (int)(y - p), (int)(z - p));
        Vertex r8 = new Vertex((int)(x + p), (int)(y - p), (int)(z - p));

        q.add(new Quadrilateral(r1, r2, r3, r4));
        q.add(new Quadrilateral(r5, r6, r7, r8));
        q.add(new Quadrilateral(r1, r2, r6, r5));
        q.add(new Quadrilateral(r2, r3, r7, r6));
        q.add(new Quadrilateral(r3, r4, r8, r7));
        q.add(new Quadrilateral(r1, r4, r8, r5));
        
        //System.out.println("Q:" + q);
        return q;
    }
    
    void renderQuadrilateral(ArrayList<Quadrilateral> quads, float w, int rc, int gc, int bc) {
        //System.out.println("Quads:" + quads);
        for (Quadrilateral quad : quads) {
            // v1, v2, v3, v4, and c must be defined
            //System.out.println("Quad: " + quad);
    
            Vertex v1 = transform.transform(quad.v1);
            Vertex v2 = transform.transform(quad.v2);
            Vertex v3 = transform.transform(quad.v3);
            Vertex v4 = transform.transform(quad.v4);
            
            stroke(rc, bc, gc);
            strokeWeight(w);
        
            line((float) v1.x, (float) v1.y, (float) v2.x, (float) v2.y);
            line((float) v2.x, (float) v2.y, (float) v3.x, (float) v3.y);
            line((float) v3.x, (float) v3.y, (float) v4.x, (float) v4.y);
            line((float) v4.x, (float) v4.y, (float) v1.x, (float) v1.y);
        }  
    }
    
    void renderFace(int centerX, int centerY, int w, float s) {
        pushMatrix();
        translate((width / 2) + xdiff, (height / 2) + ydiff);
        
        switch(num) {
            case 1:
                circle(centerX, centerY, w/5);
                break;
            case 2:
                circle(centerX - (w * s), centerY - (w * s), w/5);
                circle(centerX + (w * s), centerY + (w * s), w/5);
                break;
            case 3:
                circle(centerX - (w * s), centerY - (w * s), w/5);
                circle(centerX, centerY, w/5);
                circle(centerX + (w * s), centerY + (w * s), w/5);
                break;
            case 4:
                circle(centerX - (w * s), centerY - (w * s), w/5);
                circle(centerX + (w * s), centerY + (w * s), w/5);
                circle(centerX - (w * s), centerY + (w * s), w/5);
                circle(centerX + (w * s), centerY - (w * s), w/5);
                break;
            case 5:
                circle(centerX - (w * s), centerY - (w * s), w/5);
                circle(centerX + (w * s), centerY + (w * s), w/5);
                circle(centerX - (w * s), centerY + (w * s), w/5);
                circle(centerX + (w * s), centerY - (w * s), w/5);
                circle(centerX, centerY, w/5);
                break;
            case 6:
                circle(centerX - (w * s), centerY - (w * s), w/5);
                circle(centerX + (w * s), centerY + (w * s), w/5);
                circle(centerX - (w * s), centerY + (w * s), w/5);
                circle(centerX + (w * s), centerY - (w * s), w/5);
                circle(centerX - (w * s), centerY, w/5);
                circle(centerX + (w * s), centerY, w/5);
                break;
        }
        
        popMatrix();
    }
}

class Vertex {
    double x;
    double y;
    double z;
    
    Vertex(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}

class Quadrilateral {
    Vertex v1;
    Vertex v2;
    Vertex v3;
    Vertex v4;
    
    Quadrilateral(Vertex v1, Vertex v2, Vertex v3, Vertex v4) {
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
        this.v4 = v4;
    }
}

class Matrix3 {
    double[] values;
    
    Matrix3(double[] values) {
        this.values = values;
    }
    
    Matrix3 multiply(Matrix3 other) {
        double[] result = new double[9];
        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 3; col++) {
                for (int i = 0; i < 3; i++) {
                    result[row * 3 + col] +=
                        this.values[row * 3 + i] * other.values[i * 3 + col];
                }
            }
        }
        return new Matrix3(result);
    }
    
    Vertex transform(Vertex vinput) {
        return new Vertex(
            vinput.x * values[0] + vinput.y * values[3] + vinput.z * values[6],
            vinput.x * values[1] + vinput.y * values[4] + vinput.z * values[7],
            vinput.x * values[2] + vinput.y * values[5] + vinput.z * values[8]
        );
    }
}
