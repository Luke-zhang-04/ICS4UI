/**
 * Mandelbrot Set
 * @author Luke Zhang
 */

class Complex {
    public
    float real;

    public
    float imaginary;

    public
    Complex(float real, float imaginary) {
        this.real = real;
        this.imaginary = imaginary;
    }

    public
    Complex(float real) {
        this(real, 0);
    }

    public
    void printMe() {
        println(this);
    }

    public
    float absVal() {
        return sqrt(pow(this.real, 2) + pow(this.imaginary, 2));
    }

    public
    Complex add(Complex num) {
        return new Complex(this.real + num.real, this.imaginary + num.imaginary);
    }

    public
    Complex multi(Complex num) {
        return new Complex(
            this.real * num.real - this.imaginary * num.imaginary,
            num.real * this.imaginary + this.real * num.imaginary);
    }

    public
    Complex multiply(Complex num) {
        return this.multi(num);
    }

    public
    Complex copy() {
        return new Complex(this.real, this.imaginary);
    }

    public
    Complex squared() {
        return this.multi(this);
    }

    @Override public String toString() {
        String operator= ""; // Operator is empty by default

        // clang-format off
        if (this.real != 0) {          // If real number isn't 0
            operator = this.imaginary < 0 // Set the operator based on the imaginary part
                ? " - "
                : " + ";
        } else if (this.imaginary < 0) { // If there's no real number, but the imaginary number is
                                         // negative
            operator = "-";              // The "operator" becomes a negative sign
        }
        // clang-format on

        String imaginaryPart = ""; // Imaginary part is empty be default

        if (imaginary != 0) {
            imaginaryPart = this.imaginary == 1 || this.imaginary == -1 // Just have i for 1 and -1
                ? "i"
                : String.format("%.2fi", abs(this.imaginary)); // Add the coefficient to i
        }

        return String.format(
            "%s%s%s",
            // Skip the real number if it is 0, otherwise include it
            this.real == 0 ? "" : String.format("%.2f", this.real),
            operator,
            imaginaryPart);
    }
}
