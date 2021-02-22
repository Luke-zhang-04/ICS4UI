/**
 * Trig Table of Values
 * @author Luke Zhang
 */

// Assumption: coefficient and denominator are either nothing or an integer, never a float
final String input = "pi/3"; // Input for increment

class RadianExpression {
    // You can thank LLVM for the newline after access modifiers
    public
    int coefficient;

    public
    int denominator;

    /**
     * Get the radian value for this radian expression
     */
    public
    float getRadians() {
        return this.coefficient * PI / this.denominator;
    }

    public
    RadianExpression(String radians) {
        String[] splitInput = split(radians, "/");

        // Set denominator. if none specified, set denominator to 1.
        this.denominator = splitInput.length == 1 ? 1 : int(splitInput[1]);

        int piIndex = splitInput[0].indexOf("pi");

        // Set coefficient. If none specified, set coefficient to 1.
        this.coefficient = piIndex == 0 ? 1 : int(splitInput[0].substring(0, piIndex));
    }
}


/**
 * Rounds `value` value to the `precision`th decimal place
 * @param value - value to round
 * @param precision - decimal place to round to
 * @returns rounded float
 */
float roundAny(float value, int precision) {
    final float shift = pow(10, precision);

    // Move the decimal place over by precision, round the number, then move the decimal back
    return round(value * shift) / shift;
}

/**
 * Overload for roundAny. Defaults decimal precision to 3
 * @param value - value to round
 */
float roundAny(float value) {
    return roundAny(value, 3);
}

/**
 * Recursively finds the GCD of first and second using Euclids GCD algorithm
 * @param first - first number to get GCD for
 * @param second - second number to get GCD for
 * @returns GCD of first and second
 */
int gcd(int first, int second) {
    int max = first > second ? first : second; // Max is first if first is larger, else second
    int min = first < second ? first : second; // Min is second if second is larger, else first
    int remainder = max % min;                 // Remainder

    // If remainder is 0, return min, else repeat
    return remainder == 0 ? min : gcd(min, remainder);
}

/**
 * Gets fraction for coefficient and denominator with PI in the most simplified form
 * @param coefficient - coefficient for pi to use
 * @param denominator - denominator to use
 */
String createFraction(int coefficient, int denominator) {
    if (coefficient == 0) { // If coefficient is 0
        return "0";         // Return 0
    }

    int gcd = gcd(coefficient, denominator); // Get the GCD
    int newCoefficient = coefficient / gcd;  // Divide by GCD to simplify fraction
    int newDenominator = denominator / gcd;

    if (newCoefficient == 1 && newDenominator == 1) { // If both coefficient and denominator are 1
        return String.format("\u03C0");               // Return just pi
    } else if (newCoefficient == 1) {                 // If coefficient is 1
        return String.format("\u03C0/%d", newDenominator); // Return just pi / denominator
    } else if (newDenominator == 1) {                      // If denominator is 1
        return String.format("%d\u03C0", newCoefficient);  // Return just coefficient * denominator
    }

    // Otherwise, return coefficient * pi / denominator
    return String.format("%d\u03C0/%d", newCoefficient, newDenominator);
}

void setup() {
    size(900, 900);
    background(0);

    final RadianExpression startingValue = new RadianExpression(input);
    final float increment = startingValue.getRadians(); // Increment value for each increment
    final float limit = 2 * PI;                         // When to stop loop
    final int columns = width / 4;                      // Column increment for table

    // Setup canvas and font
    textAlign(CENTER);
    textFont(createFont("SansSerif", 60));

    // Place headers
    fill(255);
    text("\u03B8", columns * 1, 100);
    fill(0, 255, 0);
    text("sin \u03B8", columns * 2, 100);
    fill(255, 0, 0);
    text("cos \u03B8", columns * 3, 100);

    stroke(255);
    line(0, 150, width, 150);

    textFont(createFont("SansSerif", 30)); // Decrease size for table data

    for (int index = 0; index * increment <= limit; index++) {
        final float value = index * increment;    // Value of `x`
        final float row = 150 + 50 * (index + 1); // Row count for y-index

        // Show numbers
        fill(255, 255, 255);
        text(
            createFraction(startingValue.coefficient * index, startingValue.denominator),
            columns * 1,
            row);
        fill(0, 255, 0);
        text(str(roundAny(sin(value))), columns * 2, row);
        fill(255, 0, 0);
        text(str(roundAny(cos(value))), columns * 3, row);
    }
}
