/**
 * Conway's Game of Life
 * @author Luke Zhang
 */

final int xSquareCount = 150;                 // Number of squares on y axis
final int ySquareCount = 150;                 // Number of squares on x axis
final int fps = 10;                           // Frames per second if not shouldWaitForKeypress
final boolean shouldShowGrid = true;          // If gridlines should be shown
final boolean shouldWaitForKeypress = false;  // If next frame should wait for spacebar
final char targetKey = ' ';                   // Key to wait for. Must be a single char
final color deadColor = color(0, 0, 0);       // Colour of dead cells
final color liveColor = color(255, 255, 255); // Colour of live cells
final String pattern = "checkerboard";        // Pattern. "checkerboard" | "random"
final float randomLiveThreshold = 0.6;        // Threshold for random to set a square to live

boolean[][] cellsNow = new boolean[ySquareCount][xSquareCount];  // Cells to show
boolean[][] cellsNext = new boolean[ySquareCount][xSquareCount]; // Cells to update
float squareSize; // The size of a square calculated based on width and height

void setup() {
    background(deadColor);
    size(900, 900);
    strokeWeight(0.5);
    frameRate(fps);

    squareSize = min(width, height) / min(xSquareCount, ySquareCount);

    if (shouldWaitForKeypress) { // Don't automatically move to next frame if we have to wait for
                                 // keypress
        noLoop();
    } else {
        loop();
    }

    if (pattern.equals("checkerboard")) { // Checkerboard
        for (int row = 0; row < cellsNow.length; row++) {
            for (int column = 0; column < cellsNow[row].length; column++) {
                cellsNow[row][column] = row % 2 == 0 // If even row
                    ? column % 2 == 0                // Then live cells on even columns
                    : column % 2 == 1;               // Else live cells on dead columns
            }
        }
    } else { // Random
        for (int row = 0; row < cellsNow.length; row++) {
            for (int column = 0; column < cellsNow[row].length; column++) {
                cellsNow[row][column] =
                    random(0, 1) >= randomLiveThreshold; // True if over threshold
            }
        }
    }

    // Copy cellsNow to cellsNext
    for (int row = 0; row < ySquareCount; row++) {
        for (int column = 0; column < xSquareCount; column++) {
            cellsNext[row][column] = cellsNow[row][column];
        }
    }
}

void keyPressed() {
    if (shouldWaitForKeypress && key == targetKey) { // Next frame if key pressed
        redraw();
    }
}

/**
 * Draws the cells from cellsNow and draws a white cell if true
 */
void drawCells() {
    if (!shouldShowGrid) {
        noStroke();
    }

    fill(liveColor);

    for (int row = 0; row < ySquareCount; row++) {
        for (int column = 0; column < xSquareCount; column++) {
            if (cellsNow[row][column]) { // If currentCell if true
                stroke(deadColor);

                square(column * squareSize, row * squareSize, squareSize);
            } else if (shouldShowGrid) { // If dead, but grid must be shown
                stroke(liveColor);
                fill(deadColor);

                square(column * squareSize, row * squareSize, squareSize);
                fill(liveColor);
            }
        }
    }
}

/**
 * Counts the alive neighbours from cellsNow[row][col]
 */
int countLiveNeighbours(int row, int col) {
    final int[][] neighbours = {
        {-1, -1},
        {-1, 0},
        {-1, 1},
        {0, -1},
        {0, 1},
        {1, -1},
        {1, 0},
        {1, 1},
    };
    int liveNeighbourCount = 0;

    for (int[] neighbour : neighbours) {
        final int newRow = row + neighbour[0]; // The neighbour row to check
        final int newCol = col + neighbour[1]; // The neighbour column
        final boolean isOutOfBounds =          // If index will be out of bounds
            newRow < 0 || newCol < 0 || newRow >= ySquareCount || newCol >= xSquareCount;

        if (!isOutOfBounds && cellsNow[newRow][newCol]) {
            liveNeighbourCount++;
        }
    }

    return liveNeighbourCount;
}

void updateCells() {
    for (int row = 0; row < ySquareCount; row++) {
        for (int column = 0; column < xSquareCount; column++) {
            final int liveNeighbourCount = countLiveNeighbours(row, column);

            /**
             * Apply the game of life rules
             * @see {@link https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules}
             */
            if (cellsNow[row][column]) {
                if (liveNeighbourCount < 2) {
                    cellsNext[row][column] = false;

                    // Skip 2 or 3; nothing changes Skip 2 or 3 since nothing changes
                } else if (liveNeighbourCount > 3) {
                    cellsNext[row][column] = false;
                }
            } else {
                if (liveNeighbourCount == 3) {
                    cellsNext[row][column] = true;
                }

                // Skip all other cases as nothing changes
            }
        }
    }

    // Copy cellsNext into cellsNow
    for (int row = 0; row < ySquareCount; row++) {
        for (int column = 0; column < xSquareCount; column++) {
            cellsNow[row][column] = cellsNext[row][column];
        }
    }
}

void draw() {
    background(deadColor);
    drawCells();
    updateCells();
}
