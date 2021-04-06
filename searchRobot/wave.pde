/**
 * Bridge-finding Robot Simulator
 * @author Luke Zhang
 */

/**
 * Class that represents a wave (which is admittedly, very ugly)
 */
class Wave {
    public
    int x = round(random(0, width));

    public
    int y = round(random(height / 2 - riverHeight / 2 + 100, height / 2 + riverHeight / 2));

    public
    final int speed = round(random(3, 5));

    public
    final Point anchor1;

    public
    final Point control1;

    public
    final Point anchor2;

    public
    final Point control2;

    public
    Wave() {
        this.anchor1 = new Point(round(random(20, 40)), round(random(40, 50)));
        this.control1 = new Point(
            round(random(this.anchor1.x - 20, this.anchor1.x + 20)),
            round(random(this.anchor1.y - 5, this.anchor1.y + 5)));
        this.anchor2 = new Point(
            round(random(this.anchor1.x + 40, this.anchor1.x + 60)), round(random(40, 50)));
        this.control2 = new Point(
            round(random(this.anchor2.x - 20, this.anchor2.x + 20)),
            round(random(this.anchor2.y - 5, this.anchor2.y + 5)));
    }

    public
    void draw() {
        noFill();
        stroke(#000080);
        strokeWeight(1);

        bezier( // Draw wave with cubic bezier
            this.x - this.anchor1.x,
            this.y - this.anchor1.y,
            this.x - this.control1.x,
            this.y - this.control2.x,
            this.x - this.anchor2.x,
            this.y - this.anchor2.y,
            this.x - this.control2.x,
            this.y - this.control2.y);
    }

    /** Move the wave over */
    public
    void move() {
        this.x -= this.speed;

        if (this.x < 0) {
            this.x = width + 100;
        }
    }
}
