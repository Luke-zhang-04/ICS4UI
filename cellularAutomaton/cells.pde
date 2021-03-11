/**
 * Cellular Automaton: The Effects of First and Secondhand Smoking
 * @author Luke Zhang
 */

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
    static final int initialHealth = 159;

    public
    final Direction direction = new Direction();

    public
    final boolean isSmoker;

    public
    color _color;

    public
    final int speed;

    public
    float health = Person.initialHealth;

    public
    int framesAlive = 0;

    public
    Person(boolean isSmoker, int speed) {
        this.isSmoker = isSmoker;
        this.speed = speed;
    }

    /**
     * Method to apply health loss by subtracting the overall health and adjusting the cell's
     * colour
     */
    public
    abstract void applyHealthLoss(float loss);

    /**
     * Have to make color readonly because for some reason everything turns black if I make color
     * public.
     */
    public
    abstract color getColor();

    /**
     * Calculates the remaining lifespan based on the lifespan of a human, their health level,
     * and their frames alive
     * @return this cells remaining lifespan in frames
     */
    public
    int calculateRemainingLifespan(int maxAge) {
        final int healthSub = round(75 - 6 * sqrt(this.health));

        return maxAge - this.framesAlive - max(healthSub, 0);
    }

    @Override public String toString() {
        return String.format(
            "%s with speed %d, direction %c, and health %d. Alive for %d frames.",
            this.isSmoker ? "Smoker" : "Non-smoker",
            this.speed,
            this.direction.direction,
            this.health,
            this.framesAlive);
    }
}


/**
 * Represents a non smoker
 */
public final class NonSmoker extends Person {
    private
    color _color = color(0, 255, 0);

    public
    NonSmoker() {
        super(false, round(random(1, 4)));
    }

    public
    void applyHealthLoss(float loss) {
        this.health -= loss;
        this._color = color(0, 255 - (Person.initialHealth - this.health), 0);
    }

    public
    color getColor() {
        return this._color;
    }
}

/**
 * Represents a smoker
 */
public final class Smoker extends Person {
    private
    color _color = color(255, 0, 0);

    public
    Smoker() {
        super(true, round(random(1, 2)));
    }

    public
    void applyHealthLoss(float loss) {
        this.health -= loss;
        this._color = color(255 - (Person.initialHealth - this.health), 0, 0);
    }

    public
    color getColor() {
        return this._color;
    }
}
