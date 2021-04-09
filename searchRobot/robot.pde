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

    public
    final int algoFactor;

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
    int stepCount = 0;

    public
    int turnCount = 0;

    public
    int elapsedTime = 0;

    public
    int speed;

    private
    int _direction = -1;

    /** X coordinate of the bot relative to the origin in steps (not pixels) */
    private
    int _x = 0;

    private
    int _nextTarget = 0;

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
        return this.algo.equals("add") ? String.format("Constant Growth by %d", this.algoFactor)
                                       : String.format("Multiply by %d", this.algoFactor);
    }

    public
    void offsetStep(int step) {}

    public
    void draw() {
        image(
            this.img,
            this.origin + this._x * pxPerStep - Robot.dimensions,
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

            this._x += this._direction * this.speed;
            this.stepCount += this.speed;

            this.isAtBridge = this._checkAtBridge();

            if (this.isAtBridge) {
                this.elapsedTime = millis() - startTime;
            }
        }
    }

    public
    void reset() {
        this._markerLines.clear();
        this.distanceTravelled = 0;
        this.stepCount = 0;
        this.turnCount = 0;
        this.elapsedTime = 0;
        this._x = 0;
        this._nextTarget = 0;
        this._direction = -1;
        this.isAtBridge = false;
    }

    @Override public String toString() {
        final float time = this.elapsedTime == 0
            ? float((isPaused ? pauseTime : millis()) - startTime) / 1000
            : float(this.elapsedTime) / 1000;

        return String.format(
            "Algo: %s\nSteps: %d\nDone: %s\nElapsed time: %.2fs",
            this.getAlgo(),
            this.stepCount,
            this.isAtBridge ? "yes" : "no",
            time);
    }

    private
    boolean _checkAtBridge() {
        final float robotPosition = this.origin + this._x * pxPerStep - Robot.dimensions / 2;

        return robotPosition >= bridgeX && robotPosition <= bridgeX + bridgeWidth;
    }

    private
    void _handleTurn() {
        this._direction *= -1;
        this.turnCount++;
        this._nextTarget = this._getNextTarget();
        this._markerLines.add(
            new Point(this.origin + this._x * pxPerStep - Robot.dimensions / 2, this.y));
    }

    private
    int _calculateMoveDistance() {
        return this.algo.equals("add") ? this.algoFactor * this.turnCount
                                       : int(pow(this.algoFactor, this.turnCount));
    }

    private
    int _getNextTarget() {
        return this._direction == 1 ? this._x + this._calculateMoveDistance()
                                    : this._x - this._calculateMoveDistance();
    }
}
