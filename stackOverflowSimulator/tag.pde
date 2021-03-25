/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

class Tag {
    public
    final String name;

    public
    final ArrayList<Question> questions = new ArrayList<Question>();

    public
    Tag(String name) {
        this.name = name;
    }

    @Override public String toString() {
        return this.name;
    }
}
