/**
 * Cellular Automaton: The Effects of First and Secondhand Smoking
 * @author Luke Zhang
 */

import java.util.Arrays;
import java.util.ArrayList;


// Configurable variables
final boolean canSmokeIndoors = true; // If people can smoke indoors
final int cellCount = 100;            // Number of cells
final float humanSpawnRate = 0.025;   // Percentage of humans/cell
final int indoorSmokeReach = 4;       // Reach of secondhand smoke exposure indoors
final int maxAge = 300;               // The max age of a human in frames
final int outdoorSmokeReach = 2;      // Reach of secondhand smoke exposure outdoors
final float popIncreaseRate = 0.0125; // Chance of a human being replaced by 2 humans
final float popDecreaseRate = 0.0125; // Change of a human being replaced by noone
final float shSmokeHealthLoss = 0.5;  // Amount of health lost for secondhand smoke
final float smokeChance = 0.75;       // Chance someone will smoke in a frame if they can
final float smokerHealthLoss = 1;     // Amount of health a smoker should lose for smoking
final float smokerRate = 0.12;        // Percentage of smokers against non-smokers.
                                      // As of 2019, the rate was 12%

// Number of frames someone can lose before being counted as a smoking death
final int smokingDeathThreshold = 5;

// Variables to change animation behaviour
final int fps = 30;                          // Frames per second
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
float averageSmokerAge = 0;
float averageNonsmokerAge = 0;
int totalDeaths = 0;
int smokerDeaths = 0;
int shSmokingDeaths = 0; // Secondhand smoking deaths
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


/**
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
 * @return if row, col are within the boundaries of the scene and peopleNow
 */
boolean coordsInBounds(int row, int col) {
    return (
        row >= 0 && col >= 0 &&            // Check for 0 indexes
        row < cellCount && col < cellCount // Check for larger than array indexes
    );
}


/**
 * Gets the total smoke exposure of person with coordinates row and col
 * @param person - the person object to refer to
 * @param row - row of person
 * @param col - column of person
 */
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

    // Apologize ahead of time for the mess
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
                    // Right next to another smoker
                    if (abs(yOffset) <= reach / 2 || abs(xOffset) <= reach / 2) {
                        totalExposure += random(0, 1) > 0.5 // Random chance of losing double
                            ? shSmokeHealthLoss
                            : shSmokeHealthLoss * 2;

                    } else if ( // Still able to breath in the smoke from a distance
                        (abs(yOffset) <= reach / 2 || abs(xOffset) <= reach / 2) &&
                        random(0, 1) > 0.5 // Only 50% chance of losing health
                    ) {
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
 * @param person - the person object to refer to
 * @param row - row of person
 * @param col - column of person
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
 * Draws scene people based on the people array.
 * Combined into one function and loop for efficiency
 */
void drawSceneAndPeople() {
    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            // Draw background scene
            if (scene[row][col]) {
                fill(255, 255, 255);
            } else {
                fill(0, 0, 0);
            }
            square(col * cellSize, row * cellSize, cellSize);

            // Draw person if they exist on row and col
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
    final int padding = 10;
    final int xCoord = min(width, height);
    final int fontsize = 20;

    textFont(createFont("sansserif", fontsize));

    fill(255, 255, 255);

    stroke(255, 255, 255);
    line(xCoord, 0, xCoord, height);
    noStroke();

    String[] stats = {
        String.format("Frames: %d", frameCount),
        String.format("Total deaths: %d", totalDeaths),
        String.format("Non smoking deaths:\n%d", totalDeaths - smokerDeaths),
        String.format("Smoking deaths: %d", smokerDeaths),
        String.format("Secondhand smoking deaths:\n%d", shSmokingDeaths),
        String.format(
            "Secondhand smoking death %%:\n%.2f%%",
            totalDeaths == 0 ? 0.0
                             : round((shSmokingDeaths / float(totalDeaths)) * 10000) / float(100)),
        String.format("Average smoker age:\n%.2f", averageSmokerAge),
        String.format("Average non-smoker age:\n%.2f", averageNonsmokerAge),
        String.format("Population: %d", currentPopulation),
    };

    // Display statistics
    for (int index = 0; index < stats.length; index++) {
        text(stats[index], xCoord + padding, index * (height / stats.length) + fontsize + padding);
    }
}


/**
 * Insert a new person at a random, null location in peopleNext.
 * Should be called when a person dies
 */
void insertNewPerson() {
    if (random(0, 1) < popDecreaseRate) {
        return;
    }

    final ArrayList<Integer[]> nullIndexes = new ArrayList<Integer[]>();

    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            if (peopleNext[row][col] == null) {
                final Integer[] coords = {row, col};

                nullIndexes.add(coords);
            }
        }
    }

    if (nullIndexes.size() == 0) {
        return;
    }

    final int newPersonIndex = round(random(0, nullIndexes.size()));
    final Integer[] newPersonCoords = nullIndexes.get(newPersonIndex);
    final boolean isSmoker = random(0, 1) < smokerRate;

    peopleNext[newPersonCoords[0]][newPersonCoords[1]] = isSmoker ? new Smoker() : new NonSmoker();

    if (random(0, 1) < popIncreaseRate) {
        nullIndexes.remove(newPersonIndex);

        final Integer[] newPerson2Coords = nullIndexes.get(round(random(0, nullIndexes.size())));
        final boolean isSmoker2 = random(0, 1) < smokerRate;

        peopleNext[newPerson2Coords[0]][newPerson2Coords[1]] =
            isSmoker2 ? new Smoker() : new NonSmoker();
    }
}


/**
 * Deals with the EOL (end of life, not end of line) of a person at row and col
 * @param person - the person object to refer to
 * @param row - row of person
 * @param col - column of person
 */
void handleEOL(Person person, int row, int col) {
    if (person.framesAlive < maxAge - smokingDeathThreshold) {
        if (person.isSmoker) {
            averageSmokerAge = // Calculate average from old average
                (averageSmokerAge * smokerDeaths + person.framesAlive) / (smokerDeaths + 1);
            smokerDeaths++;
        } else {
            shSmokingDeaths++;
        }
    }

    if (!person.isSmoker) {
        final int nonSmokerDeaths = totalDeaths - smokerDeaths;

        // Calculate average from old average
        averageNonsmokerAge =
            (averageNonsmokerAge * nonSmokerDeaths + person.framesAlive) / (nonSmokerDeaths + 1);
    }

    totalDeaths++;

    peopleNext[row][col] = null; // Just set the cell to null
                                 // The garbage collector will take care of the rest
    insertNewPerson();
}


/**
 * Causes a person to switch directions by chance
 * @param person - the person object to refer to
 * @param row - row of person
 * @param col - column of person
 */
void turnPerson(Person person, int row, int col) {
    final boolean shouldChangeCourse = random(0, 1) < 0.125;

    if (shouldChangeCourse) {
        final int direction = round(random(0, 4));
        final boolean canGoLeft = coordsInBounds(row - 3, col) && scene[row - 3][col];
        final boolean canGoRight = coordsInBounds(row + 3, col) && scene[row + 3][col];
        final boolean canGoUp = coordsInBounds(row, col + 3) && scene[row][col + 3];
        final boolean canGoDown = coordsInBounds(row, col - 3) && scene[row][col - 3];

        if (direction == 0 && canGoLeft) {
            person.direction.direction = 'l';
        } else if (direction == 1 && canGoRight) {
            person.direction.direction = 'r';
        } else if (direction == 2 && canGoDown) {
            person.direction.direction = 'd';
        } else if (direction == 3 && canGoUp) {
            person.direction.direction = 'u';
        }
    }
}


/**
 * Deals with a person at row and col
 * @param person - the person object to refer to
 * @param row - row of person
 * @param col - column of person
 */
void handlePerson(Person person, int row, int col) {
    currentPopulation++; // Increment currentPopulation
    person.framesAlive++;

    person.applyHealthLoss(getSmokeExposure(person, row, col)); // Apply loss with exposure

    // This person has reached their end of life :(
    if (person.health <= 0 || person.calculateRemainingLifespan(maxAge) <= 0) {
        handleEOL(person, row, col);

        return;
    }

    int newRow = row;
    int newCol = col;

    turnPerson(person, newRow, newCol);

    // Get new row and new col from direction and speed
    switch (person.direction.direction) {
        case 'u': newRow -= person.speed; break;
        case 'l': newCol -= person.speed; break;
        case 'd': newRow += person.speed; break;
        case 'r': newCol += person.speed; break;
    }

    if (!coordsInBounds(newRow, newCol)) {           // If the person has reached the boundaries
        person.direction.opposite();                 // Turn them around
    } else if (peopleNext[newRow][newCol] == null) { // If space is available
        peopleNext[newRow][newCol] = person;         // Move the person to the new space
        peopleNext[row][col] = null;                 // Empty the old space
    } else { // Person should move, but the target space isn't available
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
    drawSceneAndPeople();
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
