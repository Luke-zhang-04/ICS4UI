/**
 * Bridge-finding Robot Simulator
 * @author Luke Zhang
 */

import g4p_controls.*;

// Configurable with sliders
int bridgeX = 100;
int cgAlgoIncrement = 1; // Constant growth algo increment; amt to increase the distance each time
int multiAlgoMultipler = 2; // Multiplication algorithm multiplier
int pxPerStep = 15;         // Number of pixels in a step. The robot walks 1 step per frame
                            // Must be smaller than bridgeWidth
int robotStartX = 500;

// Configurable
final int fps = 30;
final int riverHeight = 200;
final int waveCount = 10;

// Not to be changed
final int animationWidth = 1000; // Width for displaying river and stuff without the stats section
final int bridgeWidth = 50;
boolean didChangeSliderValues = false;
final int initialPxPerStep = 15;
boolean isPaused = false;
Robot robot1;
Robot robot2;
boolean shouldMoveRobots = true; // First frame after reset, do not move the robots
Wave[] waves = new Wave[waveCount];

void togglePause() {
    togglePause(!isPaused);
}

void togglePause(boolean _isPaused) {
    isPaused = _isPaused;
    buttonPlay.setText(isPaused ? "Start" : "Stop");

    if (!isPaused && didChangeSliderValues) {
        reset();
        didChangeSliderValues = false;
    }
}

/** Handle ANY slider change */
void handleSliderChange() {
    didChangeSliderValues = true;
    togglePause(true);
}

void keyPressed() {
    if (key == ' ') {
        togglePause();
    } else if (key == 'r') {
        reset();
        isPaused = false;
    }
}

void setup() {
    size(1250, 600);
    frameRate(fps);

    for (int i = 0; i < waveCount; i++) {
        waves[i] = new Wave(); // Have to do this because new Wave[waveCount] doesn't instantiate?
    }

    // clang-format off
    // Path might break on Windows, not sure
    robot1 = new Robot(
        "./assets/media/robot1.png",
        "DA",
        multiAlgoMultipler,
        robotStartX,
        height / 2 - riverHeight / 2 - 100,
        #0049d6
    );
    robot2 = new Robot(
        "./assets/media/robot2.png",
        "CG",
        cgAlgoIncrement,
        robotStartX,
        height / 2 + riverHeight / 2 + 25,
        #d00e0e
    );
    // clang-format on

    createGUI();

    buttonPlay.setText(isPaused ? "Start" : "Stop");
    bridgeXSlider.setLimits(100, 0, animationWidth - bridgeWidth);
}

void drawRiver() {
    noStroke();
    fill(#0067a5);
    rect(0, height / 2 - riverHeight / 2, animationWidth, riverHeight);

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

    int multiplier = 1; // Multiplier for the scale

    if (pxPerStep <= 10) {
        multiplier = 10;
    } else if (pxPerStep <= 25) {
        multiplier = 5;
    } else if (pxPerStep <= 40) {
        multiplier = 3;
    } else if (pxPerStep <= 50) {
        multiplier = 2;
    }

    // Display scale at the bottom
    line(
        animationWidth - 10,
        height - 10,
        animationWidth - 10 - pxPerStep * multiplier,
        height - 10);
    strokeWeight(2);
    line(animationWidth - 10, height - 10, animationWidth - 10 - pxPerStep, height - 10);
    text(
        String.format("%d steps", multiplier),
        animationWidth - 10 - pxPerStep * multiplier,
        height - 20);

    // Stats section
    rect(width - 250, 0, 250, height);

    // Set the winner
    if (robot1.isAtBridge && !robot2.isWinner) {
        robot1.isWinner = true;
    } else if (robot2.isAtBridge && !robot1.isWinner) {
        robot2.isWinner = true;
    }

    drawRobotStats(robot1, 50, "Robot 1");
    drawRobotStats(robot2, 162, "Robot 2");
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

    shouldMoveRobots = false;
    redraw();
}
