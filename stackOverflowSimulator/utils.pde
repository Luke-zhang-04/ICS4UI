/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

/**
 * @param content - what to repeat
 * @param amt - number of times to repeat
 * @return string with content repeated amt number of times
 */
String repeat(String content, int amt) {
    return String.join("", Collections.nCopies(amt, content));
}
