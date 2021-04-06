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
    final int algoFactor;

    public
    final int y;

    public
    int distanceTravelled = 0;

    public
    boolean isAtBridge = false;

    /** X index in "meters" */
    private
    int _x;

    private
    int _turnCount = 0;

    private
    float _nextTarget;

    private
    int _direction = 1;

    private
    ArrayList<Point> _markerLines = new ArrayList<Point>();

    public
    Robot(String imagePath, String algo, int algoFactor, int x, int y) {
        this.img = loadImage(imagePath);
        this.algo = algo;
        this.algoFactor = algoFactor;
        this._x = x;
        this._nextTarget = this._x;
        this.y = y;
    }

    public
    void draw() {
        image(
            this.img,
            this._x * pxPerMeter - Robot.dimensions,
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

            this._x += this._direction;

            this.isAtBridge = this._checkAtBridge();
        }
    }

    private
    boolean _checkAtBridge() {
        final int robotPosition = this._x * pxPerMeter - Robot.dimensions / 2;

        return robotPosition >= bridgeX && robotPosition <= bridgeX + bridgeWidth;
    }

    private
    void _handleTurn() {
        this._direction *= -1;
        this._turnCount++;
        this._nextTarget = this._getNextTarget();
        this._markerLines.add(new Point(this._x * pxPerMeter - Robot.dimensions / 2, this.y));
    }

    private
    int _calculateMoveDistance() {
        return this.algo.equals("add") ? this.algoFactor * this._turnCount
                                       : int(pow(this.algoFactor, this._turnCount));
    }

    private
    int _getNextTarget() {
        return this._direction == 1 ? this._x + this._calculateMoveDistance()
                                    : this._x - this._calculateMoveDistance();
    }
}
