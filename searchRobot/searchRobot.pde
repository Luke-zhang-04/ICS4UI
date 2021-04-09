/**
 * Bridge-finding Robot Simulator
 * @author Luke Zhang
 */

import g4p_controls.*;

// Configurable
int riverHeight = 200;
int waveCount = 10;
int pxPerStep = 15; // Number of pixels in a step. The robot walks 1 step per frame
                    // Must be smaller than bridgeWidth
int robotStartX = 500;
int cgAlgoIncrement = 1; // Constant growth algo increment; amt to increase the distance each time
int multiAlgoMultipler = 2; // Multiplication algorithm multiplier
int fps = 30;

final int initialPxPerStep = 15;
Wave[] waves = new Wave[waveCount];
int bridgeX = 100;
final int bridgeWidth = 50;
Robot robot1;
Robot robot2;
int displayWidth; // Width for displaying river and stuff, excluding the stats section
int startTime = millis();
int pauseTime = millis();
boolean isPaused = false;
boolean shouldMoveRobots = true; // First frame after reset, do not move the robots

void togglePause() {
    if (isPaused) {
        startTime += millis() - pauseTime;
    } else {
        pauseTime = millis();
    }

    isPaused = !isPaused;
}

void setup() {
    size(1250, 600);
    frameRate(fps);

    displayWidth = 1000;

    for (int i = 0; i < waveCount; i++) {
        waves[i] = new Wave(); // Have to do this because new Wave[waveCount] doesn't instantiate?
    }

    // clang-format off
    // Path might break on Windows, not sure
    robot1 = new Robot(
        "./assets/media/robot1.png",
        "multiply",
        multiAlgoMultipler,
        robotStartX,
        height / 2 - riverHeight / 2 - 100,
        #0049d6
    );
    robot2 = new Robot(
        "./assets/media/robot2.png",
        "add",
        cgAlgoIncrement,
        robotStartX,
        height / 2 + riverHeight / 2 + 25,
        #d00e0e
    );
    // clang-format on

    createGUI();
}

void drawRiver() {
    noStroke();
    fill(#0067a5);
    rect(0, height / 2 - riverHeight / 2, displayWidth, riverHeight);

    for (Wave wave : waves) {
        wave.move();
        wave.draw();
    }
}

/** Draw the bridge at bridgeX */
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

/** Move each robot and draw it */
void drawRobots() {
    if (!isPaused) {
        if (shouldMoveRobots) {
            robot1.move();
            robot2.move();
        } else {
            shouldMoveRobots = true;
        }
    }

    robot1.draw();
    robot2.draw();
}

/**
 * Draw the statistics for a robot
 * @param robot - robot object with information about a robot
 * @param yOffset - yOffset of stat text
 * @param name - name of robot e.g "robot 1", "robot 2"
 */
void drawRobotStats(Robot robot, int yOffset, String name) {
    textFont(createFont("sansserif", 25));
    fill(robot.robotColor);
    text(name, width - 225, yOffset);
    textFont(createFont("sansserif", 15));
    text(robot.toString(), width - 225, yOffset + 25);
}

void drawStats() {
    stroke(#000000);
    fill(#000000);
    strokeWeight(1);
    textFont(createFont("sansserif", 15));

    int multiplier = 1;

    if (pxPerStep <= 25) {
        multiplier = 5;
    } else if (pxPerStep <= 5) {
        multiplier = 2;
    }

    // Display scale at the bottom
    line(displayWidth - 10, height - 10, displayWidth - 10 - pxPerStep * multiplier, height - 10);
    strokeWeight(2);
    line(displayWidth - 10, height - 10, displayWidth - 10 - pxPerStep, height - 10);
    text(
        String.format("%d steps", multiplier),
        displayWidth - 10 - pxPerStep * multiplier,
        height - 20);

    // Stats section
    rect(width - 250, 0, 250, height);
    drawRobotStats(robot1, 50, "Robot 1");
    drawRobotStats(robot2, 200, "Robot 2");
}

void draw() {
    background(#3d7d00);

    drawRiver();
    drawBridge();
    drawRobots();
    drawStats();
}

void reset() {
    robot1.reset();
    robot2.reset();
    startTime = millis();

    shouldMoveRobots = false;
    redraw();
}