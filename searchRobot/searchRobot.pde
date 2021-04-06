/**
 * Bridge-finding Robot Simulator
 * @author Luke Zhang
 */

// Configurable
int riverHeight = 200;
int waveCount = 10;
int minBridgeDistance = 300;
int pxPerMeter = 10;
float robotStartX = 0.5; // 0.5 for middle
int cgAlgoIncrement = 5; // Constant growth algo increment; amt to increase the distance each time
int multiAlgoMultipler = 2; // Multiplication algorithm multiplier
int fps = 60;

Wave[] waves = new Wave[waveCount];
int bridgeX;
final int bridgeWidth = 50;
Robot robot1;
Robot robot2;

void setup() {
    size(1000, 500);
    frameRate(fps);

    for (int i = 0; i < waveCount; i++) {
        waves[i] = new Wave(); // Have to do this because new Wave[waveCount] doesn't instantiate?
    }

    bridgeX = random(0, 1) < 0.5                                         // Random side of bridge
        ? round(random(0, minBridgeDistance))                            // Bdige on left
        : round(random(width - minBridgeDistance, width - bridgeWidth)); // Bridge on right

    if (robotStartX < 1) {    // If robot start is smaller than 1
        robotStartX *= width; // Multiply by width
                              // E.g robotStartX = 0.5, and width = 200, robotStartX becomes 100
    }

    // Path might break on Windows, not sure
    robot1 = new Robot(
        "./assets/media/robot1.png",
        "multiply",
        multiAlgoMultipler,
        round(robotStartX / pxPerMeter),
        height / 2 - riverHeight / 2 - 100);
    robot2 = new Robot(
        "./assets/media/robot2.png",
        "add",
        cgAlgoIncrement,
        round(robotStartX / pxPerMeter),
        height / 2 + riverHeight / 2 + 25);
}

void drawRiver() {
    noStroke();
    fill(#0067a5);
    rect(0, height / 2 - riverHeight / 2, width, riverHeight);

    for (Wave wave : waves) {
        wave.move();
        wave.draw();
    }
}

void drawBridge() {
    fill(#966f33);
    strokeWeight(1);
    stroke(#000000);

    final int bridgeY = height / 2 - riverHeight / 2 - 25;
    final int bridgeHeight = riverHeight + 50;
    final int stripeCount = 6;

    rect(bridgeX, bridgeY, bridgeWidth, bridgeHeight);

    for (int stripe = 1; stripe <= stripeCount; stripe++) { // Draw stripes/lines on bridge
        line(
            bridgeX,
            bridgeY + (float(bridgeHeight) / stripeCount) * stripe,
            bridgeX + bridgeWidth,
            bridgeY + (float(bridgeHeight) / stripeCount) * stripe);
    }
}

void drawRobots() {
    robot1.move();
    robot2.move();

    robot1.draw();
    robot2.draw();
}

void draw() {
    background(#3d7d00);

    drawRiver();
    drawBridge();
    drawRobots();
}
