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

    public
    String getQuestionsString() {
        String questionsString = String.format("Questions for tag %s:", this.name);

        for (Question question : this.questions) {
            questionsString += "\n - " + question.title;
        }

        return questionsString.trim();
    }

    @Override public String toString() {
        return this.name;
    }
}
