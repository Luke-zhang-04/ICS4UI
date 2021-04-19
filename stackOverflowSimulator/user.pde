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
    Question askQuestion(String title, String content, long timestamp, String[] tags) {
        return new Question(this, title, content, timestamp, tags);
    }

    public
    Question askQuestion(String title, String content, String[] tags) {
        return new Question(this, title, content, tags);
    }

    public
    void upvote(Item item) {
        item.upvote();
    }

    public
    void downvote(Post post) {
        post.downvote();
    }

    @Override public String toString() {
        return String.format(
            "%s: %d reputation, %d questions, %d answers, and %d comments",
            this.name,
            this.reputation,
            this.questions.size(),
            this.answers.size(),
            this.comments.size());
    }
}
