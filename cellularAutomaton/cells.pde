/**
 * Represents a direction which is stored as a character.
 */
public
class Direction {
    public
    char direction;

    public
    Direction() {
        final char[] directions = {'u', 'd', 'l', 'r'};

        this.direction = directions[int(random(0, directions.length))];
    }

    public
    Direction(char direction) {
        this.direction = direction;
    }

    /**
     * Assigns this.direction to the opposite of the current direciton and returns the value
     * @return opposite direction
     */
    public
    char opposite() {
        switch (this.direction) {
            case 'u': this.direction = 'd'; break;
            case 'l': this.direction = 'r'; break;
            case 'd': this.direction = 'u'; break;

            // Case 'r':
            default: this.direction = 'l'; break;
        }

        return this.direction;
    }

    /**
     * Assigns this.direction to the left of the current direciton and returns the value
     * @return left direction
     */
    public
    char left() {
        switch (this.direction) {
            case 'u': this.direction = 'l'; break;
            case 'l': this.direction = 'd'; break;
            case 'd': this.direction = 'r'; break;

            // Case 'r':
            default: this.direction = 'u'; break;
        }

        return this.direction;
    }

    /**
     * Assigns this.direction to the right of the current direciton and returns the value
     * @return right direction
     */
    public
    char right() {
        switch (this.direction) {
            case 'u': this.direction = 'r'; break;
            case 'l': this.direction = 'u'; break;
            case 'd': this.direction = 'l'; break;

            // Case 'r':
            default: this.direction = 'd'; break;
        }

        return this.direction;
    }
}

/**
 * The base class for a person with all the shared properties of a smoker and non-smoker
 */
private abstract class Person {
    public
    int speed;

    public
    boolean isSmoker;

    public
    Direction direction = new Direction();

    public
    int health = 159;

    public
    int framesAlive = 0;

    public
    Person(boolean isSmoker, int speed) {
        this.isSmoker = isSmoker;
        this.speed = speed;
    }

    /**
     * Gets the colour of the cell with the type color
     * @return color of cell
     */
    public
    abstract color getColor();
}

/**
 * Represents a non smoker
 */
public class NonSmoker extends Person {
    private
    color _color = color(0, 255, 0);

    public
    NonSmoker() {
        super(false, round(random(1, 4)));
    }

    public
    int getColor() {
        return this._color;
    }
}

/**
 * Represents a smoker
 */
public class Smoker extends Person {
    private
    color _color = color(255, 0, 0);

    public
    Smoker() {
        super(true, round(random(1, 2)));
    }

    public
    int getColor() {
        return this._color;
    }
}
