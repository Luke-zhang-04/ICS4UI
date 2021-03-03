/**
 * Cellular Automaton: The Effects of First and Secondhand Smoking
 * @author Luke Zhang
 */

import java.util.Arrays;

// Configurable variables
final int cellCount = 50;                    // Number of cells
final int fps = 10;                          // Frames per second
final float humanSpawnRate = 0.025;          // Percentage of humans/cell
final int maxAge = 300;                      // The max age of a human
final boolean shouldWaitForKeypress = false; // If the next frame should wait for a keypress
final float smokerRate = 0.12;               // Percentage of smokers against non-smokers.
                                             // As of 2019, the rate was 12%
final char targetKey = ' ';                  // Key to wait for for next frame
                                             // Only applicable if shouldWaitForKeypress

// Do not change these
boolean[][] scene = new boolean[cellCount][cellCount];
Person[][] peopleNow = new Person[cellCount][cellCount];
Person[][] peopleNext = new Person[cellCount][cellCount];
float cellSize;

void copyNextCellGeneration() {
    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            peopleNow[row][col] = peopleNext[row][col];
        }
    }
}

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
    size(900, 900);
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
 * Checks if person is in bounds
 * @param row - row of the person
 * @param col - column of the person
 */
boolean isInBounds(int row, int col) {
    return (
        row >= 0 && col >= 0 &&            // Check for 0 indexes
        row < cellCount && col < cellCount // Check for larger than array indexes
    );
}

/**
 * Handles the overlapping of two people, where newRow and newCol would land on another person
 * @param row - row of person
 * @param col - column of person
 * @param person - the person object to modify
 */
void handlePersonOverlap(int row, int col, Person person) {
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

void movePeople() {
    for (int row = 0; row < cellCount; row++) {
        for (int col = 0; col < cellCount; col++) {
            final Person person = peopleNow[row][col];

            if (person == null) {
                continue;
            } else if (person.framesAlive > maxAge) {
                peopleNext[row][col] = null;
                return;
            }

            person.framesAlive++;

            int newRow = row;
            int newCol = col;

            switch (person.direction.direction) {
                case 'u': newRow -= person.speed; break;
                case 'l': newCol -= person.speed; break;
                case 'd': newRow += person.speed; break;
                case 'r': newCol += person.speed; break;
            }

            if (!isInBounds(newRow, newCol)) {
                person.direction.opposite();
            } else if (peopleNext[newRow][newCol] == null) {
                peopleNext[newRow][newCol] = person;
                peopleNext[row][col] = null;
            } else {
                handlePersonOverlap(row, col, person);
            }
        }
    }
}

void draw() {
    background(0);

    // Next generation
    drawScene();
    drawPeople();
    movePeople();
    copyNextCellGeneration();
}

void keyPressed() {
    if (shouldWaitForKeypress && key == targetKey) {
        redraw();
    }
}
