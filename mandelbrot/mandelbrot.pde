/**
 * Mandelbrot Set
 * @author Luke Zhang
 */

final int iterLimit = 200;
float xSlope;
float ySlope;

void setup() {
    size(1000, 1000);

    xSlope = 3.0 / width;
    ySlope = 3.0 / height;

    background(0);

    noLoop();
}

float getA(int xCoord) {
    return xSlope * xCoord - 2;
}

float getB(int yCoord) {
    return ySlope * yCoord - 1.5;
}

boolean isInSet(Complex num, Complex constant, int iterations) {
    if (iterations < iterLimit) {
        return num.absVal() < 2 && isInSet(num.squared().add(constant), constant, iterations + 1);
    }

    return true;
}

boolean isInSet(Complex num) {
    return isInSet(num, num, 0);
}

void keyPressed() {
    if (key == CODED) {
        if (keyCode == UP) {}
    }
}

void draw() {
    fill(255, 255, 255);
    stroke(255, 255, 255);
    strokeWeight(2); // Stroke weight 2 because the set will turn grey if smaller

    for (int xCoord = 0; xCoord < width; xCoord++) {
        float a = getA(xCoord);

        for (int yCoord = 0; yCoord < height; yCoord++) {
            float b = getB(yCoord);
            Complex currentPoint = new Complex(a, b);

            if (isInSet(currentPoint)) {
                point(xCoord, yCoord);
            }
        }
    }
}
