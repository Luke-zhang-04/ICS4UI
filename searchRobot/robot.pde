/**
 * Bridge-finding Robot Simulator
 * @author Luke Zhang
 */

class Robot {
    /** Width and height of robot images */
    public
    static final int dimensions = 75;

    public
    final PImage img;

    public
    final String algo;

    public
    final int robotColor;

    /**
     * Factor at which the distance changes. If algo is adding, it grows constantly by algoFactor.
     * If algo is multiplying, it multiplies by algoFactor
     */
    public
    int algoFactor;

    /** Y coord of the bot relative to the whole screen in pixels */
    public
    final int y;

    /** Distance travelled in steps */
    public
    int distanceTravelled = 0;

    /** The origin of the bots movements relative to the whole screen in pixels */
    public
    int origin;

    public
    boolean isAtBridge = false;

    public
    boolean isWinner = false;

    /** Number of steps the robot has taken */
    public
    int stepCount = 0;

    /** Number of turns the robot made */
    public
    int turnCount = 0;

    /** Speed multiplier of robot */
    public
    int speed;

    private
    int _direction = -1;

    /** X coordinate of the bot relative to the origin in steps (not pixels) */
    private
    int _x = 0;

    /** The next destination of the bot relative to the origin in steps */
    private
    int _nextTarget = 0;

    /** Marker lines for where the robot made a turn */
    private
    ArrayList<Point> _markerLines = new ArrayList<Point>();

    // clang-format off
    public
    Robot(
        String imagePath,
        String algo,
        int algoFactor,
        int origin,
        int y,
        int robotColor,
        int speed
    ) {
        this.img = loadImage(imagePath);
        this.algo = algo;
        this.algoFactor = algoFactor;
        this.origin = origin;
        this.y = y;
        this.robotColor = robotColor;
        this.speed = speed;
    }

    public
    Robot(
        String imagePath,
        String algo,
        int algoFactor,
        int origin,
        int y,
        int robotColor
    ) {
        this(imagePath, algo, algoFactor, origin, y, robotColor, 1);
    }
    // clang-format on

    public
    String getAlgo() {
        return this.algo.equals("CG") ? String.format("Constant Growth by %d", this.algoFactor)
                                      : String.format("Multiply by %d", this.algoFactor);
    }

    public
    void draw() {
        image(
            this.img,
            this.getAbsolutePosition(Robot.dimensions),
            this.y,
            Robot.dimensions,
            Robot.dimensions);

        for (Point marker : this._markerLines) {
            line(marker.x, marker.y, marker.x, marker.y + 50);
        }
    }

    public
    void move() {
        if (!this.isAtBridge) {
            if (this._direction == 1 && this._x >= this._nextTarget ||
                this._direction == -1 && this._x <= this._nextTarget) {
                this._handleTurn();
            }

            int nextLocation = this._x + this._direction * this.speed;

            // Don't overshoot the turning point
            if (this._direction == 1 && nextLocation > this._nextTarget ||
                this._direction == -1 && nextLocation < this._nextTarget) {
                this.stepCount += nextLocation - this._x;
                this._x = this._nextTarget;
            } else {
                this._x = nextLocation;
                this.stepCount += this.speed;
            }

            this.isAtBridge = this._checkAtBridge();
        }
    }

    public
    void reset() {
        this._markerLines.clear();
        this.distanceTravelled = 0;
        this.stepCount = 0;
        this.turnCount = 0;
        this._x = 0;
        this._nextTarget = 0;
        this._direction = -1;
        this.isAtBridge = false;
        this.isWinner = false;
    }

    /** Get the absolute position of the left of the robot image in pixels, subtracted by offset */
    public
    float getAbsolutePosition(int offset) {
        return this.origin + this._x * pxPerStep - offset;
    }

    /** Get the absolute position of the centre of the robot image in pixels */
    public
    float getAbsolutePosition() {
        return this.origin + this._x * pxPerStep - Robot.dimensions / 2;
    }

    @Override public String toString() {
        return String.format(
            "Algo: %s\nSteps: %d\nDone: %s%s",
            this.getAlgo(),
            this.stepCount,
            this.isAtBridge ? "yes" : "no",
            this.isWinner ? " (winner)" : "");
    }

    /** Check if the robot is at the bridge */
    private
    boolean _checkAtBridge() {
        final float robotPosition = this.getAbsolutePosition();

        return bridgeX < this.origin ? robotPosition <= bridgeX + bridgeWidth
                                     : robotPosition >= bridgeX;
    }

    /** Handle the robot making a turn */
    private
    void _handleTurn() {
        this._direction *= -1;
        this.turnCount++;
        this._nextTarget = this._getNextTarget();
        this._markerLines.add(new Point(this.getAbsolutePosition(), this.y));
    }

    /** Calculate how far the robot needs to move next in steps (not pixels) */
    private
    int _calculateMoveDistance() {
        return this.algo.equals("CG") ? this.algoFactor * this.turnCount
                                      : int(pow(this.algoFactor, this.turnCount));
    }

    /** Calculate where the robot should move next in steps */
    private
    int _getNextTarget() {
        return this._direction == 1 ? this._x + this._calculateMoveDistance()
                                    : this._x - this._calculateMoveDistance();
    }
}
