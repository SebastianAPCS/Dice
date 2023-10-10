/*

Created by Sebastian Dowell in  October 2023 for Mr. Chan's APCSA class.

*/

Die die1;

void setup() {
    size(800, 600);
}

void draw() {
    background(0);

    if (die1 == null) {
        die1 = new Die(0, 0, 0, 100, 2.0, 255, 0, 0);
        die1.updateTransform();
    }

    // Update rotation angles continuously
    die1.angles[0] += 1; // Adjust the rotation speed as needed
    die1.angles[1] += 1;

    die1.show();

    ArrayList<Quadrilateral> quads = die1.initializeDie(die1.x, die1.y, die1.z, die1.p);
    for (Quadrilateral quad : quads) {
        System.out.println("Vertices of Quadrilateral:");
        System.out.println("v1: (" + quad.v1.x + ", " + quad.v1.y + ", " + quad.v1.z + ")");
        System.out.println("v2: (" + quad.v2.x + ", " + quad.v2.y + ", " + quad.v2.z + ")");
        System.out.println("v3: (" + quad.v3.x + ", " + quad.v3.y + ", " + quad.v3.z + ")");
        System.out.println("v4: (" + quad.v4.x + ", " + quad.v4.y + ", " + quad.v4.z + ")");
    }

    // Continuously redraw
    redraw();
}

void mousePressed() {
    redraw();
}

class Die {
    // Die coordinates
    int x;
    int y;
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
  
    Die(int x, int y, int z, double p, float w, int rc, int gc, int bc) {
        this.x = x;
        this.y = y;
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
    
    void show() {
        ArrayList<Quadrilateral> d = initializeDie(x, y, z, p);
        
        updateTransform();
        
        System.out.println("D:" + d);
        renderQuadrilateral(d, w, rc, gc, bc);
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
        
        System.out.println("Q:" + q);
        return q;
    }
    
    void renderQuadrilateral(ArrayList<Quadrilateral> quads, float w, int rc, int gc, int bc) {
        System.out.println("Quads:" + quads);
        for (Quadrilateral quad : quads) {
            // v1, v2, v3, v4, and c must be defined
            System.out.println("Quad: " + quad);
    
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
