/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

private
int _answerId = 0;

/**
 * Class for a question
 * Inheritance goes as follows: Answer extends Post extends Item
 */
class Answer extends Post {
    public
    final Question question;

    public
    boolean isBestAnswer = false;

    public
    Answer(User user, Question question, String content, long timestamp) {
        super(user, _answerId, content, timestamp);

        this.question = question;
        user.answers.add(this);
        _answerId++;
    }

    public
    Answer(User user, Question question, String content) {
        super(user, _answerId, content);

        this.question = question;
        user.answers.add(this);
        _answerId++;
    }

    @Override public String toString() {
        return String.format(
            "%sANSWER - %d - by %s\n\n%s\n\nCOMMENTS:\n%s",
            this.isBestAnswer ? "\u2713 " /* Unicode checkmark */ : "",
            this.getScore(),
            this.user.name,
            this.content,
            this.getCommentsString());
    }
}
