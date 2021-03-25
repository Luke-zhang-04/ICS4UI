/**
 * Mandelbrot Set
 * @author Luke Zhang
 */

final boolean shouldShowCenter = false; // If a "crosshair" in the center should be shown
final int iterLimit = 200;              // Limit for checking a point
                                        // The higher the slower but more accurate
final int increment = 1; // Increment for dots. Recommended 1, but can be increased for performance
                         // If the value is 2, it will run 2x as fast with 1/2 the resolution.
                         // Drawing many dots is the main cause of slow performance

float zoomFactor = 1;

float aMin = -2.0 / zoomFactor;
float aMax = 1.0 / zoomFactor;
float xSlope = (aMax - aMin) / 1000;

float bMin = 1.5 / zoomFactor;
float bMax = -1.5 / zoomFactor;
float ySlope = (bMin - bMax) / 1000;

float xOffset = 0;
float yOffset = 0;

void setup() {
    size(1000, 1000);

    background(0);

    // Overrides for cool patterns
    // zoomFactor = 225;

    // aMin = -2.0 / zoomFactor;
    // aMax = 1.0 / zoomFactor;
    // xSlope = (aMax - aMin) / 1000;

    // bMin = 1.5 / zoomFactor;
    // bMax = -1.5 / zoomFactor;
    // ySlope = (bMin - bMax) / 1000;

    // xOffset = -0.256;
    // yOffset = -0.65;

    noLoop();
}

float getA(int xCoord) {
    return xSlope * xCoord + aMin + xOffset;
}

float getB(int yCoord) {
    return ySlope * yCoord + bMax + yOffset;
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

void draw() {
    background(0);
    fill(255, 255, 255);
    stroke(255, 255, 255);
    strokeWeight(increment * 2); // Stroke weight 2 because the set will turn grey if smaller

    for (int xCoord = 0; xCoord < width; xCoord += increment) {
        float a = getA(xCoord);

        for (int yCoord = 0; yCoord < height; yCoord += increment) {
            float b = getB(yCoord);
            Complex currentPoint = new Complex(a, b);

            if (isInSet(currentPoint)) {
                point(xCoord, yCoord);
            }
        }
    }

    if (shouldShowCenter) {
        stroke(255, 0, 0);
        line(this.width / 2, 0, this.width / 2, this.height);
        line(0, this.height / 2, this.width, this.height / 2);
    }

    println("Done!");
}
