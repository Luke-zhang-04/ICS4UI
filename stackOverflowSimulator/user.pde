/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

class User {
    public
    final String name;

    public
    int reputation = 0;

    public
    ArrayList<Question> questions = new ArrayList<Question>();

    public
    ArrayList<Answer> answers = new ArrayList<Answer>();

    public
    ArrayList<Comment> comments = new ArrayList<Comment>();

    public
    User(String name) {
        this.name = name;
    }

    public
    Question askQuestion(Question question) {
        this.questions.add(question);

        return question;
    }

    @Override public String toString() {
        return String.format(
            "%s: %d reputation, %d questions, %d answers, and %d comments",
            this.reputation,
            this.questions.size(),
            this.answers.size(),
            this.comments.size());
    }
}
