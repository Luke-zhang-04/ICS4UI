/**
 * Cellular Automaton: The Effects of First and Secondhand Smoking
 * @author Luke Zhang
 */

import java.util.Arrays;


// Configurable variables
final boolean canSmokeIndoors = true; // If people can smoke indoors
final int cellCount = 50;             // Number of cells
final float humanSpawnRate = 0.025;   // Percentage of humans/cell
final int indoorSmokeReach = 4;       // Reach of secondhand smoke exposure indoors
final int maxAge = 300;               // The max age of a human in frames
final int outdoorSmokeReach = 2;      // Reach of secondhand smoke exposure outdoors
final float shSmokeHealthLoss = 0.5;  // Amount of health lost for secondhand smoke
final float smokeChance = 0.75;       // Chance someone will smoke in a frame if they can
final float smokerHealthLoss = 1;     // Amount of health a smoker should lose for smoking
final float smokerRate = 0.12;        // Percentage of smokers against non-smokers.
                                      // As of 2019, the rate was 12%

// Variables to change animation behaviour
final int fps = 10;                          // Frames per second
final boolean shouldWaitForKeypress = false; // If the next frame should wait for a keypress
final char targetKey = ' ';                  // Key to wait for for next frame
                                             // Only applicable if shouldWaitForKeypress


// Do not change these

// Background scene that stays static. True for outdoor sidewalk, false for indoors
boolean[][] scene = new boolean[cellCount][cellCount];

// Arrays to store generations
Person[][] peopleNow = new Person[cellCount][cellCount];
Person[][] peopleNext = new Person[cellCount][cellCount];

// Size of a cell based on min(width, height) and cellCount
float cellSize;

// Statistics
int totalDeaths = 0;
int smokingDeaths = 0;
int currentPopulation = 0;


/**
 * Sets up the scene by filling the scene array with sidewalks
 */
void setupScene() {
    // Fill scene array with sidewalks
    int lastSidewalkDrawn = 2;

    for (int row = 0; row < scene.length - 3; row += 3) {
        if (lastSidewalkDrawn >= 2) {
            final boolean shouldDrawSidewalk = random(0, 100) >= 50;

            // Fill arrays with true or false
            Arrays.fill(scene[row], shouldDrawSidewalk);
            Arrays.fill(scene[row + 1], shouldDrawSidewalk);
            Arrays.fill(scene[row + 2], shouldDrawSidewalk);

            lastSidewalkDrawn = shouldDrawSidewalk ? 0 : lastSidewalkDrawn + 1;
        } else {
            Arrays.fill(scene[row], false);
            lastSidewalkDrawn++;
        }
    }

    lastSidewalkDrawn = 0;

    for (int col = 0; col < scene.length - 3; col += 3) {
        if (lastSidewalkDrawn >= 2) {
            final boolean shouldDrawSidewalk = random(0, 100) >= 50;

            if (shouldDrawSidewalk) {
                // Fill arrays with true and leave false as is
                for (int drawCol = col; drawCol < col + 3; drawCol++) {
                    for (int row = 0; row < scene.length; row++) {
                        scene[row][drawCol] = true;
                    }
                }

                lastSidewalkDrawn = 0;
            } else {
                lastSidewalkDrawn++;
            }
        } else {
            lastSidewalkDrawn++;
        }
    }
}


/**
 * Set up people in the scene in random locations
 */
void setupPeople() {
    for (int row = 0; row < cellCount; row++) {
        for (int column = 0; column < cellCount; column++) {
            final boolean shouldPlaceHuman = random(0, 1) < humanSpawnRate;

            if (shouldPlaceHuman) {
                final boolean isSmoker = random(0, 1) < smokerRate;

                peopleNow[row][column] = isSmoker ? new Smoker() : new NonSmoker();
            }
        }
    }
}


void setup() {
    size(1200, 900);
    background(0);
    noStroke();
    frameRate(fps);

    cellSize = min(height, width) / cellCount;

    setupScene();
    setupPeople();

    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            peopleNext[row][col] = peopleNow[row][col];
        }
    }

    if (shouldWaitForKeypress) {
        noLoop();
    } else {
        loop();
    }
}


/**38
 * Copies peopleNext -> peopleNow
 */
void copyNextCellGeneration() {
    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            peopleNow[row][col] = peopleNext[row][col];
        }
    }
}


/**
 * Checks if coordinates is in bounds
 * @param row - y coordinate
 * @param col - x coordinate
 */
boolean coordsInBounds(int row, int col) {
    return (
        row >= 0 && col >= 0 &&            // Check for 0 indexes
        row < cellCount && col < cellCount // Check for larger than array indexes
    );
}


float getSmokeExposure(Person person, int row, int col) {
    int reach;
    float totalExposure = 0;
    boolean isOutdoor;

    if (person.isSmoker) {
        /**
         * If smoker is indoors and smoking indoors isn't allowed
         * Or the person doesn't smoke
         */
        return scene[row][col] && !canSmokeIndoors || random(0, 1) > smokeChance
            ? 0                 // Don't lose health
            : smokerHealthLoss; // Otherwise, smoker smokes and looses health

    } else if (!scene[row][col]) { // If indoor
        if (canSmokeIndoors) {     // This person is indoors and smoking is allowed indoors
            reach = indoorSmokeReach;
            isOutdoor = false;
        } else {
            return 0; // This person is indoors, but they can't smoke indoors so nothing happens
        }
    } else { // This person is outdoors
        reach = outdoorSmokeReach;
        isOutdoor = true;
    }

    for (int yOffset = -reach; yOffset <= reach; yOffset++) {
        int yCoord = row - yOffset;
        boolean yCoordInBounds = yCoord >= 0 && yCoord < cellCount;

        if (yCoordInBounds) {
            for (int xOffset = -reach; xOffset <= reach; xOffset++) {
                int xCoord = col - xOffset;
                boolean xCoordInBounds = xCoord >= 0 && xCoord < cellCount;
                boolean isOrigin = xOffset == 0 && yOffset == 0; // Skip the current cell
                boolean hasSameLocation = xCoordInBounds && scene[yCoord][xCoord] == isOutdoor;

                if (!isOrigin && hasSameLocation && peopleNow[yCoord][xCoord] != null &&
                    peopleNow[yCoord][xCoord].isSmoker // If cell is a smoker
                ) {
                    println(reach, abs(yOffset) <= reach / 2, abs(xOffset) <= reach / 2);
                    if (abs(yOffset) <= reach / 2 || abs(xOffset) <= reach / 2) {
                        totalExposure +=
                            random(0, 1) > 0.5 ? shSmokeHealthLoss : shSmokeHealthLoss * 2;
                    } else if (
                        (abs(yOffset) <= reach / 2 || abs(xOffset) <= reach / 2) &&
                        random(0, 1) > 0.5) {
                        totalExposure += shSmokeHealthLoss;
                    }
                }
            }
        }
    }

    return totalExposure;
}


/**
 * Handles the overlapping of two people, where newRow and newCol would land on another person
 * @param row - row of person
 * @param col - column of person
 * @param person - the person object to modify
 */
void handlePersonOverlap(Person person, int row, int col) {
    final int[] forwardValues = {1, 2, 3, 4};
    final int[] sideValues = {-2, -1, 1, 2};
    final char direction = person.direction.direction;

    if (direction == 'd' || direction == 'u') {
        for (int val : forwardValues) {
            if (row + val >= 0 && row + val < cellCount && scene[row + val][col] &&
                peopleNext[row + val][col] == null) {
                peopleNext[row + val][col] = person;
                peopleNext[row][col] = null;

                return;
            }
        }

        for (int val : sideValues) {
            if (col + val >= 0 && col + val < cellCount && scene[row][col + val] &&
                peopleNext[row][col + val] == null) {
                peopleNext[row][col + val] = person;
                peopleNext[row][col] = null;

                return;
            }
        }

        if (random(0, 1) < 0.5) {
            person.direction.left();
        } else {
            person.direction.right();
        }

        return;
    }

    // Else clause for irection == 'l' || direction == 'r'
    for (int val : forwardValues) {
        if (col + val >= 0 && col + val < cellCount && scene[row][col + val] &&
            peopleNext[row][col + val] == null) {
            peopleNext[row][col + val] = person;
            peopleNext[row][col] = null;

            return;
        }
    }

    for (int val : sideValues) {
        if (row + val >= 0 && row + val < cellCount && scene[row + val][col] &&
            peopleNext[row + val][col] == null) {
            peopleNext[row + val][col] = person;
            peopleNext[row][col] = null;

            return;
        }
    }

    if (random(0, 1) < 0.5) {
        person.direction.left();
    } else {
        person.direction.right();
    }

    return;
}


/**
 * Draws the sidewalks
 */
void drawScene() {
    for (int row = 0; row < scene.length; row++) {
        for (int col = 0; col < scene[row].length; col++) {
            if (scene[row][col]) {
                fill(255, 255, 255);
            } else {
                fill(0, 0, 0);
            }
            square(row * cellSize, col * cellSize, cellSize);
        }
    }
}


/**
 * Draws people based on the people array
 */
void drawPeople() {
    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            Person person = peopleNow[row][col];

            if (person != null) {
                fill(person.getColor()); // Fill with the person's color

                square(col * cellSize, row * cellSize, cellSize);
            }
        }
    }
}


/**
 * Draws statistics such as frame count on the side of the screen
 */
void drawStats() {
    final int paddingLeft = 10;
    final int xCoord = min(width, height);

    textFont(createFont("sansserif", 30));

    fill(255, 255, 255);

    stroke(255, 255, 255);
    line(xCoord, 0, xCoord, height);
    noStroke();

    text(String.format("Frames: %d", frameCount), xCoord + paddingLeft, 100);
    text(String.format("Total Deaths: %d", totalDeaths), xCoord + paddingLeft, 200);
    text(String.format("Smoking deaths: %d", smokingDeaths), xCoord + paddingLeft, 300);
    text(
        String.format("Non smoking deaths:\n%d", totalDeaths - smokingDeaths),
        xCoord + paddingLeft,
        400);
    text(String.format("Population: %d", currentPopulation), xCoord + paddingLeft, 500);
}


void handlePerson(Person person, int row, int col) {
    currentPopulation++;
    person.framesAlive++;

    person.applyHealthLoss(getSmokeExposure(person, row, col));

    if (person.health <= 0 || person.calculateRemainingLifespan(maxAge) <= 0) {
        totalDeaths++;

        if (person.isSmoker) {
            smokingDeaths++;
        }

        peopleNext[row][col] = null; // Just set the cell to null
                                     // The garbage collector will take care of the rest

        return;
    }

    int newRow = row;
    int newCol = col;

    switch (person.direction.direction) {
        case 'u': newRow -= person.speed; break;
        case 'l': newCol -= person.speed; break;
        case 'd': newRow += person.speed; break;
        case 'r': newCol += person.speed; break;
    }

    if (!coordsInBounds(newRow, newCol)) {
        person.direction.opposite();
    } else if (peopleNext[newRow][newCol] == null) {
        peopleNext[newRow][newCol] = person;
        peopleNext[row][col] = null;
    } else {
        handlePersonOverlap(person, row, col);
    }
}


/**
 * Handels people by their speed and direction
 */
void handlePeople() {
    currentPopulation = 0; // Set currentPopulation in there loops while we're at it

    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            final Person person = peopleNow[row][col];

            if (person == null) {
                continue;
            } else if (person.framesAlive > maxAge) {
                peopleNext[row][col] = null;
                totalDeaths++;

                continue;
            }

            handlePerson(person, row, col);
        }
    }
}


void draw() {
    background(0);

    // Next generation
    drawScene();
    drawPeople();
    handlePeople();
    copyNextCellGeneration();
    drawStats();
}


/**
 * Handle keypress for debugging
 */
void keyPressed() {
    if (shouldWaitForKeypress && key == targetKey) {
        redraw();
    }
}
